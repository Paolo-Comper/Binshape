const std = @import("std");
const errors = @import("errors.zig");
const parser = @import("parser.zig");

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
    const allocator = init.arena.allocator();
    const io = init.io;
    const args = try init.minimal.args.toSlice(allocator);
    const input_path = if (args.len > 1) args[1] else "test/test.toml";

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout = &stdout_file_writer.interface;

    try parse(io, stdout, input_path);
    try stdout.flush();
}

fn parse(io: std.Io, writer: *std.Io.Writer, path: []const u8) !void {
    if (std.Io.Dir.cwd().openFile(io, path, .{ .mode = .read_only })) |file| {
        defer file.close(io);

        var buf: [1024]u8 = undefined;
        var file_reader: std.Io.File.Reader = file.reader(io, &buf);

        var parser_ctx = parser.Parser{
            .io = io,
            .path = path,
            .writer = writer,
        };

        while (try file_reader.interface.takeDelimiter('\n')) |line| {
            parser_ctx.next_row();
            if (line.len == 0) continue;

            // TODO: Sistemare, Hack temporaneo per vedere se il resto e' corretto
            std.debug.print("Riga {d}: {s}\n", .{ parser_ctx.row, line });

            if (parser.TypeDeclHeader.parse(&parser_ctx, line)) |_| {
                std.debug.print("HA PARSATO!!!\n", .{});
            }
        }
    } else |err| errors.error_opening_file(writer, path, err);
}
