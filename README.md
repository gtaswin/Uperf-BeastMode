# Uperf-BeastMode

Uperf-BeastMode is a fork of the powerful Uperf project, tailored for enthusiasts seeking the ultimate performance on their devices. This modified version includes custom kernel tweaks and a startup script designed to maximize CPU and GPU efficiency, ensuring a smoother user experience during gaming and heavy workloads.

## Main features

-Based according to the type of scenario, dynamically set the parameter control performance release, and support all `sysfs` nodes
-In relevant threads to support dynamic binding apps that are operating apps to large nuclear clusters
-State the input signal of Android from the Linux level, identify and slide
-A active sampling system load, identification, such as the instantaneous load of APP startup
-Sun listening to the CPUSET group update operation, identify the switching of the operating APP
-Suki wake -up lock update operation, identify whether the screen goes off
-Dyrothermal notifications injected into the Hook sent to SurfaceFlinger to identify the beginning of rendering start, lag, end
-Ch support android 6.0-12
-Profile ARM64-V8A
-In support Magisk method one -click installation, the version is not less than 20.4+
-It does not depend on Magisk, you can install manually
-Sleinux can keep `ENFORCING`
-For the framework of any Android application layer and third -party kernel
-Super the configuration file for most popular hardware platforms

## download

https://github.com/yc9559/Uperf/releases

## Install

### Magisk method

1. After downloading, use Magisk Manager, and the Magisk version is not less than 18.0
2. After restarting, check the `/sdcard/Android/YC/UPERF/UPERF_LOG.TXT` to check whether the UPERF is normal to start

### Manual installation

1. If your device cannot install Magisk, and has obtained the root permission
2. Manually decompress after downloading, such as decompression to `/data/uperf`
3. Modify `setup_uperf.sh`, run_uperf.sh`,` initsvc_uperf.sh`
4. Execute `setup_uperf.sh` to complete the installation, check whether there is an error in the output information
5. Perform `run_uperf.sh` Start uprf to check whether there is an error in the output information
6. Open the `/data/cache/injector.log` to check whether the sfanalysis injection is successful
7. If the association starts to a third -party app, set up after the boot is completed `run_uperf.sh`
8.
9. After restarting, check the `/sdcard/yc/uperf/uprf_log.txt` to check whether the UPERF is normal to start

### Performance mode switch

#### Modify the default performance mode at the startup

1. Open `/sdcard/Android/yc/uperf/cur_powermode.txt`
2. Modify `Auto`, where` auto` is the default performance mode used after booting. The optional mode is: -` AUTO` A dynamic response based on the app used -`BALANCE` Balanced mode, slightly smoother than the original factory, saves power -`PowerSave` Katton mode, ensure basically smooth and reduce power consumption as much as possible -`Performance`Feed power model, ensure that electricity is more smooth at the same time -` Fast` Performance mode, more aggressive than the equilibrium mode
3. Restart

#### After starting, switch performance mode

Method 1:
Execute the `sh /data/Powercfg.sh Balance`, where the` Balance` is the name of the performance mode that wants to switch.

Method 2:
Install [Scene] (https://www.coolapk.com/apk/com.comarea.vtools) to bind the corresponding performance patterns of the APP.

# All Common questions

Q: Does the power consumption have a negative impact?
A: The implementation of UPERF has made a lot of low power consumption optimization, and the power consumption overhead it operates is very low.In addition, in the standby mode of the prefabricated configuration file, the core quantity of wake -up when standing is reduced and conservatively raising parameters are used.The optimization of standby power consumption mainly depends on the proportion of wake -up duration. On the basis of this, UPERF can further reduce the standby power consumption.

Q: Why is UPERF still costly?
A: The power consumption of the AP of the SOC mainly depends on the amount of calculation and the frequency of use.UPERF can only control performance release, and the selection of frequency points to reduce power consumption. If the calculation of the background app is large, it cannot be significantly extended.This problem can be located through the process manager of the SCENE toolbox.

Q: Do you need to close the temperature control of the system?
A: System temperature control is a hardware protection measure, or it is used to improve the user experience under high negative load.In most cases, it is not necessary to turn off it. If you encounter serious performance, such as running a competitive game CPU to the maximum frequency limit at 1.4GHz, please increase the threshold of temperature control intervention or turn off the system temperature control.

Q: What is the relationship between UPERF and Scene toolbox?
A: These two software operate independently and do not depend on each other.UPERF implements the interface to call the SCENE toolbox, such as performance mode switching and the APP performance mode.If you do not install the Scene toolbox, you can also switch performance mode. For details, please refer to the usage method.

Q: Do you still need to close the system's Performance Boost?
A: The script in the UPERF module has closed most of the mainstream user mode and kernels. If there are unconventional up -frequency, users need to close themselves.

Q: I encountered some strange system failures. What's going on?
A: UPERF can work normally on most platforms. The following possible faults are collected during the test stage:

-The desktop promoter does not respond to touch.This is currently only encountered in MIUI 12. If you encounter this problem, please delete `/data/adb/modules/uprf/enable_sfanalysis`
-The touch screen is lost.Please check if you use apps such as automatic skipping, especially supporting coordinates clicks
-Dhine.User state applications do not affect system stability in theory. Please replace it with official kernel and ROM

Q: Reminder `not supporth when installing with Magisk, why is this?
A: This hardware platform does not have a prefabricated file, which may need to be adapted by itself.

