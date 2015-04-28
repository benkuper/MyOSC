//
//  MyoExtension.cpp
//  MyoExtension
//
//  Created by Ben Kuper on 11/06/14.
//  Copyright (c) 2014 Ben Kuper. All rights reserved.
//

#include "MyoExtension.h"

#include "myo/myo.hpp"

#include <stdlib.h>
#include <stdio.h>

using namespace std;
using namespace myo;


pthread_t runThread;
bool exitRunThread;

class MyoData
{
    public :
    Myo * myo;
    
    string id;
    
    string pose;
    double yaw;
    double pitch;
    double roll;
    
};

vector<MyoData *> myoDatas;

MyoData * getMyoData(Myo * myo)
{
    for (size_t i = 0; i < myoDatas.size(); ++i) {
        // If two Myo pointers compare equal, they refer to the same Myo device.
        if (myoDatas[i]->myo == myo) {
            return myoDatas[i];
        }
    }
    
    printf("Myo Not found by mac address : %s\n",myo->macAddressAsString().c_str());
    return NULL;
}

MyoData * getMyoByMacAddress(const char * macAddress)
{
    //printf("Get Myo by aAddress : %s\n",macAddress);
    for (size_t i = 0; i < myoDatas.size(); ++i) {
        // If two Myo pointers compare equal, they refer to the same Myo device.
        if (strcmp(myoDatas[i]->myo->macAddressAsString().c_str(),macAddress) == 0) {
            return myoDatas[i];
        }
    }
    
    //printf("Myo Not found by mac address : %s\n",macAddress);
    return NULL;
}


class MyoListener : public myo::DeviceListener {
public:
    MyoListener()
    {
        printf("Myo listener creation\n");
    }
    
    void onPair(myo::Myo* myo, uint64_t timestamp)
    {
        MyoData * data = new MyoData();
        data->myo = myo;
        data->id = myo->macAddressAsString();
        data->yaw = 0;
        data->pitch = 0;
        data->roll = 0;
        data->pose = "none";
        myoDatas.push_back(data);
        
        
        // Now that we've added it to our list, get our short ID for it and print it out.
        printf("Myo paired, assigned ID : %s\n",myo->macAddressAsString().c_str());
        
        // Check whether this Myo device has been trained. It will only provide pose information if it's been trained.
        if (myo->isTrained()) {
            printf("Myo %s is trained\n",myo->macAddressAsString().c_str());
        } else {
            printf("Myo %s is NOT trained\n",myo->macAddressAsString().c_str());
        }
    }
    
    void onPose(Myo* myo, uint64_t timestamp, myo::Pose pose)
    {
        //int myoID = identifyMyo(myo);
        printf("Myo %s has detected pose : %s\n",myo->macAddressAsString().c_str(),pose.toString().c_str());
        
        MyoData * mData = getMyoData(myo);
        mData->pose = pose.toString();
    }
    
    void onConnect(Myo* myo, uint64_t timestamp)
    {
        printf("Myo %s has connected\n",myo->macAddressAsString().c_str());
    }
    
    void onDisconnect(Myo* myo, uint64_t timestamp)
    {
        printf("Myo %s has disconnected\n",myo->macAddressAsString().c_str());
    }
    
    // onOrientationData() is called whenever the Myo device provides its current orientation, which is represented
    // as a unit quaternion.
    void onOrientationData(Myo* myo, uint64_t timestamp, const Quaternion<float>& quat)
    {
        using std::atan2;
        using std::asin;
        using std::sqrt;
        
        // Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
        double roll = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                            1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
        
        double pitch = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
        
        double yaw = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                           1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));
        
        MyoData * mData = getMyoData(myo);
        
        mData->yaw = yaw;
        mData->pitch = pitch;
        mData->roll = roll;
        
        //printf("> yaw %f\n",yaw);//,mData->data.yaw,mData.pitch,mData.roll);
    }
};

void *MyoRunThread(FREContext ctx)
{
    printf("myo run thread creation and init !\n");
    myo::Hub hub;
    hub.pairWithAnyMyo();
    printf("Hub :: pairWithAnyMyo\n");
    
    MyoListener mListener;
    hub.addListener(&mListener);
    
    while(!exitRunThread)
    {
        hub.run(10);
        FREDispatchStatusEventAsync(ctx,(const uint8_t *)"data",(const uint8_t *)"myo");
    }
    
    printf("Exit Run Thread !\n");
    return 0;
}

/*
 * AIR_COMMANDS.C
 * Exported functions for Adobe AIR (and related non-exported functions)
 *
 * Copyright 2011 Simplified Logic, Inc.  All Rights Reserved.
 *
 * Written by Andrew Westberg
 */


