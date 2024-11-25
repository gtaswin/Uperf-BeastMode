# UPERF V3 Configuration File Description

UPERF V3 uses plug -in software structure design, and each functional module can have an independent configuration parameter space.

## meta/yuan information

| Field | Type | Description |
| ------ | --------------------------- | |
| name | string | The name of the configuration file |
| Author | String | Author information of the configuration file |

## modules/module definition

The static parameter segment of the functional module is read only once in the module, and it is used for switching functions, defining model parameters, etc.

### Switcher/Dynamic configuration switch

According to the associated Native layer signal, jump the corresponding Hint state switch, apply the corresponding dynamic parameters, and continue to specify the time.Users can define multiple performance configurations, and each performance configuration has dynamic parameters of each HINT.The default value of dynamic parameters is defined in `/initials`, and the dynamic value of dynamic parameters is defined in`/presets`.If you write `/presets` and define the two performance configurations of` Powersave` and `Balance`, then the` switchinode` file allows writing to write `auto`,` Powersave` and `Balance`Divide the app performance configuration switch `.

Note: Because it is the basic module, this module is not available for turning off.

The rules of the built -in APP performance configuration switch are as follows, and the package name matches the full word sensitive in the case.The head of the line is `*` to indicate the default rules, and the head of the line is `-` indicate the screen of the screen, ** must include the default and screening rules **.

`` `
#
# PER-APP Dynamic Power Mode Rule
# 'Means Offscreen Rule
# '*' Means default Rule

com.mihoyo.yuanshen Fast
-BARANCE
* BALANCE
`` `

| Field | Type | Description |
| -------------------------------------------------------------------------------------------------------------------------------------------------|
| Switchinode | String | Document Node of Monitoring Manual Switch Performance Mode |
| PERAPP | String | Built -in APP performance configuration file path |
| hintduration | Object | The longest duration of each hint |

#### hintduration/hint maximum duration

Each HINT uses the status machine to complete the jump, the status transfer diagram is as follows:

`` `Mermaid
stateDiagram-V2

