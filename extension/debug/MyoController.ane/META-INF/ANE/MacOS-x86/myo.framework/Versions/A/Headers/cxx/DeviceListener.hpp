// Copyright (C) 2013-2014 Thalmic Labs Inc.
// Confidential and not for redistribution. See LICENSE.txt.
#ifndef MYO_CXX_DEVICELISTENER_HPP
#define MYO_CXX_DEVICELISTENER_HPP

#include <stdint.h>

#include "Pose.hpp"

namespace myo {

class Myo;
template<typename T>
class Quaternion;
template<typename T>
class Vector3;

/// Enumeration identifying a right arm or left arm.
enum Arm {
    armLeft = libmyo_arm_left,
    armRight = libmyo_arm_right
};

/// A DeviceListener receives events about a Myo.
/// @see Hub::addListener()
class DeviceListener {
public:
    virtual ~DeviceListener() {}

    /// Called when a Myo has been paired.
    virtual void onPair(Myo* myo, uint64_t timestamp) {}

    /// Called when a paired Myo has been connected.
    virtual void onConnect(Myo* myo, uint64_t timestamp) {}

    /// Called when a paired Myo has been disconnected.
    virtual void onDisconnect(Myo* myo, uint64_t timestamp) {}

    /// @cond MYO_INTERNALS

    /// Called when a paired Myo recognizes that it is on an arm.
    virtual void onArmRecognized(Myo* myo, uint64_t timestamp, Arm arm) {}

    /// Called when a paired Myo is moved or removed from the arm.
    virtual void onArmLost(Myo* myo, uint64_t timestamp) {}

    /// @endcond

    /// Called when a paired Myo has provided a new pose.
    virtual void onPose(Myo* myo, uint64_t timestamp, Pose pose) {}

    /// Called when a paired Myo has provided new orientation data.
    virtual void onOrientationData(Myo* myo, uint64_t timestamp, const Quaternion<float>& rotation) {}

    /// Called when a paired Myo has provided new accelerometer data in units of g.
    virtual void onAccelerometerData(Myo* myo, uint64_t timestamp, const Vector3<float>& accel) {}

    /// Called when a paired Myo has provided new gyroscope data in units of deg/s.
    virtual void onGyroscopeData(Myo* myo, uint64_t timestamp, const Vector3<float>& gyro) {}

    /// Called when a paired Myo has provided a new RSSI value.
    /// @see Myo::requestRssi() to request an RSSI value from the Myo.
    virtual void onRssi(Myo* myo, uint64_t timestamp, int8_t rssi) {}
};

} // namespace myo

#endif // MYO_CXX_DEVICELISTENER_HPP