## Detailed introduction

This is in [Project Wipe] (https://github.com/yc9559/cpufreq-pipe-opt), [Project Wipe v2] (https://github.com/yc9559/wipe- v2), [perfd-opt)] (https://github.com/yc9559/Perfd-opt), [qti-Mem-opt] (https://github.com/yc9559/qti-Mem-opt).In the previous work, it is often based on an existing performance controller, which also means that it can be achieved in the end. It depends on the upper limit of the controller itself.After the EAS scheduler becomes the mainstream, the WIPE series cannot be applied, because the parameter freedom of the EAS is too small. It is not until the Qualcomm Boost framework has achieved a wider range of adjustments, and Perfd -opt is available.On the one hand, it is subject to the functional restrictions of the existing performance controller, and on the other hand, there are some old devices without these new performance controllers.If there is no condition, you must create conditions and write a user -state performance controller of the Android platform.

User's state performance control usually has a high delay (because the time to modify the SYSFS node is relatively much), but it is very close to the actual application scenario to actively improve performance reduction before some known heavy loads start.The general working mode is to send Hint at the system framework Java layer, which is awarded the corresponding SYSFS modification by the Native layer service to receive HINT, such as Qualcomm CAF BOOST FRAMEWORK, Power-Libperfmgr.

Unlike other user -based performance controllers, UPERF does not have the JAVA layer, only the Native layer receiving time notification and active sampling, which has no dependence of the system framework level.Therefore, she does not need to re -compile the kernel, nor does it need to modify the Android framework source code, and she does not have almost the restrictions of the hardware platform.The scope of her modification covers all kernel performance control can be done, that is, you can use the input lift (yes, a small part of the old core without this), Dynamic Stune Boost, DEVFREQ BOOST these fancy Boost.

The following table is the functional comparison of several main performance optimization schemes:
| Function | Project Wipe | Perfd-Opt (CAF) | libperfmgr | UPERF |
|: --------------------------: |: --------------------------------------------------------------------------------------------------: |: ---------: |: ---: | | |
| Hmp+interestive | ✔️ | | | ✔️ |
| EAS+SCHEDUTIL | | ✔️ | ✔️ | ✔️ |
| Non -Qualcomm Platform | |️ | | | ✔️ |
| Android <8.0 | ✔️ | | | ✔️ |
| HMP model automatically adjusts the ginseng | ✔️ | | | ✔️ |
| CPU affinity of UI thread | | | ✔️ |
| Click to rise frequency | | | |️ | ✔️ |
| List of rolling frequency | | ✔️ | ✔️ | ✔️ |
| App startup acceleration | | ✔️ | ✔️ | ✔️ |
| Apk installation acceleration | | ✔️ | | |
| Standby optimization | | | ✔️ |
| Frame rendering is lagging | | | | ✔️ |
| Rendering starts, end | | | ✔️ |
| Surfaceflinger Complex synthesis | | | ✔️ | |
| Video recording scene | | | ✔️ | |
| Multi -performance mode | ✔️ | ✔️ | | ✔️ |

### Scene identification

Note: V3 version has been modified, this part is not applicable
UPERF supports the following scenario recognition:

-` none`, no conventional state of Hint -` Touch`, touch the hint of screen switching -` presset`, long press switch hint on time -` tap`, hint just touched the screen switching -` SWipe`, hint that switches after sliding at the screen -`Heavyload`, switch after detecting heavy loads after TAP or SWIPE, and falling to TAP after the load is reduced -`Sflag`, rendering given to SurfaceFlinger submitted hint -` sfboost`, the rendering of the SurfaceFlinger to submit the HINT that needs to be accelerated to switch -` Standby`, hint when the screen goes off, generally lags 20 seconds (hidden Hint) -` ssanim`, system animation playback switching Hint -` wakeup`, bright screen unlock and switch Hint

#### touch signal recognition

This program uses the same way as the Android system framework to obtain a touch signal. It monitors a device located in/dev/input. Analyze the newsletter information from the touch screen, and you can get the most basic fingers to touch the screen and the finger to leave the screen.According to a continuous newsletter information, you can get the distance of the finger sliding and the end speed of the end when you leave the screen. It can be inferred that the duration of the rolling operation of the APP rolling is calculated based on the end speed.

#### heavy load tracking and restrictions

Because the HOOK is not inserted in the Android framework layer, the APP is not known to be launched, so after the Hint starts, this program will update the use rate and operating frequency of all CPU cores by active rotation to obtain the overall load of the system.`The overall load of the system = SUM (Efficience (I) * (load_pct (i) / 100) * (freq_mhz (i) / 1000)), where the` i`is the CPU core ID.If the overall load is higher than`Heavyload`, then switch the current Hint to Hint.The response performance of the heavy load Hint is very good but the power consumption is too much. This program will continue to monitor the system load. If the overall load is lower than the threshold, the heavy load HINT consumption is ended in advance.For Apps that are not so high in loads, it will not even trigger weight loads. Unlike the Qualcomm Boost framework, regardless of how much the load is forcibly filled with the CPU for 2S.In addition, such testing not only covers the APP hot and cold start, but also covers a short -term heavy load scene such as clicking into the WeChat circle of friends.The energy consumption expenses of this function are also very low 0.6ms/100ms (Cortex-A55@1.0g).The picture below is the WeChat Hot Starting Hint status switching and duration.

! [WeChat Hot Start] (Media/WeChat_resume.png)

Some game loads are indeed very high, and the system load can continue to exceed the threshold very stable.Theoretically, the heavy load game should run at the frequency of the power consumption turning point, maintaining sufficient performance output to not heat up too much, which is contradictory with the original intention of the setting of the sudden heavy load.Therefore, the request interval between requests entering the heavy load HINT. After the last HEAVYLOAD, the load is lower than the `iDleLoad` for 1 second, and there is no Heavyload request during this time during this period of time.Filter the problem of continuous heavy load energy such as the game.

#### The APP that is operating is switching

Based on the main events that can respond to the above, the non -operating parameters can be set more conservative than before without worrying about stuttering, but litting wake -up is an exception.When the fingerprint under the screen is displayed on the breath screen, press the fingerprint sensor to complete the unlocking. Even if you touch the screen, there is no input event.The animation process of litting the screen is often accompanied by a large number of processes wake up, and conservative parameters can cause significant stuttering.This program monitor the ActivityManager activity of the Android framework, and the ActivityManager will be very active when the interactive APP changes, unlocks the screen, and locks the screen. It can be inferred whether to understand the lock screen incident.Through this monitoring, when the APP switch or starts, put the APP earlier to the large core, and the load migration delay can be reduced by about 100ms.This function is driven by events and has almost no additional energy consumption overhead.The picture below shows the optical screen fingerprint unlocking process.

! [Optical screen fingerprint unlocking process] (Media/Android_am.png)

#### identification screen goes off

In the previous Project Wipe and Perfd-opt, many users automatically switched to the saving point mode after the screenouts were turned off with the Scene toolbox to reduce the power consumption.UPERF on the Native layer cannot receive a system to turn off the screen as a SCENE toolbox, but to identify whether the screen is extinguished.

### sfanalysis

SFANALYSIS is a module independent of UPERF. It is injected into the SurfaceFlinger for modification. From this process responsible for all Android frame rendering process issued signals, notify UPERF to adjust the performance output.It cannot be reached by all kernel -stimulating frequency.However, if there are many restrictions on her implementation, OEM can change the source code, and the kernel can be changed to the kernel source code. UPERF cannot modify the source code for universality.If the injection method is used, the SurfaceFlinger is the Native process. It is written in C ++. Compared to the hook sites written by Java such as System_Server, there are less realization of different Android versions.Even if the injection is successful, because Android sets many Selinux rules on the system process, to prevent too much permissions after being injected into attack, notifying the signal is difficult to issue.After bypassed these restrictions, SFANALYSIS has the following functions:

-The key calls of HOOK, speculate and transmit rendering to the outside, the rendering submission lag, and the end of the rendering
-The adaptive dynamic refresh rate, adaptive vsync signal lags behind
-At the signal to the outside within the scope of the authority of Selinux, so you do not need to turn off Selinux to use it to use

! [Detecting rendering delay immediately pulls the CPU frequency] (./ Media/sflag.png)

The rendering submitting hint`sflag` is the same as heavy loads. There are call frequency restrictions to avoid long -term high frequency, and related parameters have not been opened for the time being.`Sflag` uses the number of available buffer pools to control the call frequency. The number of times per 400ms interval can be +1, up to 20 times.In order to avoid unnecessary frequency pulling, it is only allowed to transfer from `tap`,` swipe`, `touch`,` presset` to `sflag`.SFANALYSIS is manifested in the following ways after normal work:

`` `
[13:03:36] [i] SFANALYSIS: SurfaceFlinger Analysis Connect `` `

#### Rendere

Even if there is a touch end speed calculation, because the sliding damping of each device is different, the actual rendering duration is very different. Applying a fixed value can easily cause power waste.BOOST can end BOOST in advance by adding HOOK to the end of the rendering at DRM/Atomic. This program also uses a similar method. After the rendering end, the HINT response is ended within 200-300ms, reducing the power while covering the entire UI rendering process while the entire UI rendering process is reduced.waste.After the start of HINT, this program monitor Android's SurfaceFlinger activity. Almost all versions of Android rendering submission has passed by it. At the same timeTo.

After using the sfanalysis rendering to end the signal, the delay of HINT can be further reduced to 66ms in advance.
! [Rendering Stop] (Media/Render_Stop.png)

While shortening the lagging of the end of the rendering as much as possible, it will cause some UI response to the scene where there is a lagging of itself, because Hint has withdrawn early.Most of these situations occur in the process of browsing information flow. Click the picture to switch to full screen display pictures.Therefore, while ending Hint in advance, you also need to detect whether there is a lagging UI response. If you re -rendering within 700ms you click, it will restore the previous HINT.Monitor Android's SurfaceFlinger activity with active rotation, restore Hint's delay above 100ms, and use the SFANALYSIS rendering to start signal to be delayed further to 33ms.

! [Starting UI rendering starts] (Media/Render_restart.png)

### Writer

The basic function of the writer is to write the target string value to the `sysfs` node. In addition, UPERF also built a variety of writers to achieve other functions and more compact parameter sequences.When switching, UPERF will compare the difference between the values ​​of the previous movement and skip the duplicate value to reduce its own power consumption overhead.UPERF supports the following types: the following types:

-` string`, the most basic writer.The effect is equivalent to the `echo" value "> /path`. -` PerCluster`, the diversity group compact writer.Use the CPU serial number of the `Platform/Clustercpuid` in the configuration file to replace the`%d` in the `PATH`, each value is separated by the comma, making it more compact and readable by the cluster. -` Percpu`, divided into core compact types.According to the list length of the `Platform/EFFICICIENCY` in the configuration file, generate the CPU serial number to replace the`%d` in the `PATH`, and the values ​​are separated by the comma, making the value of the CPU core more compact and improved readability. -` CPUFREQ`, `PerCluster` Writer's variant of the accessor.Most of the functions are the same, the difference is that the writing value = set value \*100000, which shortens the length of the frequency parameter sequence, and with the writing failure to process the new minimum frequency higher than the original highest frequency. -` cgroup_procs`, cgroup special writer.Support maximum 4 values. Each value is separated by a comma. The set value is the process name. UPERF will scan all processes of the system during initialization, and replace them with the first PID that matches the first PID.Generally used to set the key process of the system to the specified CGROUP.Because the thread of a process may change dynamically, such a writer will be closed and heavy. -`UXAffinity`, UXAffinity writer.Every time the APP is switching, UPERF scans all threads of CGROUP belonging to the top app to cache the ID of all UI related threads.When setting it is 1, fix the UI -related thread to the core.When it is set to 0, all the UI related threads can be used all available cores.Set on most EAS platforms `Schedtune.Boost> 0` and`Schedtune.prefer_idle = 1`to fix the task to the large core, but the specific level of the EAS on each platform is uneven.EAS platform.To solve this problem, UPERF actively sets the CPU core affinity of these key threads, suitable for all EAS platforms, even HMP platforms.

### Pre -adjustment

-UPERF module provides the configuration file of most popular hardware platforms for most popular hardware platforms to play the advantage of UPERF as much as possible
-HMP platform balancing and Katton's version of the `Internetive` parameter and HMP load migration threshold are provided by the improvedThe frequency point of the inflection point provides the most stable and continuous performance
-The frequency point selection of the EAS platform integrates the performance requirements of the SOC power consumption model and the common load, which is generated by a set of fixed strategies
-An Star, SDM845 and the EAS platform for transplanted, due to the lack of key kernel functions, the traditional method of tuning is used, that is, the general scene does not provide excessive performance capacity
-Fengtong EAS platform after SDM845 uses post-adjustment performance requirements-performance capacity models, see the figure below, see the figure below

! [Performance requirements after adjustment-performance capacity model] (Media/Adjusted_Demand_CapAcity_Relation.png)

Assume that the system load is contributed by a single task.The default method of EAS is always reserved 25%of the performance margin because the `Schedutil` always reserves a different energy ratio of the energy consumption ratio of different frequency points. The closer to the maximum frequency energy consumption ratio, the lower the EAS default strategy will cause a higher loadThe maximum frequency is large.Judging from the law of reality load changes, 25%of the performance margin is not always enough. When the load is lower, it is easy to produce large fluctuations. When the load is high, the performance requirements are relatively stable.From the perspective of the law of the power consumption model and reality load change, due to the relatively large percentage of the volatility value, the relatively large performance margin should be left.The negative surface has little effect; when the load is high, the relatively small performance margin should be left due to the relatively small percentage of the fluctuation value. The difference between the energy consumption ratio between each frequency point of the SOC high frequency band is obvious, and the power consumption is positive on the front.The impact is greater.

### peripheral improvement

In addition to the UPERF body and SFANALYSIS injection, this module also cooperates with some peripheral improvements to improve the user experience.

-Uperf Before the start of the other parameters, the uniformization of other parameters, including:
-SCHEDTUNE set zero
-Use CFQ speed regulator to reduce the IO delay of the front desk mission during multi -tasking
-Recent the IO bandwidth occupation right of non -front desk APP
-Set the system process that is closely related to UI performance to the CGROUP group of the top -level app
-The threads fixed on transition animation to large cores
-Remon the wake of most sensor threads in the large nucleus
-Dable most kernel state and user mode boost, hot insertion -` Interactive` and `Schedutil` speed regulator,` core_ctl`, mission scheduler peripheral parameters are consistent
-Su the maximum performance for fingerprint recognition (EAS platform)

! [Provide maximum performance for fingerprint recognition] (./ Media/fingerprint.png)

## custom configuration file

This project has provided most of the popular hardware platforms with the UPERF configuration file, but there are always some situations that pre -adjustment configurations are not suitable for your software and hardware platforms, such as unpopular hardware platforms and custom kernels.In addition, there are also the needs of customized pre -configuration files, such as the minimum CPU frequency when adjusting the interaction, and increasing the GPU frequency range adjustment.At the beginning of UPERF design, this type of demand was considered, almost all adjustable parameters, and automatically reloaded after the configuration file was changed to improve the efficiency of debug parameters on the mobile phone side.The configuration file used in the MAGISK module is located in the `/sdcard/yc/uperf/cfg_uperf.json`.

### Yuan Information

`` `json
"Meta": {
"name": "SDM855/SDM855+ V20200516",
"Author": "YC@Coolapk",
"Features": "Touch CPULOAD RENDER Standby Sfanalysis"
} `` `

| Field Name | Data Type | Description                                                                                       |
| ---------- | --------- | ------------------------------------------------------------------------------------------------- |
| name       | string    | The name of the configuration file                                                                |
| Author     | String    | Author information of the configuration file                                                      |
| Features   | String    | The function list supported by the configuration file, currently the reserved field does not work |

`name` and` author` are reflected in the following ways:

`` `
[13:03:33] [i] CFGMGR: USING [SDM855/SDM855+ V20200516] by [yc@coollapk] `` `

### global parameter

`` `json
"Common": {
"Switchinode": "/SDCARD/YC/UPERF/CUR_POWERMODE",
"Verboselog": False,
"UXAffinity": True,
"Statetransthd": {
"heavyload": 1500,
"IdleLoad": 1000,
"Requestburstslack": 3000
},
"Dispatch": [[
{{
"Hint": "None",
"action": "normal",,
"maxduration": 0
},
{{
"hint": "tap",
"Action": "Internet",
"maxduration": 1500
},
Elastic
]
} `` `

| Field Name | Data Type | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | |
| Switchinode | String | Inode node of receiving performance mode switching |
| VERBOSELOG | BOOL | Open a detailed log to debug Hint switch |
| UXAffinity | Bool | Open the UX thread automatic settings, fix the high -priority UX thread to the large nucleus, and restrict the needs of low priority threads
| Heavyload | int | Enter the system load threshold of heavy load, please refer to [heavy load tracking and limit] (#heavy load tracking and limit) |
| IdleLoad | int | Exit the system load threshold of heavy load, please refer to [heavy load tracking and limit] (#heavy load tracking and limit) |
| Requestburstslack | int | In milliseconds, respond to the delay before the new heavy load request, please refer to [heavy load tracking and limit] (#heavy load tracking and limit) | |
| hint | String | corresponding to HINT type supported by UPERF |
| Action | String | Binded action name, you can customize |
| MaxDuration | int | Unit milliseconds, the maximum time of action should be maintained |

When UPERF starts, read the file with the corresponding path of the corresponding path to obtain the default performance mode of the corresponding path. The log is reflected in the following ways:

`` `
[13:03:33] [i] CFGMGR: Read Default PowerMode from/SDCard/YC/UPERF/Cur_powermode
[13:03:33] [i] CFGMGR: PowerMode "(NULL)" -> "Balance" `` `

`Switchinode` The file corresponding to the path, monitor the completion mode of writing the name of the new mode name:

`` `shell
Echo "PowerSave">/SDCARD/YC/UPERF/CUR_POWERMODE `` `

The log is reflected in the following ways:

`` `
[13:06:45] [i] CFGMGR: PowerMode "Balance" -> "PowerSave" `` `

The binding relationship of `dispatch` is embodied in the following ways:

`` `
[13:03:33] [i] CFGMGR: Bind Hintnone-> Normal
[13:03:33] [i] cfgmgr: bind hinttap-> Internet
[13:03:33] [i] CFGMGR: Bind Hintswipe-> Interaction
[13:03:33] [i] CFGMGR: Bind Hintheavyload-> Heavyload
[13:03:33] [i] cfgmgr: bind hintandroidam-> amswitch
[13:03:33] [i] CFGMGR: Bind Hintstandby-> Standby
[13:03:33] [i] cfgmgr: bind hintsflag-> sflag `` `

The two functions of `uxaffinity` and` sfanalysis` are reflected in the log in the log:

`` `
[13:03:33] [i] CFGMGR: UX Affinity Enabled
Elastic
[13:03:36] [i] SFANALYSIS: SurfaceFlinger Analysis Connect `` `

### platform information

`` `json
"Platform": {
"clustercpuid": [[
0,
4,
7
],,,
"Efficience": [[
120,
120,
120,
120,
220,
220,
220,
240
],,,
"knobs": [
{{
"name": "cpufreqmax",
"PATH": "/Sys/Devices/System/CPU/CPU%D/CPUFREQ/Scaling_max_freq",,
"Type": "CPUFREQ",
"enable": true
},
Elastic
]
} `` `

| Field Name | Data Type | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| |
| clustercpuid | int list | Multi -cluster CPU's first CPU ID of each cluster |
| EFFICIENCY | int List | The relative frequency performance of each CPU core, with Cortex-A53@1.0g as 100, the order corresponds to CPU ID |
| knobs | Object list | `sysfs` node list |

Each object in `knobs` is` knob`, with the following attributes:
| Field Name | Data Type | Description |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------- | |
| name | String | `sysfs` node name |
| PATH | String | `sysfs` node path |
| Type | String | `sysfs` node type, see [Writer] (#| |) |
| ENABLE | BOOL | Whether it is enabled, easy to disable one -click during debugging |

When the `enable` field is false, the log is reflected in the following ways:

`` `
[13:03:33] [i] CFGMGR: IGNORD ROOT/PLATFORM/KNOBS/TOPCSPROCS [Disabled by Config File]] `` `

When the `sysfs` node corresponding to the` Path` field does not exist or cannot be written, the log is reflected in the following ways:

`` `
[13:03:33] [i] CFGMGR: IGNORED ROOT/PLATFORM/KNOBS/BIGHIFREQ [PATH is Not Writable] `` `

### Performance mode parameters

`` `json
"PowerModes": [[
{{
"name": "Balance",
"Actions": {
"Internet": {
"CPUFREQMAX": "18,18,22",
"cpufreqmin": "10,10,8",
"CPULOADBOOST": "0,0,0,0,0,0,0,0",, "
"FGCPUS": "0-3",
"TOPCSPROCS": "Com.android.SystemUi, System_Server", "
"FGSTPROCS": "System_Server",
"DDRBWMAX": "6000",
"DDRBWMIN": "2500",
"UXAffinity": "1"
},
Elastic
},
Elastic
},
Elastic
] `` `

| Field Name | Data Type | Description |
| ---------- | ---------------------------------------------------- | |
| name | String | Can be customized for multiple versions of backup tuning ginseng |
| Action name | String | The action name defined in the `Common/Dispatch`
| `knob` name | String | and` platform/knobs` `sysfs` node name |
| `knob` value | String | Value format for details. For details, please refer to [Writer] (#| |) |

One action should set the value of all `knob` defined in all` platform/knobs`.At some point, you need to deliberately skip the settings of certain values, or to repeat the setting value of most of the previous actions. You can omit some `KNOB` setting value, but not all.UPERF will indicate which values ​​will be skipped when loading the configuration file. The log is reflected in the following ways:

`` `
[13:03:33] [i] CFGMGR: IGNORED KNOBS in Action root/PowerModes/Balance/ACTIONS/AMSWITCH:
[13:03:33] [i] CFGMGR: CPUFREQMIN LLCCBWMAX LLCCBWMIN DDRBWMIN DDRBWMIN L3Latbig DDRLATBIG `` `

### Example

Use UPERF to add UFS energy saving to interact and re -load, thereby reducing the IO bottleneck of key scenes.

The node path of the UFS energy -saving switch is `/sys/devices/platform/SoC/1D84000.UFSHC/clkgate_enable`, write the string type, write" 0 "to close UFS energy saving, write" 1 "as" 1 "as a" 1 "as a" 1 "as a" 1 "as aOpen UFS energy saving and name this node to `ufsclkgateenable`.Add the following text to the configuration file to complete the definition of `knob`

`` `json
"Platform": {
Elastic
"knobs": [
Elastic
{{
"name": "UFSCLKGateenable",
"PATH": "/Sys/devices/platform/soc/1d84000.Ufshc/Clkgate_enable",
"Type": "String",
"enable": true,
"Note": "UFS clock door switch"
},
Elastic
]
} `` `

According to the definition of [Scenario Identification] (#景 根据), the hint name of the interactive hint is `tap` and` swipe`, and the hint name of the heavy load is `Heavyload`.

`` `json
"Dispatch": [[
Elastic
{{
"hint": "tap",
"Action": "Internet",
"maxduration": 1500
},
{{
"Hint": "Swipe",
"Action": "Internet",
"maxduration": 3000
},
{{
"Hint": "Heavyload",
"Action": "Heavyload",
"maxduration": 2000
},
Elastic
} `` `

According to the binding relationship between the HINT defined in the configuration file, you need to set the UFS energy saving to set off UFS energy saving, and other movements need to be opened.Add the following text to the following text to complete the action definition:

`` `json
"PowerModes": [[
{{
"name": "Balance",
"Actions": {
"normal": {
Elastic
"UFSCLKGateenable": "1", "1",
Elastic
},
"Internet": {
Elastic
"UFSCLKGateenable": "0", "0",
Elastic
},
"heavyload": {
Elastic
"UFSCLKGateenable": "0", "0",
Elastic
},
"amswitch": {
Elastic
},
"Standby": {
Elastic
"UFSCLKGateenable": "1", "1",
Elastic
},
"sflag": {
Elastic
},
},
},
{{
"name": "Powersave",
"Actions": {
"normal": {
Elastic
"UFSCLKGateenable": "1", "1",
Elastic
},
Elastic
},
},
Elastic
] `` `

After changing the configuration file, UPERF will automatically create a new sub -process to load new configuration files. If there is a problem with the new configuration file format, the new sub -process will be terminated to retain the old child process.Next verify whether the setting of the setting in the configuration file can be executed as scheduled and whether the value of the corresponding path is changed.

## thanks

- https://github.com/yc9559/uperf.git