[*] -> IDLE
IDL
IDLE-> SWITCH: WOKE Up Screen
Touch -> Trigger: Released Touch / Started Scrolling
Touch-> GESTUR
Touch -> Switch: Detected Window Animation
Touch-> junk: Detect junk
GESTUR
GESTURE-> JUNK: Detect Junk
junk -> Touch: Timeout / Finished Junk
Trigger-> Touch: Timeout / Not Rendering
GESTURE-> Touch: Timeout / Not Rendering
Switch-> Touch: Timeout / Not Rendering
Touch -> IDLE: Timeout / Not Rendering
`` `

| Field | Type | Description |
| ------- | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| IDLE | Float | (Unit: second) default |
| Touch | Float | (Unit: second) touch screen/press button |
| Trigger | Float | (Unit: Second) Click on the operation to leave the screen/loosen the button/sliding operation start |
| GESTURE | Float | (Unit: second) full screen gesture |
| Switch | Float | (Unit: second) Application of switching animation/lighting screen |
| JUNK | Float | (Unit: second) Sfanalysis in Touch/GESTURE detected the frame drop |

### atrace/data

For the UPERF program debugging.

| Field | Type | Description |
| ------ | ---- | ------------- |
| ENABLE | BOOL | Enable the data to hit the point |

### log/log level

Used for debugging file configuration files.

| Field | Type | Description |
| ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Level | String | Log level, you can use `ERR`,` Warn`, `Info`,` Debug`, `Trace` |

### Input/User Enter Supervision

Surveillance user touch screen touch operation, keys operation, mouse operation.Support the input device hot insertion.

| Field | Type | Description |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | |
| ENABLE | BOOL | Enable User Entering Supervision |
| SWIPETHD | Float | The percentage length of the single touch trajectory exceeds the threshold, determined as a sliding operation |
| GESTURETHDX | Float | Full screen gesture starts with X -axis percentage position |
| GESTURETHDY | Float | Full screen gesture starts with Y -axis percentage position |
| GESTUREDELAYTIME | Float | Not used for the time being |
| HOLDENTERTIME | Float | Not used for the time being |

### SFANALYSIS/SurfaceFlinger signal analysis

Receive the signal analysis results of the SFANALYSIS module in the SurfaceFlinger.The frame dropped Hint, and the rendering ended Hint in advance.

| Field | Type | Description |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | |
| ENABLE | BOOL | Enable SurfaceFlinger signal analysis |
| RenderIdleslacktime | Float | (Unit: second) rendering is over for a period of time, judging as the end of rendering |

### cpu/user mode CPU frequency adjustment

The user -based CPU FM regulator based on the energy consumption model enables the HMP/EAS platform to experience a unified experience.Calculate the performance of each frequency point according to the power consumption model, select the best frequency limit.

| Field | Type | Description |
| ---------- | ---------------------------
| ENABLE | BOOL | Enable User's CPU FM |
| PowerModel | Object | CPU energy consumption model |

#### PowerModel/Energy Consumption Model

Only a set of measured data is required to complete the calibration.Experience model combines actual measurement data to maintain the model accuracy and significantly reduce platform adaptation workload.The type is the object list, which is consistent with the CPU cluster.

Note: ** Typical frequency points are not the maximum value of frequency regulation **, and the power consumption of the power consumption of typical frequency points is calculated.

| Field | Type | Description |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| EFFICIENCY | int | Single core relative to the same frequency performance (with Cortex-A53@1.0GHz as 100) |
| nr | int | Core number of cluster kernel |
| TypicalPower | Float | (Unit: tile) single -core typical power consumption |
| Typicalfreq | Float | (Unit: Gigabith) single -core typical frequency point |
| Sweetfreq | Float | (Unit: Gigabith) Single -core dessert border frequency point |
| PLAINFREQ | Float | (Unit: Gigabit) Single -core linear border frequency point |
| FreeFreq | Float | (Unit: Gigabit) Motition consumption point of the minimum power consumption |

### sysfs/kernel node writing

The core function of the user's state performance controller sets different kernel parameters for different scenarios.This module is highly optimized, and the target value overhead is extremely low.

| Field | Type | Description |
| ------ | --------------------------- | |
| ENABLE | BOOL | Enable the kernel node writer |
| KNOB | Object | Copycore node definition |

#### knob/kernel node definition

The key value is defined:

-Key: kernel node name
-D value: kernel node file path

example:

`` `json
"CPUSETTA": "/DV/CPUSET/TOP-APP/CPUS"
`` `

### SCHED/Recognize the Context Mission Swalter

Under the same energy consumption, improve the fluency of Qos to improve user perception.The regular matching process name and thread name are bound to the specified CPU core, and set the specified scheduling priority.This module is highly optimized, and process scanning and dynamic rules are extremely low.

The definition of the mission scheduler of the identification context is as follows:
-` bg`: the process is in the background
-` FG`: The process is at the front desk
-` IDLE`: The process is at the top of the top, the default scene
-` Touch`: The process is visible at the top layer, interactive scenarios
-` Boost`: The process is visible at the top layer, heavy negative scenes

| Field | Type | Description |
| -------- | -----------------------------------------------------------------------
| ENABLE | BOOL | Establish the task scheduling of the context of the context |
| CPUMASK | Object | CPU group definition |
| Affinity | Object | CPU affinity category definition |
| Prio | Object | Definition of scheduling priority category |
| Rules | Object | Process Rules |

#### CPUMASK/CPU group definition

The key value is defined:

-Key: CPU group name
-D value: The CPU core ID list contained in this CPU group

example:

`` `json
"Perf": [4, 5, 6, 7]
`` `

#### Affinity/CPU affinity category definition

The key value is defined:

-Key: CPU affinity category name
-D value: `CPUMASK`, which is bound to each scene

example:

`` `json
"coop": {{
"BG": "Eff",
"fg": "Eff",
"IDLE": "Norm",
"Touch": "Norm",
"boost": "norm"
}
`` `

#### Prio/Swalting Priority Category Definition

The key value is defined:

-Key: scheduling priority category name
-D value: The scheduling of each scene application is prioritized, and the definition of the value is as follows

| Numeric | Description |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | |
| 0 | Skip SCHED category settings |
| 1 ~ 98 | Set the thread tone category as `sched_fifo`, the value is real -time static priority |
| 100 ~ 139 | Set the thread tone category as `sched_normal`, the value is real -time static priority |
| -1 | Set the thread tone category to `sched_normal` |
| -2 | Set the thread tone category to `sched_batch` |
| -3 | Set the thread tone category to `sched_idle` |

example:

`` `json
"High": {{
"bg": -3,
"fg": 110,
"IDLE": 104,
"Touch": 102,
"Boost": 100
}
`` `

### Rules/Process Rules

The type is the object list, which is consistent with the matching of the matching priority.

Note: The regular matching rules `/home_package/` will automatically replace the package name of the current system launch internally.

| Field | Type | Description |
| ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | |
| name | String | Process Rules |
| RegEx | String | The process name is in a regular match. Be careful not to conflict with JSON grammar |
| Pinned | Bool | Always as a visible process `application rules on the top layer |
| Rules | Object | Thread rules of this process |

#### Rules/thread rules

The type is the object list, which is consistent with the matching of the matching priority.

Note: The regular matching rules `/main_thread/` will automatically replace it into the main thread name internally.

| Field | Type | Description |
| ---- | ------ | ------------------------------------------------------------------------------
| K | String | Thread name regular matching rules, be careful not to conflict with JSON grammar (abbr: keyword) |
| AC | String | The CPU affinity category of thread needs to be defined in the `Affinity` pre -defined (ABBR: Affinity Class) |
| PC | String | Thread's scheduling priority category, needs to be defined in the pre -definition of `prio: priority class) |

## Initials/initial value

The dynamic parameter segment of the function module can be dynamically switched after the module initialization is completed to adjust the threshold and module behavior tendency.The value defined in this paragraph is the default value of the module parameter.

### cpu/user mode CPU frequency adjustment

The working process of the user -based CPU frequency adjustment of the energy consumption model is as follows, and the multiple adjustable parameters are provided:

1. The load of each core of each core of CPU from the kernel period
-It when there is a certain load in the CPU as a whole, the CPU frequency is sampled by the `BaseSampletime` to improve the response speed
-Acpu When entering the empty load as a whole, the CPU frequency is sampled by the `Baseslacktime` period to reduce the expenses of rotation
2. Calculate the performance load and performance requirements of each cluster
-If the maximum load increase of the CPU cluster is greater than `Predictthd`, the performance requirements calculate the predicted load value
-Ac calculating performance requirements according to the performance load, `demand = load + (1 -load) * (margin + burst)` `
-Ding different from `margin`,` BURST` is not zero, even if the current load is low, it can be calculated to larger performance requirements
3. Calculate the operating frequency point corresponding to performance requirements
-It if there are multiple clusters, the CPU will share the entire `Latenecytime`, indicating that the minimum frequency of the highest frequency of the cluster with the lowest performance to the highest frequency of the cluster
-For the existence of the discrete sampling cycle, the minimum delay of the overall increase of the CPU as a whole will generally be greater than the set `LanetCytime`
-The more frequency point of the energy consumption, the greater the delay to its ascending frequency, and the frequency point lower than the `Sweetfreq` without an additional lift delay
4. Limit the overall power consumption of CPU
-Simed at the PL1 and PL2 power consumption restrictions of Intel processors, taking into account the performance requirements and long -term energy efficiency needs of short -term explosives
-Based on the energy consumption model and each core load, it is estimated that the overall energy consumption value of the current cycle CPU
-If the current energy consumption is greater than `SlowlimitPower`, the balance of energy consumption buffer pool is reduced
-If the current energy consumption is smaller than the `slowlimitpower`, the balance of energy consumption buffer pool increases, and restores according to the` FastlimitRecoverscale` zoom factor.
-The restrictions of CPU power consumption according to the energy consumption model, select the optimal frequency limit, and provide the best overall performance under limited power consumption
-`burst` ignores` Fastlimitpower` and `Slowlimitpower` restrictions
5. Guide the task scheduler to place tasks
-After enabling the `Guidecap`, adjust the performance capacity of the cluster according to the energy consumption model, guide the EAS task scheduler to place the task to the best cluster of energy efficiency
-An enable `limitefficience, the energy values ​​of the maximum frequency point of the low -performance cluster are not higher than the high -performance cluster's current frequency point
6. Write the target CPU frequency to the kernel
-A efficient CPU frequency writing device, user mode CPU frequency adjustment overall cycle is about 0.0005 seconds

| Field | Type | Description |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | |
| Basesampletime | Float | (Unit: second) (0.01 ~ 0.5) Basic sampling cycle |
| Baseslacktime | Float | (Unit: second) (0.01 ~ 0.5) A idle sampling cycle, CPU overall enters the air load and take effect |
| Latencetime | Float | (Unit: second) (second) (0.0 ~ 10.0) CPU overall ascending minimum delay |
| SlowlimitPower | Float | (Unit: Wat) (0.05 ~ 999.0) CPU long -term power consumption limit |
| FastlimitPower | Float | (unit: tile) (0.05 ~ 999.0) CPU short -term power consumption restriction, energy consumption buffer ponds will enter long -term power consumption limit |
| FastlimitCapAcity | Float | (unit: tile seconds) (0.0 ~ 999.0) CPU short -term power consumption restriction capacity, and the amount of resetting the resolution is limited to the capacity |
| FastlimitRcoverscale | Float | (0.1 ~ 10.0) CPU short -term power consumption restriction capacity recovery zoom factor |
| Predictthd | Float | (0.1 ~ 1.0) CPU cluster maximum load increase is greater than the threshold, then the load value of the cluster frequency adjustment is used, and ignore the `Latenecytime` | |
| Margin | Float | (0.0 ~ 1.0) Performance margin provided by FM |
| Burst | Float | (0.0 ~ 1.0) the extra performance margin provided by FM, ignores the `Latenecytime` and power consumption limit |
| Guidecap | Bool | Enable EAS task scheduling load transfer |
| LimiteFFICIENCY | Bool | Enable CPU overall energy efficiency limit |

### sysfs/kernel node writing

The key value is defined:

-Key: kernel node name
-Value: The value of the kernel node file is written, supporting `String` and` int`

example:

`` `json
"CPUSETTA": "0-7"
`` `

### SCHED/Recognize the Context Mission Swalter

| Field | Type | Description |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | |
| Scene | String | The process is at the top of the top layer. The legitimate value is `IDLE`,` Touch`, ``

## presets/parameter preset

The parameter preset section of the functional module defines different performance modes here, such as equilibrium mode and energy -saving mode.

Each group of parameters must contain `*`, `IDLE`,` Touch`, `Trigger`,` GESTURE`, `junk`,` switch`, as shown in the sample.Parameter preset the neutron configuration name definition is the same as [dynamic configuration switch] (#switcher/dynamic configuration switch), and apply the dynamic parameter of the corresponding mode after the state jump.The parameters in the `*` are the default value of the dynamic parameters preset in the group's parameters.

`` `json
"Balance": {
"*": {{
},
"IDLE": {{
},
"Touch": {{
},
"Trigger": {
},
"GESTURE": {
},
"junk": {{
},
"switch": {
}
}
`` `

In order to improve the readability of the parameter presets, the parameter value adopts the design method of the `layered style table`.The following example display parameter value `CPU.BASESAMPLETIME's coverage:

1. Definition in `/initial/cpu`` BaseSampletime` The global default value is `0.01`
2. Define in the definition of `Basesampletime` in the preset of the global default value in this parameter preset default value to the default value of the parameter.
3. Define in the `Basesampletime` in` Basesampletime` in the `IDLE` scene value in` `BALANCE/IDLE`

`` `
"initials": {
"CPU": {{
"basesampletime": 0.01,
}
},
"Presets": {
"Balance": {
"*": {{
"CPU.BASESAMPLETIME": 0.02
},
"IDLE": {{
"CPU.BASESAMPLETIME": 0.04
}
}
}
`` `