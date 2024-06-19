import json
import keyword
import os
import itertools as it
import textwrap
from collections import Counter
from dataclasses import dataclass
from pathlib import Path
from subprocess import check_output
from typing import Dict, List, Tuple, Optional

os.chdir(os.path.dirname(__file__))

FUNC_FILE = Path("../duckdb/func.py")


@dataclass
class FunctionMetaData:
    name: str
    description: str
    all_parameter_combinations: List[List[str]]
    has_variable_parameters: bool


def generate() -> None:
    functions_metadata = get_functions_metadata()
    indent = " " * 4

    content = [
        "# NOTE: This file is automatically generated by tools/pythonpkg/scripts/generate_functions_code.py.\n"
        + "# Do not edit this section manually, your changes will be overwritten!\n\n"
        + "from duckdb import FunctionExpression"
    ]
    for f in functions_metadata:
        function_def: List[str] = []

        name = f.name
        if not name.isidentifier() or any("lambda" in p for combo in f.all_parameter_combinations for p in combo):
            # Skip functions with invalid names such as "||", "&", etc.
            # Skip functions which accept lambda functions as there is currently
            # no way to pass a lambda function as an argument to FunctionExpression
            continue

        # Variable number of arguments are represented by a single "*args" parameter.
        def_parameters: List[str]
        all_parameters: List[str]
        if f.has_variable_parameters:
            def_parameters = ["*args"]
            all_parameters = def_parameters
        else:
            # All parameters which do not appear in every parameter combination
            # have to be made optional.
            # Use the approach below instead of a list to keep the order of
            # the parameters
            all_parameters: list[str] = []
            for combo in f.all_parameter_combinations:
                for p in combo:
                    if p not in all_parameters:
                        all_parameters.append(p)

            # Make sure that parameters in combinations appear always in the exact same order
            # and that no parameters are skipped. This is important
            # as we pass the parameters as positional arguments to FunctionExpression.
            for combo in f.all_parameter_combinations:
                assert all_parameters[:len(combo)] == combo, f"Parameters in combination {combo} are not in the same order as in all the parameters: {all_parameters}"

            optional_parameters = [
                p for p in all_parameters if not all(p in combo for combo in f.all_parameter_combinations)
            ]

            def_parameters = [p for p in all_parameters if p not in optional_parameters]
            def_parameters.extend([f"{p}=None" for p in optional_parameters])
            if def_parameters:
                # We make parameters positional-only to have more flexibility in the future
                # to rename them. Maybe they are not stable across duckdb versions.
                # That would not be an issue in SQL but would be in Python.
                # We do this by placing "/" at the end.
                def_parameters.append("/")

        def_parameters_str = ", ".join(def_parameters)
        function_def.append(f"def {name}({def_parameters_str}) -> FunctionExpression:")
        function_def.append(f'{indent}"""{f.description}"""')

        if not f.has_variable_parameters and len(f.all_parameter_combinations) > 1:
            # For all combinations of parameters, add an if statement
            # with a return statement. Start with the longest combination as this
            # is the most specific one. Else, a less specific combination would
            # be matched first in the if-elif-else chain.
            for idx, combo in enumerate(sorted(f.all_parameter_combinations, key=len, reverse=True)):
                expressions = (
                    [f"{p} is not None" for p in combo]
                    # Also make sure that all other parameters are None
                    # as they will not be passed to the FunctionExpression
                    # in the generated code.
                    + [f"{p} is None" for p in all_parameters if p not in combo]
                    if len(combo) > 0
                    # This is the case if all parameters are optional and none are provided
                    else [f"{p} is None" for p in all_parameters]
                )
                function_def.append(f"{indent}{'if' if idx == 0 else 'elif'} {' and '.join(expressions)}:")
                return_statement = make_return_statement(name, combo)
                function_def.append(f"{indent*2}{return_statement}")
            # We add an else statement to catch the case where none of the above
            # if-elif statements matched. This very likely means that the combination
            # of parameters is not valid but we still pass it to FunctionExpression
            # to let duckdb show an error message as that message is more informative than what
            # we could provide here.
            return_statement = make_return_statement(name, all_parameters)
            function_def.append(f"{indent}else:")
            function_def.append(f"{indent*2}# This combination of parameters might not be valid or can be the same as one of the combinations above")
            function_def.append(f'{indent*2}{return_statement}')
        else:
            # The return statement if all parameters are provided
            return_statement = make_return_statement(name, ["*args"] if f.has_variable_parameters else all_parameters)
            function_def.append(f"{indent}{return_statement}")

        content.append("\n".join(function_def))

    with FUNC_FILE.open("w", encoding="utf-8") as f:
        # New line at the end of the file to make black formatter happy
        f.write("\n\n\n".join(content) + "\n")


def make_return_statement(function_name: str, expression_parameters: List[str]) -> str:
    statement = f'return FunctionExpression("{function_name}"'
    if expression_parameters:
        statement += ", " + ", ".join(expression_parameters)
    return statement + ")"


_FunctionsMetadata = List[FunctionMetaData]


