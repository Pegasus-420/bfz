const std = @import("std");

const tape_size = 30_000;
const dump_cells = 10;

pub fn main(init: std.process.Init.Minimal) !void {
    var args = init.args.iterate();

    // First arg is the program name. We do not need it.
    _ = args.next();

    const code = args.next() orelse {
        std.debug.print("usage:\n", .{});
        std.debug.print("  zig build run -- '+++>++<-'\n", .{});
        std.debug.print("  zig build run -- '++++++++[>++++++++<-]>+.'\n", .{});
        return;
    };

    try run(code);
}

fn run(code: []const u8) !void {
    // Brainfuck memory tape.
    // Each cell is one byte.
    var tape = [_]u8{0} ** tape_size;

    // ptr = data pointer.
    // It tells which tape cell we are currently using.
    var ptr: usize = 0;

    // ip = instruction pointer.
    // It tells which Brainfuck command we are reading.
    var ip: usize = 0;

    while (ip < code.len) {
        const cmd = code[ip];

        switch (cmd) {
            '+' => {
                tape[ptr] +%= 1;
            },

            '-' => {
                tape[ptr] -%= 1;
            },

            '>' => {
                if (ptr + 1 >= tape_size) {
                    std.debug.print("error: pointer moved beyond tape at instruction {d}\n", .{ip});
                    return error.PointerOutOfBounds;
                }

                ptr += 1;
            },

            '<' => {
                if (ptr == 0) {
                    std.debug.print("error: pointer moved left before cell 0 at instruction {d}\n", .{ip});
                    return error.PointerOutOfBounds;
                }

                ptr -= 1;
            },

            '.' => {
                // Print the current cell as an ASCII character.
                std.debug.print("{c}", .{tape[ptr]});
            },

            ',' => {
                // Read one byte from stdin.
                // If there is no input, store 0.
                var input_buf: [1]u8 = undefined;
                const n = std.posix.read(0, input_buf[0..]) catch 0;

                if (n == 0) {
                    tape[ptr] = 0;
                } else {
                    tape[ptr] = input_buf[0];
                }
            },

            '[' => {
                // If current cell is 0, skip this loop.
                if (tape[ptr] == 0) {
                    ip = try jumpForward(code, ip);
                }
            },

            ']' => {
                // If current cell is not 0, go back to the start of loop.
                if (tape[ptr] != 0) {
                    ip = try jumpBack(code, ip);
                }
            },

            else => {
                // Brainfuck ignores anything that is not one of its 8 commands.
            },
        }

        ip += 1;
    }

    dumpTape(tape[0..], ptr);
}

fn jumpForward(code: []const u8, start: usize) !usize {
    var depth: usize = 1;
    var i: usize = start + 1;

    while (i < code.len) : (i += 1) {
        switch (code[i]) {
            '[' => depth += 1,
            ']' => {
                depth -= 1;

                if (depth == 0) {
                    return i;
                }
            },
            else => {},
        }
    }

    std.debug.print("error: unmatched '[' at instruction {d}\n", .{start});
    return error.UnmatchedOpenBracket;
}

fn jumpBack(code: []const u8, start: usize) !usize {
    var depth: usize = 1;
    var i: usize = start;

    while (i > 0) {
        i -= 1;

        switch (code[i]) {
            ']' => depth += 1,
            '[' => {
                depth -= 1;

                if (depth == 0) {
                    return i;
                }
            },
            else => {},
        }
    }

    std.debug.print("error: unmatched ']' at instruction {d}\n", .{start});
    return error.UnmatchedCloseBracket;
}

fn dumpTape(tape: []const u8, ptr: usize) void {
    std.debug.print("\n\npointer = {d}\n", .{ptr});
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
