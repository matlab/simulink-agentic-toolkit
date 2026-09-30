---
type: Simulink Block Category
title: Test harness internals
description: Primitive elements that implement the Test Sequence and Test Assessment blocks; not normally placed on their own.
tags: [test-sequence, test-assessment, stimulus, assessment, internal]
status: stable
source: custom_library
library_root: Simulink Test
category_path: Test harness internals
block_count: 8
---

# Test harness internals

Use these blocks for test harness internals.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
|  Demux  | sltestlib/Test Assessment/ Demux  | R2023a+ | Split a combined signal into its component lines — an internal routing primitive inside the Test Sequence and Test Assessment blocks; add the parent Test Sequence or Test Assessment block rather than placing this element directly. |
|  Ground  | sltestlib/Test Assessment/ Ground  | R2023a+ | Provide a grounded zero-valued input to leave a port intentionally undriven — an internal primitive inside the Test Sequence and Test Assessment blocks; not placed on its own in normal workflows. |
|  SFunction  | sltestlib/Test Assessment/ SFunction  | R2023a+ | The core S-Function engine inside the Test Sequence and Test Assessment blocks that executes the authored step-and-transition table to drive time- and state-based test stimulus and evaluate verify/assessment statements — use it by adding a Test Sequence or Test Assessment block, not this element directly. |
|  Terminator  | sltestlib/Test Assessment/ Terminator  | R2023a+ | Cap an unused output so it raises no unconnected-line warning — an internal primitive inside the Test Sequence and Test Assessment blocks; not placed independently in normal workflows. |
|  Demux  | sltestlib/Test Sequence/ Demux  | R2023a+ | Split a combined signal into its component lines — an internal routing primitive inside the Test Sequence and Test Assessment blocks; add the parent Test Sequence or Test Assessment block rather than placing this element directly. |
|  Ground  | sltestlib/Test Sequence/ Ground  | R2023a+ | Provide a grounded zero-valued input to leave a port intentionally undriven — an internal primitive inside the Test Sequence and Test Assessment blocks; not placed on its own in normal workflows. |
|  SFunction  | sltestlib/Test Sequence/ SFunction  | R2023a+ | The core S-Function engine inside the Test Sequence and Test Assessment blocks that executes the authored step-and-transition table to drive time- and state-based test stimulus and evaluate verify/assessment statements — use it by adding a Test Sequence or Test Assessment block, not this element directly. |
|  Terminator  | sltestlib/Test Sequence/ Terminator  | R2023a+ | Cap an unused output so it raises no unconnected-line warning — an internal primitive inside the Test Sequence and Test Assessment blocks; not placed independently in normal workflows. |
