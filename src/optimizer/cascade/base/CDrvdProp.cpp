//---------------------------------------------------------------------------
//	Greenplum Database
//	Copyright (C) 2009 Greenplum, Inc.
//
//	@filename:
//		CDrvdProp.cpp
//
//	@doc:
//		Implementation of derived properties
//---------------------------------------------------------------------------
#include "duckdb/optimizer/cascade/base/CDrvdProp.h"

#include "duckdb/optimizer/cascade/base.h"

#include "duckdb/optimizer/cascade/operators/COperator.h"

#ifdef GPOS_DEBUG
#include "duckdb/optimizer/cascade/error/CAutoTrace.h"

#include "duckdb/optimizer/cascade/base/COptCtxt.h"
#endif	// GPOS_DEBUG

namespace gpopt
{
CDrvdProp::CDrvdProp()
{
}

IOstream &
operator<<(IOstream &os, const CDrvdProp &drvdprop)
{
	return drvdprop.OsPrint(os);
}

}  // namespace gpopt

// EOF
