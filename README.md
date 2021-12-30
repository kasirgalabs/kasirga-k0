# Kasırga K0 RISC-V SoC

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)


Table of contents
=================

- [Overview](#overview)
- [K0 Block Diagram](#k0-block-diagram)
- [Key Features](#key-features)
- [Prerequisites](#prerequisites)
- [Running Full Chip Simulation](#tests)
- [Hardening the Kasirga K0 using Openlane](#hardening)
- [Checklist for Open-MPW Submission](#checklist)


Overview
========

This repo contains a RISC-V based SoC (K0) that utilizes the
`caravel <https://github.com/efabless/caravel.git>`__ chip user space.
K0 is an ASIC-compatible SoC that has a RISC-V core with RV32-IM ISA and UART module @ 115200 baudrate. The
repo also contains all required files to run any rv32-im tests programming through UART.



# K0 Block Diagram

TBA


# Key Features

TBA


# Prerequisites

TBA

# Running Full Chip Simulation

TBA

# Hardening the Kasirga K0 using Openlane

TBA

# Checklist for Open-MPW Submission

-  ✔️ The project repo adheres to the same directory structure in this
   repo.
-  ✔️ The project repo contain info.yaml at the project root.
-  ✔️ Top level macro is named ``user_project_wrapper``.
-  ✔️ Full Chip Simulation passes for RTL and GL (gate-level)
-  ✔️ The hardened Macros are LVS and DRC clean
-  ✔️ The project contains a gate-level netlist for ``user_project_wrapper`` at verilog/gl/user_project_wrapper.v
-  ✔️ The hardened ``user_project_wrapper`` adheres to the same pin
   order specified at
   `pin\_order <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper_empty/pin_order.cfg>`__
-  ✔️ The hardened ``user_project_wrapper`` adheres to the fixed wrapper configuration specified at `fixed_wrapper_cfgs <https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl>`__
-  ✔️ XOR check passes with zero total difference.
-  ✔️ Openlane summary reports are retained under ./signoff/
-  ✔️ The design passes the `mpw-precheck <https://github.com/efabless/mpw_precheck>`__ 