def get_functions_metadata() -> _FunctionsMetadata:
    """Parses the json files in core_functions. Code is partially based on
    https://github.com/duckdb/duckdb-web/blob/main/scripts/generate_function_json.py
    but we get the information from duckdb_functions instead of the JSON files as the
    later do not contain information on all functions.
    """
    # In this list, you can have multiple entries per function_name if the function
    # accepts different combinations of parameters. We handle this further below
    functions = get_duckdb_functions()

    keyfunc = lambda x: x["function_name"]
    functions = sorted(functions, key=keyfunc)

    # This list will have only one entry per function_name
    functions_metadata: _FunctionsMetadata = []
    for function_name, grouped_metadata in it.groupby(functions, keyfunc):
        grouped_metadata = list(grouped_metadata)
        if any(g["varargs"] for g in grouped_metadata):
            assert all(g["varargs"] for g in grouped_metadata), "This case is not handled"
            has_variable_parameters = True

            # No need to record any parameter names as we can just use a single *args
            # statement in the Python function definition. That's the easiest for now
            # based on the metadata we get from duckdb_functions.
            all_parameter_combinations = []
        else:
            has_variable_parameters = False
            all_parameter_combinations = [m["parameters"] for m in grouped_metadata]
            all_parameter_combinations = deduplicate_parameter_names(all_parameter_combinations)

        assert (
            len(set(m["description"] for m in grouped_metadata)) == 1
        ), "Descriptions are expected to be all the same."
        description = prepare_description(grouped_metadata[0]["description"])
        metadata = FunctionMetaData(
            name=function_name,
            all_parameter_combinations=all_parameter_combinations,
            description=description,
            has_variable_parameters=has_variable_parameters,
        )
        functions_metadata.append(metadata)
    return functions_metadata


def deduplicate_parameter_names(all_parameter_combinations: List[List[str]]) -> List[List[str]]:
    # Functions such as `array_cross_product` have parameters with the same name.
    # We need to enumerate them so they are unique. We start enumerating with 1
    # as this is also used for other functions where parameters are already
    # deduplicated such as for array_cosine_similarity.
    # We do this across all parameters for the function so that e.g. the function `age`
    # which has combinations [["timestamp"], ["timestamp", "timestamp"]]
    # will have the parameters [["timestamp1"], ["timestamp1", "timestamp2"]]
    # and not [["timestamp"], ["timestamp1", "timestamp2"]]

    duplicated_parameters = set()
    for combo in all_parameter_combinations:
        for p, count in Counter(combo).items():
            if count > 1:
                duplicated_parameters.add(p)

    deduplicated_parameter_combinations: List[List[str]] = []
    if duplicated_parameters:
        for combo in all_parameter_combinations:
            duplicated_parameter_number = {p: 1 for p in duplicated_parameters}
            deduplicated_parameters: List[str] = []
            for p in combo:
                if p in duplicated_parameter_number:
                    deduplicated_parameters.append(f"{p}{duplicated_parameter_number[p]}")
                    duplicated_parameter_number[p] += 1
                else:
                    deduplicated_parameters.append(p)
            deduplicated_parameter_combinations.append(deduplicated_parameters)
    else:
        deduplicated_parameter_combinations = all_parameter_combinations
    return deduplicated_parameter_combinations

def get_duckdb_functions() -> List[Dict[str, str]]:
    out = check_output(
        [
            "duckdb",
            "-json",
            "-c",
            "select distinct function_name, description, parameters, varargs"
            + " from duckdb_functions() where function_type in ('scalar', 'aggregate', 'macro')"
            # Exclude functions which are internal
            + " and function_name not like '$_%' escape '$'",
        ]
    )
    # Replace \t as it raises an error that it's an invalid control character. It only
    # appears in 1 description of a function so far.
    functions = []
    for line in out.decode("utf-8").strip().removeprefix("[").removesuffix("]").splitlines():
        r = json.loads(line.removesuffix(",").replace("\t", ""))
        r["parameters_raw"] = r["parameters"]
        r["parameters"] = parse_parameters(r["parameters_raw"])
        r["function_name"] = clean_function_name(r["function_name"])
        r["vargs"] = r["varargs"].strip() if isinstance(r["varargs"], str) else r["varargs"]
        functions.append(r)

    assert (
        len(functions) > 100
    ), "Something seems wrong with the discovery of the functions. We'd expect many more functions."
    return functions


def parse_parameters(parameters_raw: str) -> list[str]:
    parameters_raw = parameters_raw.strip()
    if not parameters_raw or parameters_raw == "[]":
        return []

    assert (
        parameters_raw.startswith("[") and parameters_raw.endswith("]") and len(parameters_raw) > 2
    ), f"Invalid parameters: {parameters_raw}"

    # Should look like '[param1, param2]'.
    # Functions with optional arguments appear multiple times, once per possible
    # combination of arguments. Sometimes, the optional argument is also wrapped in
    # square brackets such as for list_slice. As this is not done consistently,
    # and as we don't need the square brackets (as we already have this
    # information due to the functions appearing multiple times), we remove
    # the square bracketes here.
    parameters = [p.strip() for p in parameters_raw.replace("[", "").replace("]", "").split(",")]

    # Some functions such as `translate` have parameter names which are keywords
    # in Python
    parameters = [p + "_" if keyword.iskeyword(p) else p for p in parameters]
    return parameters


def clean_function_name(name: str) -> str:
    return name.replace("__postfix", "")


def prepare_description(description: str | None) -> str:
    if not description:
        return ""
    description = "\n".join(textwrap.wrap(description.strip(), width=80, initial_indent="", subsequent_indent=" " * 4))
    return description


def removesuffix(string: str, suffix: str) -> str:
    if string.endswith(suffix) and suffix:
        return string[: -len(suffix)]
    return string


if __name__ == "__main__":
    generate()
