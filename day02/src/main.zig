const std = @import("std");

fn ret_invalid(nums: [2]u64) u64 {
    var sum: u64 = 0;
    var current = nums[0];
    var buf: [10]u8 = undefined;

    while (current <= nums[1]) : (current += 1) {
        const str = std.fmt.bufPrint(&buf, "{d}", .{current}) catch unreachable;
        const half = str.len / 2;
        const left = str[0..half];
        const right = str[half..];

        if (std.mem.eql(u8, left, right)) {
            sum += current;
        }
    }

    return sum;
}

pub fn main() !void {
    var total: u64 = 0;
    var i: usize = 0;
    var nums = [2]u64{ 0, 0 };

    const allocator = std.heap.page_allocator;
    const raw_content = try std.fs.cwd().readFileAlloc(allocator, "input", 480);
    defer allocator.free(raw_content);
    const content = std.mem.trim(u8, raw_content, &std.ascii.whitespace);
    var lines = std.mem.splitScalar(u8, content, ',');

    while (lines.next()) |line| {
        i = 0;
        var parts = std.mem.splitScalar(u8, line, '-');
        while (parts.next()) |part| : (i += 1) {
            nums[i] = try std.fmt.parseInt(u64, part, 10);
        }
        total += ret_invalid(nums);
    }
    std.debug.print("Total: {d}\n", .{total});
}
