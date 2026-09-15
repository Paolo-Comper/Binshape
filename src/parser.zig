const std = @import("std");
const Io = std.Io;

const invisible_ascii =
    "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f" ++
    "\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f" ++
    "\x7f" ++
    " \t\n\r";

const TypeDeclHeaderError = error{
    UnclosedSquareBracket,
};

pub const ParseError = TypeDeclHeaderError;

pub const Parser = struct {
    io: Io,
    writer: *Io.Writer,
    path: []const u8,
    row: usize = 0,
    col: usize = 1,

    pub fn next_row(self: *Parser) void {
        self.row += 1;
        self.col = 1;
    }

    pub fn setColTo(self: *Parser, raw: []const u8, slice: []const u8, index: usize) void {
        self.col = @intFromPtr(slice.ptr) - @intFromPtr(raw.ptr) + 1 + index;
    }

    pub fn fail(self: *Parser, err: ParseError) void {
        self.writer.print(
            "{s}:{d}:{d}: error: {s}\n",
            .{ self.path, self.row, self.col, @errorName(err) },
        ) catch {};
        // TODO:  Dispatcher di errori con descrizione fatta bene
    }
};

const TypeDeclKind = enum {
    @"enum",
    @"struct",
    @"union",

    pub fn fromString(s: []const u8) ?TypeDeclKind {
        inline for (@typeInfo(TypeDeclKind).@"enum".fields) |f| {
            if (std.mem.eql(u8, s, f.name)) return @enumFromInt(f.value);
        }
        return null;
    }

    pub fn shortestFieldNameLen() usize {
        const fields = @typeInfo(TypeDeclKind).@"enum".fields;
        var min_len: usize = std.math.maxInt(usize);
        inline for (fields) |f| {
            min_len = @min(min_len, f.name.len);
        }
        return min_len;
    }
};

pub const TypeDeclHeader = struct {
    kind: TypeDeclKind,
    type_name: []const u8,

    fn min_vlaid_len() usize {
        const min_valid_kind_len = TypeDeclKind.shortestFieldNameLen();
        //    '['  min_valid_kind_len  '.' 'x' ']'
        return 1 + min_valid_kind_len + 1 + 1 + 1;
    }

    // TODO: cambiare ?void in ?TypeDeclHeader, Hack temporaneo per far compilare
    pub fn parse(parser: *Parser, raw_line: []const u8) ?void {
        const min_valid_len = min_vlaid_len();

        // Check if it is long enought to be a TypeDeclHeader
        if (raw_line.len < min_valid_len) return null;

        // Check if it is a TypeDeclHeader
        var line: []const u8 = std.mem.trimStart(u8, raw_line, invisible_ascii);
        if (line.len < min_valid_len) return null;
        if (line[0] != '[') return null;

        var index_dot: usize = undefined;
        if (std.mem.findScalar(u8, line, '.')) |i| {
            index_dot = i;
        } else return null;

        // Exlude comments
        if (std.mem.findScalar(u8, line, '#')) |index| {
            line = line[0..index];
        }
        line = std.mem.trimEnd(u8, line, invisible_ascii);
        if (line.len < min_valid_len) return null;

        if (line[line.len - 1] != ']') {
            // Place the cursor on the char next to the last one
            // [enum.PacketId
            //               ^
            parser.setColTo(raw_line, line, line.len);
            parser.fail(TypeDeclHeaderError.UnclosedSquareBracket);
            unreachable;
        }

        const str_kind: []const u8 = line[1..index_dot];
        std.debug.print("Kind: {s}\n", .{str_kind});
    }
};
