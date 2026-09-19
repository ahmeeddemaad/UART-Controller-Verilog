# 📡 UART CONTROLLER

### 8-N-1 UART Peripheral — Verilog RTL

**Custom UART Controller with FIFO Buffering, Programmable Baud Rate & Memory-Mapped Register Interface**

> A synthesizable UART Controller implemented in Verilog RTL, integrating independent 16×8 TX/RX FIFOs, programmable baud-rate generation, memory-mapped registers, 16× receiver oversampling, frame-error detection, and full-duplex loopback verification.

`HDL` `Verilog` `UART 8-N-1` `RTL Design` `FIFO 16×8` `Vivado` `Simulation` `Full-Duplex`

---

## 📌 Overview

The UART Controller is a modular synthesizable RTL design implementing a standard **8-N-1 UART communication interface**.

The controller integrates:

- UART Transmitter
- UART Receiver
- Independent 16×8 TX FIFO
- Independent 16×8 RX FIFO
- Programmable Baud Rate Generator
- Memory-Mapped Register Interface
- 16× Receiver Oversampling
- Frame Error Detection
- Full-Duplex Loopback

The design was implemented in **Verilog HDL** and functionally verified using **Xilinx Vivado**.

---

## 🏗️ Architecture

### Transmit Path

```text
Host
  │
  ▼
UART Registers
  │
  ▼
TX FIFO (16×8)
  │
  ▼
UART TX
  │
  ▼
TX
```

### Receive Path

```text
RX
  │
  ▼
UART RX
  │
  ▼
RX FIFO (16×8)
  │
  ▼
UART Registers
  │
  ▼
Host
```

The `baud_gen` module provides the timing reference used by both the UART transmitter and receiver.

---

## 📡 UART Protocol

The controller uses the standard **8-N-1** UART frame format:

```text
IDLE | START | D0 D1 D2 D3 D4 D5 D6 D7 | STOP
HIGH |  LOW  |       DATA — LSB FIRST   | HIGH
```

- 1 Start bit
- 8 Data bits
- No parity
- 1 Stop bit
- Idle line = HIGH
- Data transmitted LSB first
- 16× receiver oversampling

A complete UART frame contains **10 bits**.

---

## 🧩 RTL Modules

| Module | Function |
|---|---|
| `uart_top` | Top-level integration of the UART controller |
| `uart_regs` | Register decoding, configuration, and host interface |
| `FIFO` | 16×8 buffering for TX and RX paths |
| `baud_gen` | Programmable UART timing generation |
| `uart_tx` | UART frame transmission |
| `uart_rx` | UART frame reception and validation |
| `uart_tb` | System-level verification testbench |

---

## 🗺️ Register Map

| Address | Register | Access | Reset Value |
|---:|---|---|---:|
| `0x0` | `TX_DATA` | Write | `0x00` |
| `0x4` | `RX_DATA` | Read | `0x00` |
| `0x8` | `STATUS` | Read | `0x14` |
| `0xC` | `CONTROL` | Read / Write | `0x07` |
| `0xD` | `BAUD_DIV` | Read / Write | `0x1B` |

### STATUS Register

| Bit | Name | Description |
|---:|---|---|
| 0 | `TX_BUSY` | Transmitter is active |
| 1 | `TX_FIFO_FULL` | TX FIFO is full |
| 2 | `TX_FIFO_EMPTY` | TX FIFO is empty |
| 3 | `RX_FIFO_FULL` | RX FIFO is full |
| 4 | `RX_FIFO_EMPTY` | RX FIFO is empty |
| 5 | `RX_AVAILABLE` | Received data is available |
| 6 | `RX_FRAME_ERROR` | Invalid UART stop bit detected |
| 7 | Reserved | Tied to `0` |

### CONTROL Register

| Bit | Name | Description |
|---:|---|---|
| 0 | `UART_ENABLE` | Enables the UART controller |
| 1 | `TX_ENABLE` | Enables UART transmission |
| 2 | `RX_ENABLE` | Enables UART reception |
| 7:3 | Reserved | Read as `0` |

### BAUD_DIV Register

`BAUD_DIV` is an 8-bit programmable divisor.

Default value:

```text
27 decimal = 0x1B
```

The baud generator produces a timing pulse every:

```text
BAUD_DIV × 16 system clock cycles
```

Increasing the divisor increases the UART bit period, while decreasing it reduces the bit period.

---

## 🧪 Verification

The complete design was verified using a dedicated **Verilog testbench in Xilinx Vivado**.

| Test | Verification Case | Result |
|---|---|---|
| T1 | Reset | ✅ PASS |
| T2 | Single-Byte TX | ✅ PASS |
| T3 | Multiple-Byte TX | ✅ PASS |
| T4 | TX FIFO Full | ✅ PASS |
| T5 | Single-Byte RX | ✅ PASS |
| T6 | Multiple-Byte RX | ✅ PASS |
| T7 | RX FIFO Full | ✅ PASS |
| T8 | Bad Stop Bit | ✅ PASS |
| T9 | Register Access | ✅ PASS |
| T10 | Baud Scaling | ✅ PASS |
| T11 | Full-Duplex Loopback | ✅ PASS |

### Verification Result

**11 / 11 verification tests passed successfully.**

The verification covers reset behavior, UART transmission and reception, FIFO boundary conditions, frame-error detection, register access, programmable baud-rate scaling, and full-duplex communication.

---

## 🖥️ Simulation

The project was simulated using **Xilinx Vivado**.

The testbench provides:

- System clock generation
- Synchronous active-high reset
- Host-side register transactions
- UART RX serial stimuli
- TX/RX loopback verification
- PASS/FAIL result reporting

The simulation waveforms were used to verify the timing and functional behavior of the individual test cases.

---

## 🔌 RTL Schematic

The elaborated RTL schematic shows the internal structure and interconnection of the UART Controller.

Main blocks include:

```text
uart_regs
    │
    ├── TX FIFO ──► uart_tx ──► TX
    │
    └── RX FIFO ◄── uart_rx ◄── RX

baud_gen ─────────► baud_tick
```

The complete design is integrated through the `uart_top` module.

---

## 📁 Project Structure

```text
UART-Controller-Verilog/
│
├── uart_top.v
├── uart_regs.v
├── FIFO.v
├── baud_gen.v
├── uart_tx.v
├── uart_rx.v
├── uart_tb.v
│
├
├── rx_data.txt
│
└── README.md
```

The exact simulation file set may vary depending on the Vivado project configuration.

---

## 🚀 How to Simulate

1. Open the project in **Xilinx Vivado**.
2. Add the RTL source files.
3. Add `uart_tb.v` as a simulation source.
4. Set `uart_tb` as the simulation top module.
5. Run **Behavioral Simulation**.
6. Observe the UART waveforms.
7. Check the testbench console for the T1–T11 results.

---

## 🛠️ Tools & Technologies

- **Verilog HDL**
- **Xilinx Vivado**
- RTL Design
- UART Communication
- FIFO Architecture
- Digital Design
- Simulation & Waveform Analysis

---

## 🔮 Future Improvements

Possible extensions include:

- Parity support
- Configurable data and stop-bit formats
- Interrupt generation
- 16550-compatible UART features
- Configurable FIFO trigger levels
- Enhanced oversampling techniques

---

## 📌 Project Status

**Phase 1 — Completed**

**Synthesizable RTL + Full Vivado Verification**

All defined functional verification tests passed successfully.
