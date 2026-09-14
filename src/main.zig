const std = @import("std");
const toml = @import("toml");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const src =
        \\title = "My App"
        \\[server]
        \\port = 8080
    ;

    const root = try toml.parseSlice(allocator, src, null);
    defer toml.deinit(root, allocator);

    const port = root.get("server").?.table.get("port").?.integer.value;
    std.debug.print("port: {}\n", .{port});
}
