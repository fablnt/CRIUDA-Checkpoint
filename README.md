# Checkpoint/Restore with CRIUDA
Efficient checkpointing of AI workloads is a crucial task to ensure the reliability, reproducibility, and fault tolerance of large-scale training processes. This involves storing the internal state of both GPU and CPU processes as a collection of files, which can later be used to restore the exact process state.
The checkpoint mechanism can be implemented at different levels of the software stack: application-level (not transparent), library-level (semi-transparent), and system-level (fully transparent). System level checkpointing does not require any assumption on the tasks to checkpoint, offering a more general and trasparent approach compared to the other solutions. 

A fully transparent and efficient checkpointing solution is offered by the checkpoint/restore tool CRIU (Checkpoint/Restore In Userspace) starting from version 4.0. In particular, CRIU combines GPU and CPU state in a single unified snapshot, eliminating performance overheads typical of state-of-the-art transparent checkpointing mechanism.

The `checkpoint.sh` script is provided in this repository to handle the execution of checkpoint and restore operations with CRIU in a simplified manner.

## How to install
Follow the steps below to install and use CRIU:

1. Install CRIU from [CRIU Installation](https://criu.org/Installation)
2. Clone this repository
3. Modify variable [CRIU_EX](https://github.com/fablnt/CRIUDA-Checkpoint/blob/master/checkpoint.sh#L11C1-L11C11) in checkpoint.sh inserting the path to the criu executable located in the /criu/criu/ directory (e.g. CRIU_EX="/home/mpcheckpoint/criu/criu/").
4. Modify variable [DIR](https://github.com/fablnt/CRIUDA-Checkpoint/blob/master/bashrc#L1) in the bashrc file inserting the path to the CRIU directory (e.g. DIR=/home/mpcheckpoint).
5. TODO cuda plugin.

## Usage

