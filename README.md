# Checkpoint/Restore with CRIUDA
Efficient checkpointing of AI workloads is a crucial task to ensure the reliability, reproducibility, and fault tolerance of large-scale training processes. This involves storing the internal state of both GPU and CPU processes as a collection of files, which can later be used to restore the exact process state.
The checkpoint mechanism can be implemented at different levels of the software stack: application-level (not transparent), library-level (semi-transparent), and system-level (fully transparent). System level checkpointing does not require any assumption on the tasks to checkpoint, offering a more general and trasparent approach compared to the other solutions. 

A fully transparent and efficient checkpointing solution is offered by the checkpoint/restore tool CRIU (Checkpoint/Restore In Userspace) starting from version 4.0. In particular, CRIU combines GPU and CPU state in a single unified snapshot, eliminating performance overheads typical of state-of-the-art transparent checkpointing mechanism.

## how to install
parlare del DIR in bashrc and CRIU_EX in script

## Usage
