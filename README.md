# bfz

A tiny Brainfuck interpreter written in Zig.

I am building this to understand how interpreters work internally.

Current version supports only the basic tape commands:

- + increases the current cell
- - decreases the current cell
- > moves the pointer right
- < moves the pointer left

It uses a 30,000 byte tape, a data pointer, and an instruction pointer.

Current hardcoded test program:

+++>++<-

This makes cell 0 equal to 2 and cell 1 equal to 2.

Run:

zig build run

Todo:

- add output command
- add input command
- add loop handling
- add command-line or file input
