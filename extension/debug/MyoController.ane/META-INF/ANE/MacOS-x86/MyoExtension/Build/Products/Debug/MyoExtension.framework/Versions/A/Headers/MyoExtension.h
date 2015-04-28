/*
 * AIR_COMMANDS.H
 * Native entry point for Adobe AIR
 *
 * Copyright 2011 Simplified Logic, Inc.  All Rights Reserved.
 * Author: Andrew Westberg
 */

#ifndef __AIR_COMMANDS_H_
#define __AIR_COMMANDS_H_

//#include "nlm_constants.h"
//#include "nlm_commands.h"
#include "FlashRuntimeExtensions.h"

#ifdef __cplusplus
extern "C" {
#endif
    void MyoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions);
    void MyoContextFinalizer(FREContext ctx);
    void MyoExtInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer);
    void MyoExtFinalizer(void* extData);
    
#ifdef __cplusplus
} //extern "C"
#endif

#endif //__AIR_COMMANDS_H_