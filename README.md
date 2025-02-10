# UVM-FIFO-Digital-Verification

## Overview
This project implements a Universal Verification Methodology (UVM)-based testbench for verifying a FIFO (First-In, First-Out) design. The focus is on testing key functional improvements, particularly the enhancement of the underflow handling mechanism by transitioning from combinational to sequential logic. The UVM testbench simulates various write and read scenarios to ensure the reliability and functionality of the FIFO design.

## UVM Testbench Structure
Below is a high-level diagram of the UVM testbench architecture used in this project:
(![UVM_Testbench](https://github.com/user-attachments/assets/f00ed80b-eb8c-4288-a84c-8d774053e902)


## Project Structure

### Top Module (`FIFO_top`)
The top module integrates the UVM test, environment, agents, interface, and the design under test (DUT). It orchestrates the simulation by instantiating and configuring necessary components. Key components include:
- **UVM Test** (`FIFO_test`): Initializes the environment and triggers the test sequences for the write and read agents.
- **UVM Environment** (`FIFO_env`): Contains UVM agents and ensures proper connectivity between components.

### UVM Agents
The testbench contains two agents:
1. **Write Agent** (`FIFO_write_agent`): Handles write operations.
    - **Sequencer** (`FIFO_write_sequencer`): Generates write sequences.
    - **Driver** (`FIFO_write_driver`): Drives the signals to the DUT's interface.
    - **Monitor** (`FIFO_write_monitor`): Monitors write operations and captures relevant signals.
  
2. **Read Agent** (`FIFO_read_agent`): Handles read operations.
    - **Sequencer** (`FIFO_read_sequencer`): Generates read sequences.
    - **Driver** (`FIFO_read_driver`): Drives the read signals to the DUT's interface.
    - **Monitor** (`FIFO_read_monitor`): Monitors read operations and collects relevant data.

### Interface Driving
The drivers in each agent interact directly with the DUT through the `FIFO_IF` interface. These drivers abstract the details of signal manipulation and ensure correct operational flow by mimicking the expected behavior.

### Monitoring and Analysis
- **Monitors** observe the DUT's interface and collect data for validation.
- **Scoreboard** compares the expected and actual outputs to verify correctness. Errors are flagged for further debugging.

### Configuration and Coverage
- The testbench includes configuration settings to test different scenarios and edge cases.
- Coverage metrics are collected to assess the effectiveness of the tests.

## Sequences
### Write Sequence
- **Purpose**: Tests write operations by sending randomized values for `wr_en` and `data_in`, while controlling `rst_n`.
- **Expected Behavior**: Verifies FIFO behavior during write operations, including handling resets and capacity limitations.
  
### Read Sequence
- **Purpose**: Tests read operations by sending randomized `rd_en` and `rst_n` signals, verifying how the FIFO handles underflow conditions.
- **Expected Behavior**: Ensures that the FIFO responds to `rd_en` appropriately, and asserts underflow flags when reading from an empty FIFO.

### UVM Test Integration
Both the write and read sequences are executed simultaneously using the `fork...join` construct. This simulates real-world conditions where write and read operations occur concurrently. The test also includes random resets to verify robustness.

## Code Coverage Reports
- **Branch Coverage**: Tracks the coverage of branching conditions in the code.
- **Statement Coverage**: Ensures that all statements in the design are executed.
- **Toggle Coverage**: Verifies the toggling of signals during simulation.
- **Function Coverage**: Tracks the execution of functions in the design.
- **Sequential Domain Coverage**: Verifies that sequential behaviors are adequately tested.

## How to Run the Project
1. Ensure that all files, including `src_files.txt` and `run.do`, are are included in your simulation environment.
2. Compile the design and the testbench using your preferred simulation tool.
3. In the terminal, navigate to the project directory and run the following command:

   ```sh
   do run.do
4. This will compile the design and testbench, run the simulation, and generate coverage reports.
5. View the simulation results using waveform viewers and analyze the coverage reports.
6. Modify the configuration and rerun the simulation to test different operational scenarios.

## Dependencies
- UVM (Universal Verification Methodology) library.
- Simulation tools: Questasim, or similar.


For further details, please refer to the [report](https://github.com/user-attachments/files/18742071/UVM_FIFO_Project.pdf) for more in-depth explanations.
