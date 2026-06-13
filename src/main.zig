const std = @import("std");

const tape_size = 30_000;
const dump_cells = 10;

pub fn main() !void {
    // For the first version, we hardcode the Brainfuck code
    // Later we will read this from command-line args or a file
    const code = "+++>++<-";

    // Brainfuck memory tape
    // each cell is one byte and starts at 0
    var tape = [_]u8{0} ** tape_size;

    // ptr =data pointer
    // It tells us which tape cell we are currently using
    var ptr: usize = 0;

    // ip = instruction pointer
    // It tells us which Brainfuck command we are reading
    var ip: usize = 0;

    while (ip < code.len) : (ip += 1) {
        const cmd = code[ip];

        switch (cmd) {
            '+' => {
                //increase current cell
                // +%= wraps around: 255 + 1 becomes 0
                tape[ptr] +%= 1;
            },

            '-' => {
                // decrease current cell
                // -%= wraps around 0 - 1 becomes 255
                tape[ptr] -%= 1;
            },

            '>' => {
                    // move pointer right.
                if (ptr + 1 >= tape_size) {
                    std.debug.print("error: pointer moved beyond tape at instruction {d}\n", .{ip});
                    return error.PointerOutOfBounds;
                }

                ptr += 1;
            },

            '<' => {
                  //move pointer left.
                if (ptr == 0) {
                    std.debug.print("error: pointer moved left before cell 0 at instruction {d}\n", .{ip});
                    return error.PointerOutOfBounds;
                }

                ptr -= 1;
            },

            '.', ',', '[', ']' => {
                // These Brainfuck commands will be added later
                std.debug.print("error: command '{c}' is not implemented yet\n", .{cmd});
                return error.CommandNotImplemented;
            },

            else => {
                // ignore spaces, newlines, and random text
            },
        }
    }


    dumpTape(tape[0..], ptr);
}
fn dumpTape(tape: []const u8, ptr: usize) void {
    std.debug.print("code = +++>++<-\n", .{});
    std.debug.print("pointer = {d}\n", .{ptr});
    std.debug.print("first {d} cells: ", .{dump_cells});

    var i: usize = 0;
    while (i < dump_cells) : (i += 1) {
        if (i == ptr) {
            std.debug.print("[{d}] ", .{tape[i]});
        } else {
            std.debug.print("{d} ", .{tape[i]});
        }
    }

    std.debug.print("\n", .{});
}