#ifdef __cplusplus
extern "C" {
#endif
    
    
    FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
    {
        
        printf("Myo Extension :: init\n");
        bool success = true;
        
        try
        {
            int pThreadResult = false;
            pThreadResult = pthread_create(&runThread, NULL, MyoRunThread,ctx);
            
            if (pThreadResult){
                FREDispatchStatusEventAsync(ctx,(const uint8_t *)"msg",(const uint8_t *)"MyoExtension :: Error on Myo run thread creation\n");
            }
            
        }catch(const std::exception& e)
        {
            printf("MyoExtension :: Error on Myo Init (%s)\n",e.what());
            
            FREDispatchStatusEventAsync(ctx,(const uint8_t *)"error",(const uint8_t *)e.what());
            success = false;
        }
        
        FREObject result;
        FRENewObjectFromBool(success,&result);
        return result;
    
    }
    
    FREObject update(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
    {
        
        //printf("Update Native\n");
        
        FREObject controller = argv[0];
        
        
        int dLen = myoDatas.size();
        for(int i=0;i < dLen ;i++)
        {
            
            //printf("update Myo %i --> ",i);
            MyoData * mData = myoDatas[i];
            
            
            const uint8_t * mID = reinterpret_cast<const uint8_t*>(&(mData->id.c_str())[0]);
            int midl = mData->id.length(); //to change
            
            
            const uint8_t * pID = reinterpret_cast<const uint8_t*>(&(mData->pose.c_str())[0]);
            int pidl = mData->pose.length(); //to change
            
            //printf("MID= %s\n",mID);
            
            FREObject data[5];
            FRENewObjectFromUTF8(midl,mID,&data[0]); //id
            FRENewObjectFromUTF8(pidl,pID,&data[1]); //pose
            FRENewObjectFromDouble(mData->yaw,&data[2]); //yaw
            FRENewObjectFromDouble(mData->pitch,&data[3]); //pitch
            FRENewObjectFromDouble(mData->roll,&data[4]); //roll
            
            FREObject res;
            FREResult fre = FRECallObjectMethod(controller,(const uint8_t*)"updateMyoData",5,data,&res,NULL); //AS3 updateMyoData(id:String,pose:String,yaw:Number,pitch:Number,roll:Number)
            
            //printf("Call method : %i\n",fre);
        }
        
        
        FREObject result;
        FRENewObjectFromBool(true,&result);
        return result;
        
    }
    
    FREObject vibrate(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
    {
        
        const uint8_t* macAddress;
        uint32_t macLength;
        FREGetObjectAsUTF8(argv[0],&macLength,&macAddress);
        Myo * myo = getMyoByMacAddress((const char *)macAddress)->myo;
        
        int vibType;
        FREGetObjectAsInt32(argv[1],&vibType);
        Myo::VibrationType vibrationType = myo->vibrationShort; //safe assigning
        
        if(vibType == 0) vibrationType = myo->vibrationShort;
        else if(vibType == 1) vibrationType = myo->vibrationMedium;
        else if(vibType == 2) vibrationType = myo->vibrationLong;
        
        myo->vibrate(vibrationType);
        
        FREObject result;
        FRENewObjectFromBool(true,&result);
        return result;
        
    }
    
    FREObject isMyoTrained(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
    {
        const uint8_t* macAddress;
        uint32_t macLength;
        FREGetObjectAsUTF8(argv[0],&macLength,&macAddress);
        
        Myo * myo = getMyoByMacAddress((const char *)macAddress)->myo;
        
        FREObject result;
        FRENewObjectFromBool(myo->isTrained(),&result);
        return result;
    }
    

    
    FREObject stop(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
    {
        
        printf("[Stop from Extension OSX]\n");
        
        exitRunThread = true;
        
        FREObject result;
        FRENewObjectFromBool(true,&result);
        return result;
        
    }
    
    void MyoContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctions, const FRENamedFunction** functions)
    {
        
        printf("** Myo Extension OSX v0.1 by Ben Kuper\n");
        
        FRENamedFunction *func;
        
        *numFunctions = 5;
        
        func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctions));
        
        
        func[0].name = (const uint8_t*) "init";
        func[0].functionData = NULL;
        func[0].function = &init;
        
        func[1].name = (const uint8_t*) "update";
        func[1].functionData = NULL;
        func[1].function = &update;
        
        func[2].name = (const uint8_t*) "vibrate";
        func[2].functionData = NULL;
        func[2].function = &vibrate;
        
        func[3].name = (const uint8_t*)"isMyoTrained";
        func[3].functionData = NULL;
        func[3].function = &isMyoTrained;
        
        func[4].name = (const uint8_t*) "stop";
        func[4].functionData = NULL;
        func[4].function = &stop;
        
        *functions = func;
    }
    
    void MyoContextFinalizer(void* extData)
    {
    }
    
    
    void MyoExtInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
    {
        *ctxInitializer = &MyoContextInitializer;
        *ctxFinalizer = &MyoContextFinalizer;
    }
    
    void MyoExtFinalizer(void* extData)
    {
    }

    
#ifdef __cplusplus
} //extern "C"
#endif