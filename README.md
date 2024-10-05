# VHDL Project: ARM Processor with 4-Stage Pipeline

This repository contains the VHDL source files for the implementation of a 4-stage pipelined ARM processor. The pipeline stages include Instruction Fetch (IFETCH), Decode (DECOD), Execute (EXE), and Memory Access (MEM), which are key to achieving efficient instruction processing and performance.

Project Overview
Objective
The goal of this project is to design and implement an ARM processor using VHDL, with a simplified 4-stage pipeline architecture. The processor can execute basic ARM instructions, handle data hazards, and ensure proper instruction flow through the pipeline.

Key Features
4-stage pipeline:
IFETCH: Fetches the instruction from memory.
DECOD: Decodes the instruction and prepares the operands.
EXE: Executes the instruction (ALU operations, branching, etc.).
MEM: Accesses memory for load/store operations.
ARM Instruction Set: Supports a subset of ARM instructions for demonstration purposes.
Hazard Handling: Basic mechanisms for dealing with data hazards in the pipeline.
Synthesis and Physical Implementation: The design is synthesized and physically implemented, with placement and routing to ensure functionality on FPGA.
