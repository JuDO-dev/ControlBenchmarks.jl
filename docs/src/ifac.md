# IFAC Control Benchmark Problems

The following benchmark problems were proposed by IFAC in their 1990 report "Benchmark Problems for Control System Design"[^1]
as possible problems that can be used to test and explore control design and analysis techniques.
All the problems are based on real world examples, and many contain uncertainty and input/output/state constraints.

[^1]: [E. J. Davison, ‘Benchmark Problems for Control System Design: Report of the IFAC Theory Committee’, IFAC, 1990.](https://taskforce.ifac-control.org/industry-committee/reference-materials/benchmark-problems-for-control-system-design/view)


```@contents
Pages = ["ifac.md"]
Depth = 3
```


## Process Control

### Binary Distillation Column

This problem is based on a binary distillation column, where an input feed consisting of a compound with 2 components
is introduced into a distillation column that then separates the two components by adding and removing heat.
One component progresses through several internal plates until it reaches the bottom of the column, while the other component
goes through other plates as it goes towards the top of the column.

This particular column consists of 8 internal plates, with the composition of the volatile component at each plate given in model states ``x_2`` through ``x_9``.
The process control inputs are the reheater ``u_1``, the condenser ``u_2``, and the reflux of the top product ``u_3``.
The input compound is treated as a disturbance, and enters through ``\omega_1`` at plate 5.
The main process outputs are the bottom product ``y_1``, the top product ``y_2``, and the pressure in the distillation column ``y_3``.

![Binary Distillation Column](assets/ifac-9001-BinaryDistillationColumn.png)


#### Problem

The objective is to design a controller that regulates the three outputs ``y_1``, ``y_2``, and ``y_3`` against the disturbance ``\omega_1`` with as fast a settling time as possible while respecting the constraints.
The choice of the signals to use in calculating the controller (the measurable outputs) is up to the designer, but a controller that uses the fewest number of signals for measurements is desired.


#### Formulation

This problem uses a continuous-time 11-state, 3-input, 3-output linear system with a single unmeasureable disturbance input.

```math
\begin{aligned}
\dot{x} &= Ax + Bu + E\omega\\
y &= Cx\\
y_{m} &= x
\end{aligned}
```

The system inputs and disturbance are constrained so that:

```math
\begin{aligned}
|u_1| &\leq 2.5\\
|u_2| &\leq 2.5\\
|u_3| &\leq 0.30\\
|\omega_1| &\leq 1
\end{aligned}
```

| Variable     |       State                                              |
|:------------:|:---------------------------------------------------------|
| ``x_1``      | Composition of more volatile component in condenser      |
| ``x_2``      | Composition of more volatile component in plate 1        |
| ``x_3``      | Composition of more volatile component in plate 2        |
| ``x_4``      | Composition of more volatile component in plate 3        |
| ``x_5``      | Composition of more volatile component in plate 4        |
| ``x_6``      | Composition of more volatile component in plate 5        |
| ``x_7``      | Composition of more volatile component in plate 6        |
| ``x_8``      | Composition of more volatile component in plate 7        |
| ``x_9``      | Composition of more volatile component in plate 8        |
| ``x_{10}``   | Composition of more volatile component in reboiler       |
| ``x_{11}``   | Pressure                                                 |
|              |                                                          |
| ``y_1``      | Composition of more volatile component in bottom product |
| ``y_2``      | Composition of more volatile component in top product    |
| ``y_3``      | Pressure                                                 |
|              |                                                          |
| ``u_1``      | Reboiler steam temperature                               |
| ``u_2``      | Condenser coolant temperature                            |
| ``u_3``      | Controlled reflux of top product                         |
|              |                                                          |
| ``\omega_1`` | Change of input feed concentration                       |

#### Code

```@docs
BinaryDistillationColumn
controlbenchmark( ::BinaryDistillationColumn )
```


### Drum Boiler

This problem is based on a drum boiler system, where input water is turned to steam inside a boiler.

This particular boiler has control over two of the standard inputs: the input flow rate of the water and the amount of fuel burned in the boiler.
It also provides control over the temperature of the input water flow, however this control input is not used in conventional boiler control strategies.


#### Problem

The objective is to design a controller to regulate the output of the system (the pressure ``y_1`` and water level ``y_2``) against the constant output steam flow disturbance ``\omega_1``.
The setpoint tracking should have as fast a settling time as possible.

![Drum Boiler](assets/ifac-9002-DrumBoiler.png)

#### Formulation

This problem uses a continuous-time 9-state, 3-input, 2-output linear system with a single unmeasureable disturbance input.

```math
\begin{aligned}
\dot{x} &= Ax + Bu + E\omega\\
y &= Cx\\
\end{aligned}
```

| Variable     |       State                      |
|:------------:|:---------------------------------|
| ``x_1``      | Density of output steam flow     |
| ``x_2``      | Temperature of output steam flow |
| ``x_3``      | Temperature of superheater       |
| ``x_4``      | Quality of steam                 |
| ``x_5``      | Water flow in riser              |
| ``x_6``      | Pressure                         |
| ``x_7``      | Temperature of riser             |
| ``x_8``      | Temperature of water in boiler   |
| ``x_9``      | Water level in boiler            |
|              |                                  |
| ``y_1``      | Pressure                         |
| ``y_2``      | Water level in boiler            |
|              |                                  |
| ``u_1``      | Input fuel flow                  |
| ``u_2``      | Input water flow                 |
| ``u_3``      | Temperature of input water flow  |
|              |                                  |
| ``\omega_1`` | Output steam flow disturbance    |

#### Code

```@docs
DrumBoiler
controlbenchmark( ::DrumBoiler )
```


### Cold Rolling Mill


#### Problem


#### Formulation


#### Code


## Aero-Control

### Boeing 767 at Flutter Condition

### Problem

### Formulation

### Code

```@docs
B767FlutterCondition
controlbenchmark( ::B767FlutterCondition )
```


## Servo-Control


### Hydraulic Positioning System


#### Problem


#### Formulation


#### Code

```@docs
HydraulicPositioningSystem
parameterbounds(::HydraulicPositioningSystem)
controlbenchmark( p::HydraulicPositioningSystem; ignoreBounds::Bool = false )
```


## Mechanical Systems
