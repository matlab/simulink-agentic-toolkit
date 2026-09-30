---
type: Simulink Block Category
title: Rf data converter
description: RFSoC direct-RF ADC/DAC data converter interface
tags: [rf data converter, adc to vector, vector to dac, rfdc, aurora, otava]
status: stable
source: custom_library
library_root: SoC Blockset Support Package for AMD FPGA and SoC Devices
category_path: Rf data converter
block_count: 22
---

# Rf data converter

Use these blocks for rf data converter.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC To Vector | rfsoczcu111lib/ADC To Vector | R2023a+ | Collect samples from the RFSoC data-converter ADC into a vector/frame — use to frame direct-RF receive data for processing. |
| Aurora 64B66B | rfsoczcu111lib/Aurora 64B66B | R2023a+ | Send and receive data over a Xilinx Aurora 64B/66B high-speed serial link — use for board-to-board or FPGA-to-FPGA transport. |
| RF Data Converter | rfsoczcu111lib/RF Data Converter | R2023a+ | Configure and interface the RFSoC integrated RF data converter (ADC/DAC) — use as the direct-RF sampling front end on RFSoC. |
| RFDC Bus Creator | rfsoczcu111lib/RFDC Bus Creator | R2023a+ | Bundle RF-data-converter control and status signals into a bus — use to organize the RFDC interface. |
| RFDC Bus Selector | rfsoczcu111lib/RFDC Bus Selector | R2023a+ | Select individual signals from the RF-data-converter bus — use to access specific RFDC control/status lines. |
| Vector To DAC | rfsoczcu111lib/Vector To DAC | R2023a+ | Stream a sample vector/frame to the RFSoC data-converter DAC — use to drive direct-RF transmit output. |
| ADC To Vector | rfsoczcu208lib/ADC To Vector | R2023a+ | Collect samples from the RFSoC data-converter ADC into a vector/frame — use to frame direct-RF receive data for processing. |
| OTAVA DTRX2 | rfsoczcu208lib/OTAVA DTRX2 | R2023a+ | Interface the OTAVA DTRX2 RF front-end daughtercard — use to connect that RF module to an RFSoC design. |
| RF Data Converter | rfsoczcu208lib/RF Data Converter | R2023a+ | Configure and interface the RFSoC integrated RF data converter (ADC/DAC) — use as the direct-RF sampling front end on RFSoC. |
| RFDC Bus Creator | rfsoczcu208lib/RFDC Bus Creator | R2023a+ | Bundle RF-data-converter control and status signals into a bus — use to organize the RFDC interface. |
| RFDC Bus Selector | rfsoczcu208lib/RFDC Bus Selector | R2023a+ | Select individual signals from the RF-data-converter bus — use to access specific RFDC control/status lines. |
| Vector To DAC | rfsoczcu208lib/Vector To DAC | R2023a+ | Stream a sample vector/frame to the RFSoC data-converter DAC — use to drive direct-RF transmit output. |
| ADC To Vector | rfsoczcu216lib/ADC To Vector | R2023a+ | Collect samples from the RFSoC data-converter ADC into a vector/frame — use to frame direct-RF receive data for processing. |
| RF Data Converter | rfsoczcu216lib/RF Data Converter | R2023a+ | Configure and interface the RFSoC integrated RF data converter (ADC/DAC) — use as the direct-RF sampling front end on RFSoC. |
| RFDC Bus Creator | rfsoczcu216lib/RFDC Bus Creator | R2023a+ | Bundle RF-data-converter control and status signals into a bus — use to organize the RFDC interface. |
| RFDC Bus Selector | rfsoczcu216lib/RFDC Bus Selector | R2023a+ | Select individual signals from the RF-data-converter bus — use to access specific RFDC control/status lines. |
| Vector To DAC | rfsoczcu216lib/Vector To DAC | R2023a+ | Stream a sample vector/frame to the RFSoC data-converter DAC — use to drive direct-RF transmit output. |
| ADC To Vector | rfsoczcu670lib/ADC To Vector | R2023a+ | Collect samples from the RFSoC data-converter ADC into a vector/frame — use to frame direct-RF receive data for processing. |
| RF Data Converter | rfsoczcu670lib/RF Data Converter | R2023a+ | Configure and interface the RFSoC integrated RF data converter (ADC/DAC) — use as the direct-RF sampling front end on RFSoC. |
| RFDC Bus Creator | rfsoczcu670lib/RFDC Bus Creator | R2023a+ | Bundle RF-data-converter control and status signals into a bus — use to organize the RFDC interface. |
| RFDC Bus Selector | rfsoczcu670lib/RFDC Bus Selector | R2023a+ | Select individual signals from the RF-data-converter bus — use to access specific RFDC control/status lines. |
| Vector To DAC | rfsoczcu670lib/Vector To DAC | R2023a+ | Stream a sample vector/frame to the RFSoC data-converter DAC — use to drive direct-RF transmit output. |
