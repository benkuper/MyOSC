MyOSC
=====

## How it works

MyOSC is OSC Bridge made with Adobe AIR that let users easily send data from one or multiple Myos to one or multiple targets, with an easy interface.
MyOSC can also receive vibrate OSC messages from applications to make the connected myo vibrate

### Installation / Usage

Windows : Install using the MyOSC.exe in the "installers" folder.

Mac : Install using the MyOSC.dmg in the "installers" folder. You might need to copy "myo.framework" included in the root folder of this repository into the "~/Library/Frameworks" folder of your computer.
Also, since Adobe changed it's native extensions architecture in Adobe AIR 20, you need to keep your AIR version to 19 in order to work, otherwise you'll get a "The required native extension is missing…" error.


When installed, application should open full screen.
- Hit "Escape" to hide it.
- Left click on the system tray icon to open it again
- Right click > Exit to close it

- Left Click on a Myo Feedback node to see more informations, activate / deactivate auto-lock, emg streaming, etc.
- Right Click on a Myo Feedback node to offset the Yaw. The compensation assumes that your arm is pointing forward when calibrating.

- Add a preset using the top left button
- Left click on a preset to select it
- Right Click on a preset to rename it (Enter to validate)
- Shift+Left click on a preset to save the current configuration into it

- When registering from the target software : send an OSC Message to "/myosc/register" on port 9000, with 3 arguments (string, string, int) : connectionID (arbitrary) / host (your IP) / port (to receive OSC Messages)
- To unregister, just send "/myosc/unregister" on port 11000, with 1 argument (string) : connectionID (the one used to register)
- To send a vibrate message, send "/myosc/vibrate" on port 11000
 - 0 argument = vibrate all myos with default duration 0 (= SHORT)
 - 1 argument INTEGER = vibrate all myos with set duration (0 = SHORT, 1=MEDIUM, 2=LONG)
 - 1 argument STRING = vibrate specific myo (argument is Mac Address of the myo) with default duration 0
 - 2 arguments STRING INT = vibrate specific myo with set duration

### Features

- Connect with multiple Myos
- Live creation / removal of OSC targets
- Orientation (Yaw/Pitch/Roll), Pose, Gyroscope, Accelerometer and EMG data streaming
- Per target data filtering
- Support for disabling Myo auto-lock mode
- One Click Saving / Loading presets
- OSC target registration (the target application can send an OSC Message to register into the bridge)
- Vibrate Myo via OSC, by ID or all at once
- Easy absolute yaw calibration

This project is done on my spare time, if you feel like it you can donate whatever you want !
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=bkuperberg%40hotmail%2ecom&lc=US&item_name=Ben%20Kuper&item_number=open_paypal_donate&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" /></a>
