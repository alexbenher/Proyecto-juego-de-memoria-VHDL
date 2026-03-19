· Memory Game on FPGA (Basys3) – VHDL

· Description

This project consists of the design and implementation of a **memory game** on an FPGA using **VHDL**, deployed on the **Basys3 board**.

The system generates a sequence of signals that the user must memorize and reproduce using input buttons. The design is based on a **Finite State Machine (FSM)** architecture, handling user interaction, sequence generation, and game logic in real time.

---

· Objectives

* Design a complete digital system using **VHDL**
* Implement a **Finite State Machine (FSM)** for game control
* Interface with real hardware (buttons, LEDs, displays)
* Demonstrate modular and scalable hardware design

---

· Features

* 🎲 Random (or pseudo-random) sequence generation
* 🎮 User input via buttons
* 💡 Visual feedback using LEDs / 7-segment display
* ❌ Error detection and game reset

---

· System Architecture

The system is divided into several modules:

* **Top Module**: Integrates all components
* **FSM Controller**: Manages game states and transitions
* **Sequence Generator**: Creates the pattern to memorize
* **Input Controller**: Reads and debounces button inputs
* **Display Controller**: Drives LEDs / 7-segment display

· FSM Overview

Typical states:

* `IDLE` – Waiting to start
* `SHOW_SEQUENCE` – Display sequence to the user
* `USER_INPUT` – Wait for user input
* `CHECK` – Validate input
* `ERROR` – Wrong sequence entered
* `SUCCESS` – Correct sequence, increase difficulty

---

· Hardware Used

* FPGA Board: **Basys3 (Xilinx Artix-7)**
* Inputs: Push buttons / switches
* Outputs: LEDs and/or 7-segment display

---

· Project Structure

```
project_root/
├── src/
│   ├── top/
│   │   └── sintesis_simon.vhd
│   │
│   ├── control/
│   │   └── controlador_simon.vhd
│   │
│   ├── datapath/
│   │   ├── datapath_simon.vhd
│   │   ├── divisor.vhd
│   │   ├── contador.vhd
│   │   ├── contador3bits.vhd
│   │   ├── pierde.vhd
│   │   ├── gana.vhd
│   │   └── ganaRonda.vhd
│   │
│   ├── input/
│   │   ├── debouncer.vhd
│   │   ├── debounceInst_displayce1.vhd
│   │   ├── debounceInst_displayce2.vhd
│   │   ├── debounceInst_displayce3.vhd
│   │   ├── debounceInst_displayce4.vhd
│   │   └── debounceInst_displayce5.vhd
│   │
│   ├── display/
│   │   ├── displays.vhd
│   │   ├── conv_7seg.vhd
│   │   ├── conv_7seg_digito_0.vhd
│   │   ├── conv_7seg_digito_1.vhd
│   │   ├── conv_7seg_digito_2.vhd
│   │   └── conv_7seg_digito_3.vhd
│   │
│   └── simon/
│       └── simon.vhd
│
├── constraints/
│   └── basys3.xdc
│
└── README.md
```

---

· How to Run

1. Open the project in **Xilinx Vivado**
2. Add all `.vhd` files from `/src`
3. Add the constraints file (`.xdc`)
4. Run synthesis and implementation
5. Generate bitstream
6. Program the Basys3 board

---


· Key Concepts

* Finite State Machines (FSM)
* Digital system design
* Hardware description with VHDL
* FPGA implementation and constraints
* Real-time interaction with hardware

---

· Future Improvements

1. Dynamic Difficulty
Increase sequence length progressively
Reduce player response time
Speed up LED display
Result: a more challenging and scalable game experience

2. True Random Sequence Generation
Replace predefined sequences with advanced pseudo-random generation (e.g., LFSR)
Avoid repetitive patterns
Improve replayability and user experience

3. Scoring and Levels
Display current level and score
Save high scores
Automatically advance levels

4. Enhanced Interface (Audio + Visual Feedback)
Add button sounds (like the original Simon game)
Show different animations for correct/incorrect inputs
Use more LEDs or effects (fade, complex patterns)

---

· Author

* Name: Alejandro Benito
* Degree: Computer Engineering
* University: Universidad Complutense de Madrid
---



This project was developed as part of academic training in digital design and FPGA systems. It demonstrates the integration of hardware and logic design using VHDL in a real embedded environment.
