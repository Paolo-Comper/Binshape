const std = @import("std");
const errors = @import("errors.zig");

const Io = std.Io;

const BaseTypes = enum {
    U8,
    U16,
    U32,
    U64,
    U128,

    I8,
    I16,
    I32,
    I64,
    I128,

    F32,
    BOOL,
};

const StructField = struct {
    name: []u8,
    type: union(enum) {
        base_type: BaseTypes,
        idx_type: usize,
    },
};

const TypeStruct = struct {
    idx_type: usize,
    fields: []StructField,
};

const EnumField = struct {
    name: []u8,
    id: u32,
};

const TypeEnum = struct {
    idx_type: usize,
    fields: []EnumField,
};

const UnionField = struct {
    name: ?[]u8,
    idx_type: usize,
};

const TypeUnion = struct {
    name: usize,
    fields: UnionField,
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(allocator);
    const input_path = if (args.len > 1) args[1] else "test/test.toml";

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout = &stdout_file_writer.interface;

    try stdout.flush();
}

fn parse(writer: *std.Io.Writer, path: []u8) !void {
    const file = std.Io.Dir.cwd().openFile(io, "example.txt", .{})
        catch |err| errors.error_opening_file(writer, path, err);
    defer file.close(io);

    var buffer: [1024]u8 = undefined;
    const fread = file.reader(io, &buffer);
    const reader = &fread.interface;

    // 3. Read line by line
    while (try reader.takeDelimiter('\n')) |line| {
        std.debug.print("{s}\n", .{line});
    } else |err| {
        if (err != error.EndOfStream) return err;
    }
}


    // Apri il file

    // Buffer per la lettura
    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    // Buffer per ogni riga
    var line_buffer: [4096]u8 = undefined;

    // Leggi riga per riga
    while (try reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        std.debug.print("Riga: {s}\n", .{line});
    }

