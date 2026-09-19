# UART Controller

A synthesizable **UART Controller** implemented in Verilog HDL, integrating serial communication, programmable baud-rate control, independent TX/RX FIFOs, and a memory-mapped register interface.

## Project Overview

The controller implements a standard **8-N-1 UART** format: one start bit, eight data bits transmitted LSB first, no parity, and one stop bit. The TX and RX paths operate independently and are integrated through the top-level `uart_top` module.

## Main Features

- Synthesizable Verilog RTL
- Standard 8-N-1 UART communication
- Programmable `BAUD_DIV`
- Independent 16×8 TX and RX FIFOs
- 16× receiver oversampling
- UART frame-error detection
- Memory-mapped register interface
- TX busy and FIFO status monitoring
- Full-duplex loopback support
- `irq` reserved for future extension

## Architecture

### Transmit Path

```text
Host → uart_regs → TX FIFO → uart_tx → TX
```

### Receive Path

```text
RX → uart_rx → RX FIFO → uart_regs → Host
```

The `baud_gen` module provides the timing reference used by both the transmitter and receiver.

## UART Frame Format

```text
Idle    Start     D0 D1 D2 D3 D4 D5 D6 D7     Stop
 HIGH     LOW      <-------- Data -------->     HIGH
```

Data is transmitted **LSB first**.

The receiver uses **16× oversampling** and samples incoming data near the center of each bit period.

## Register Map

| Address | Register | Access | Reset Value |
|---|---|---|---|
| `0x0` | `TX_DATA` | Write | `0x00` |
| `0x4` | `RX_DATA` | Read | `0x00` |
| `0x8` | `STATUS` | Read | `0x14` |
| `0xC` | `CONTROL` | Read/Write | `0x07` |
| `0xD` | `BAUD_DIV` | Read/Write | `0x1B` |

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
| 1 | `TX_ENABLE` | Enables transmission |
| 2 | `RX_ENABLE` | Enables reception |
| 7:3 | Reserved | Read as `0` |

### BAUD_DIV Register

`BAUD_DIV` is an 8-bit programmable divisor. Its default value is `27` (`0x1B`).

The baud generator produces a timing pulse every:

```text
BAUD_DIV × 16 system clock cycles
```

A larger divisor produces a longer UART bit period.

## RTL Modules

| Module | Function |
|---|---|
| `uart_top` | Top-level integration |
| `uart_regs` | Register decoding and host interface |
| `FIFO` | 16×8 TX/RX buffering |
| `baud_gen` | Programmable UART timing generation |
| `uart_tx` | UART frame transmission |
| `uart_rx` | UART frame reception and validation |
| `uart_tb` | System-level verification testbench |

## Verification

The complete design was verified using a dedicated Verilog testbench in **Vivado**.

| Test | Verification Case |
|---|---|
| T1 | Reset |
| T2 | Single-Byte TX |
| T3 | Multiple-Byte TX |
| T4 | TX FIFO Full |
| T5 | Single-Byte RX |
| T6 | Multiple-Byte RX |
| T7 | RX FIFO Full |
| T8 | Bad Stop Bit |
| T9 | Register Access |
| T10 | Baud Scaling |
| T11 | Full-Duplex Loopback |

**Result: All 11 verification tests passed successfully.**

## Project Structure

```text
UART_Controller/
├── uart_top.v
├── uart_regs.v
├── FIFO.v
├── baud_gen.v
├── uart_tx.v
├── uart_rx.v
├── uart_tb.v
├── tx_data.txt
├── rx_data.txt
└── README.md
```

The exact simulation file set may vary depending on the Vivado project configuration.

## Simulation

The design can be simulated using **Xilinx Vivado**:

1. Create or open the Vivado project.
2. Add the RTL source files.
3. Add the testbench as a simulation source.
4. Set `uart_tb` as the simulation top module.
5. Run behavioral simulation.
6. Observe the UART waveforms and PASS/FAIL results.

## RTL Schematic

The elaborated RTL schematic shows the main hardware modules and their interconnections inside `uart_top`, including:

- `uart_regs`
- TX FIFO
- RX FIFO
- `uart_tx`
- `uart_rx`
- `baud_gen`

## Future Improvements

Possible extensions include:

- Parity support
- Configurable data and stop-bit formats
- Interrupt generation
- 16550-compatible UART features
- Configurable FIFO trigger levels
- Enhanced oversampling techniques

## Tools

- Verilog HDL
- Xilinx Vivado
- RTL simulation and waveform analysis

## Project Status

**Phase 1 — Completed**

All defined functional verification tests passed successfully.
