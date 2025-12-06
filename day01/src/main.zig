const std = @import("std");

pub fn main() !void {
    var dialog: i32 = 50;
    var count: u16 = 0;

    const allocator = std.heap.page_allocator;
    const content = try std.fs.cwd().readFileAlloc(allocator, "input", 20000);
    defer allocator.free(content);

    var lines = std.mem.splitScalar(u8, content, '\n');

    while (lines.next()) |line| {
        if (line.len > 0) {
            if (line[0] == 'R') {
                const i = try std.fmt.parseInt(i32, line[1..], 10);
                dialog = @mod(dialog + i, 100);
                if (dialog == 0)
                    count += 1;
            } else if (line[0] == 'L') {
                const i = try std.fmt.parseInt(i32, line[1..], 10);
                dialog = @mod(dialog - i, 100);
                if (dialog == 0)
                    count += 1;
            }
        }
    }
    std.debug.print("Password: {d}\n", .{count});
}
