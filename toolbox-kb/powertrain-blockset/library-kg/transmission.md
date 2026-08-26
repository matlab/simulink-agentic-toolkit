---
type: Simulink Block Category
title: Transmission
description: Transmission systems and controllers
tags: [transmission, cvt, dct, amt, torque converter]
status: stable
source: mathworks_toolbox
library_root: Powertrain Blockset
category_path: Transmission
block_count: 8
---

# Transmission

Use these blocks for transmission.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Torque Converter | autolibtrqconv/Torque Converter | R2023a+ | Model hydrodynamic torque converter — use for simulating fluid coupling between engine and automatic transmission |
| AMT Controller | autolibtranscontrols/AMT Controller | R2023a+ | Automated manual transmission controller — use for shift scheduling and clutch control in AMT |
| CVT Controller | autolibtranscontrols/CVT Controller | R2023a+ | CVT ratio controller — use for controlling continuously variable transmission ratio |
| DCT Controller | autolibtranscontrols/DCT Controller | R2023a+ | Dual-clutch transmission controller — use for shift scheduling and clutch coordination in DCT |
| Automated Manual Transmission | autolibtrans/Automated Manual Transmission | R2023a+ | Complete AMT system — use for simulating automated manual gearbox with clutch actuator |
| Continuously Variable Transmission | autolibtrans/Continuously Variable Transmission | R2023a+ | Complete CVT system — use for simulating belt or chain CVT with ratio control |
| Dual Clutch Transmission | autolibtrans/Dual Clutch Transmission | R2023a+ | Complete DCT system — use for simulating dual-clutch gearbox with seamless shifts |
| Ideal Fixed Gear Transmission | autolibtrans/Ideal Fixed Gear Transmission | R2023a+ | Simple fixed-ratio gearbox — use for fast simulation when shift dynamics are not needed |
