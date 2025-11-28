# UART Transmitter & Receiver System (Verilog + GDSII)

## Project Overview

This project showcases the design and implementation of a complete UART (Universal Asynchronous Receiver-Transmitter) system using Verilog HDL. It integrates essential modules such as baud rate generation, data transmission, and data reception. The design was thoroughly verified at RTL level and processed through the full ASIC flow using OpenLane, resulting in a finalized GDSII layout ready for fabrication.

The work demonstrates a structured RTL-to-GDSII development cycle using open-source VLSI tools.

---

## Core Features

* Full UART functionality including TX, RX, and Baud Rate Generator
* Supports standard 8-bit serial data format
* Modular and scalable architecture
* Fully synthesizable synchronous design
* Optimized for ASIC implementation
* GDSII layout verified with industry-standard open-source tools

---

## Technology Stack

| Category      | Tools / Languages       |
| ------------- | ----------------------- |
| HDL           | Verilog                 |
| Simulation    | Icarus Verilog, GTKWave |
| Synthesis     | Yosys                   |
| Place & Route | OpenLane                |
| Layout Tools  | Magic VLSI, KLayout     |
| Output Format | GDSII                   |
| Example Clock | 50 MHz (scalable)       |

---

## Module Description

| Module                | Function                                            |
| --------------------- | --------------------------------------------------- |
| uart_top.v            | Integrates TX, RX, and baud rate control logic      |
| baud_rate_generator.v | Produces timing pulses for UART bit synchronization |
| uart_tx.v             | Manages serial data transmission sequence           |
| uart_rx.v             | Captures incoming serial data and signals readiness |

---

## UART Frame Structure

| Bit Type  | Description                   |
| --------- | ----------------------------- |
| Start Bit | Always low (0)                |
| Data Bits | 8 bits, LSB transmitted first |
| Stop Bit  | Always high (1)               |

---

## Operational Flow

**Transmission:** Parallel 8-bit data is serialized upon enable signal and sent bit-by-bit following UART protocol timing.

**Reception:** Serial input is sampled and converted to byte format, with an output-ready signal indicating successful reception.

**Baud Generation:** System clock is divided to create precise enable pulses for synchronized TX and RX operations.

---

## Baud Rate Timing

* TX Enable pulse generated every 5208 clock cycles (~9600 baud @ 50 MHz)
* RX Enable pulse generated every 325 cycles for mid-bit sampling accuracy

Counters reset on system reset and operate synchronously with the main clock.

---

## FSM Architecture

### Transmitter States

| State | Description              |
| ----- | ------------------------ |
| IDLE  | Waiting for write enable |
| START | Sends start bit          |
| DATA  | Transmits 8-bit payload  |
| STOP  | Sends stop bit           |

### Receiver States

| State | Description              |
| ----- | ------------------------ |
| IDLE  | Detects start condition  |
| START | Confirms valid start bit |
| DATA  | Samples incoming data    |
| STOP  | Confirms stop bit        |
| DONE  | Sets ready flag          |

---

## Simulation Procedure

Commands to validate operation:

Compile:

```
iverilog -o uart_sim uart_top.v
```

Run:

```
vvp uart_sim
```

Waveform View:

```
gtkwave uart.vcd
```

Testbench can be adjusted to explore varied baud rates and data inputs.

---

## ASIC Design Flow

### RTL Synthesis

```
yosys -s synth.ys
```

### OpenLane Execution

```
./flow.tcl -design UART -tag final_run -overwrite
```

### Physical Verification

* Design Rule Check (DRC) using Magic
* Layout vs Schematic (LVS) verification
* Final GDSII visualization in KLayout

---

## Layout Output Stages

Include screenshots of:

* Floorplanning
* Placement
* Routing
* Final GDSII View

(Replace placeholders with actual layout images.)

---

## Learning Achievements

* In-depth understanding of UART communication standards
* Development of FSM-based TX and RX logic
* Implementation of baud rate timing control
* Completion of full ASIC design cycle
* Practical exposure to layout verification and timing optimization

---

## Future Expansion

* Add parity and error detection mechanisms
* Implement dynamic baud rate selection
* Integrate FIFO buffering for high-throughput communication
* Extend UART for SoC-based applications

---

## Author

**Deepankar Majee**
Electronics and Communication Engineering Student
Core Interests: Digital Design, VLSI Systems, ASIC Implementation, and Embedded Technologies
