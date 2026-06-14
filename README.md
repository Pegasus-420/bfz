# bfz

A small Brainfuck interpreter written in Zig.

I built this to understand how interpreters work internally.

Features:

- plus command increases the current cell
- minus command decreases the current cell
- right command moves the pointer right
- left command moves the pointer left
- dot command prints the current cell
- comma command reads one byte of input
- square brackets handle loops

The interpreter uses:

- a 30000 byte tape
- a data pointer
- an instruction pointer
- simple bracket matching

Run examples:

zig build run -- '+++>++<-'

zig build run -- '++++++++[>++++++++<-]>+.'

printf 'Z' | zig build run -- ',.'

Next step:

- read Brainfuck code from a file
