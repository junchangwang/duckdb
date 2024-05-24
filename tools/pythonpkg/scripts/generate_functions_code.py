import os
import json
import keyword
import textwrap
from collections import Counter
from pathlib import Path
from typing import Any, List, Dict, Tuple

os.chdir(os.path.dirname(__file__))

JSON_FOLDER = Path("../../../src/core_functions")
FUNC_FILE = Path("../duckdb/func.py")


def generate() -> None:
    functions_metadata = parse_json_files(JSON_FOLDER)
    indent = " " * 4

    content = ["from .duckdb import FunctionExpression"]
    for f in functions_metadata:
        function_def: List[str] = []

        name = f["name"]
        if not name.isidentifier() or "lambda" in f["parameters_raw"]:
            # Skip functions with invalid names such as "||", "&", etc.
            # Skip functions which accept lambda functions as there is currently
            # no way to pass a lambda function as an argument to FunctionExpression
            continue

        description = prepare_description(
            description=f["description"], category=f["category"]
        )
        def_parameters, optional_parameter = prepare_parameters(f["parameters_raw"])

        function_def.append(
            f"def {name}({', '.join([p if p != optional_parameter else p + '=None' for p in def_parameters])}) -> FunctionExpression:"
        )
        function_def.append(f'{indent}"""{description}"""')

        expression_parameters = [p for p in def_parameters if p != "/"]
        if optional_parameter:
            function_def.append(f"{indent}if {optional_parameter} is None:")
            function_def.append(
                f'{indent * 2}return FunctionExpression("{name}", {", ".join([p for p in expression_parameters if p != optional_parameter])})'
            )
        function_def.append(
            f'{indent}return FunctionExpression("{name}", {", ".join(expression_parameters)})'
        )

        content.append("\n".join(function_def))

    with FUNC_FILE.open("w", encoding="utf-8") as f:
        f.write("\n\n".join(content))


_FunctionsMetadata = List[Dict[str, str]]


def parse_json_files(json_folder: Path) -> _FunctionsMetadata:
    """Parses the json files in core_functions. Code is based on
    https://github.com/duckdb/duckdb-web/blob/main/scripts/generate_function_json.py
    """
    json_files = list(json_folder.glob("**/*.json"))
    assert len(json_files) > 10

    functions_metadata: _FunctionsMetadata = []
    for file in json_files:
        category = file.parent.stem
        with file.open() as fh:
            for function in json.load(fh):
                f_info = {
                    "name": clean_function_name(function["name"]),
                    "parameters_raw": (function.get("parameters", "")),
                    "description": function["description"].strip(),
                    "category": category,
                }
                functions_metadata.append(f_info)
                aliases = function.get("aliases", [])
                for alias in aliases:
                    functions_metadata.append(
                        {
                            **f_info,
                            "name": clean_function_name(alias),
                            "description": (
                                f_info["description"] + f"\nAlias for {f_info['name']}"
                            ).strip(),
                        }
                    )

    return functions_metadata


def clean_function_name(name: str) -> str:
    return name.replace("__postfix", "")


def prepare_description(description: str, category: str) -> str:
    if description:
        description = description.removesuffix(".") + ". "
    description += "Function category: " + category.title()
    description = "\n".join(
        textwrap.wrap(
            description, width=80, initial_indent="", subsequent_indent=" " * 4
        )
    )
    return description


def prepare_parameters(parameters_raw: str) -> Tuple[List[str], str | None]:
    parameters_raw = parameters_raw.strip()
    if not parameters_raw:
        return [], None

    # Check if any optional arguments at the end. Right now this only happens
    # for list_slice and it only is for one argument. We raise below if there
    # would ever be a function with multiple optional arguments -> Would need to
    # adapt this code.
    parameters: List[str]
    optional_parameter: str | None = None
    if parameters_raw.endswith("]"):
        assert (
            parameters_raw.count("[") == 1 and parameters_raw.count("]") == 1
        ), "Only one optional argument is supported in this script"
        parameters_raw, optional_parameter = parameters_raw.split("[,")
        optional_parameter = optional_parameter.removesuffix("]").strip()

        parameters = parameters_raw.split(",") + [optional_parameter]
    else:
        parameters = parameters_raw.split(",")
    parameters = [p.strip() for p in parameters]
    # Some functions such as `translate` have parameter names which are keywords
    # in Python
    parameters = [p + "_" if keyword.iskeyword(p) else p for p in parameters]

    # Functions such as array_cross_product have parameters with the same name.
    # We need to enumerate them so they are unique. We start enumerating with 1
    # as this is also used for other functions where parameters are already
    # deduplicated such as for array_cosine_similarity.
    duplicated_parameter_number = {
        p: 1 for p, count in Counter(parameters).items() if count > 1
    }

    deduplicated_parameters: List[str] = []
    for p in parameters:
        if p in duplicated_parameter_number:
            deduplicated_parameters.append(f"{p}{duplicated_parameter_number[p]}")
            duplicated_parameter_number[p] += 1
        else:
            deduplicated_parameters.append(p)

    # If a variable number of parameters are allowed, it's represented as "...",
    # for example "any, ..." which would mean that one value is required (any) and then
    # any number of values can be passed or none. Sometimes, the "..." includes
    # already a name such as "parameters...". We use "*args" for "..." and else
    # the existing name, e.g. "*parameters".

    # We also make parameters positional-only to have more flexibility in the future
    # to rename them. Are they stable across duckdb versions or can there
    # be breaking changes through renames? That would not be an issue in SQL
    # but would be in Python.
    # If there is such a variable number of parameters, we need to add a "/" before
    # them to make the previous one positional-only. Else, "/" is to be placed at
    # the end.
    prepared_parameters: List[str] = []
    has_variable_args = False
    for idx, p in enumerate(deduplicated_parameters):
        if p == "...":
            if not has_variable_args and idx > 0:
                # Only add it if there was a parameter before
                prepared_parameters.append("/")
            prepared_parameters.append("*args")
            has_variable_args = True
        elif p.endswith("..."):
            if not has_variable_args and idx > 0:
                # Only add it if there was a parameter before
                prepared_parameters.append("/")
            prepared_parameters.append(f"*{p.removesuffix('...')}")
            has_variable_args = True
        else:
            prepared_parameters.append(p)

    if not has_variable_args and prepared_parameters:
        prepared_parameters.append("/")

    return prepared_parameters, optional_parameter


if __name__ == "__main__":
    generate()
