const std = @import("std");

fn find_batteries(bank: []const u8) u32 {
    var nums = [2]u8{ '0', '0' };
    var numses = [2]u32{ 0, 0 };
    var old_highest: u8 = '0';
    var highest: u8 = '0';

    for (bank) |char| {
        if (char > highest) {
            old_highest = highest;
            highest = char;
            nums[0] = char;
            nums[1] = '.';
        } else if (char >= nums[1]) {
            nums[1] = char;
        }
    }
    if (nums[1] == '.') {
        nums[0] = old_highest;
        nums[1] = highest;
    }
    numses[0] = (nums[0] - '0');
    numses[1] = (nums[1] - '0');
    const total = (numses[0] * 10 + numses[1]);

    return (total);
}

pub fn main() !void {
    var total: u32 = 0;
    const allocator = std.heap.page_allocator;
    const raw_content = try std.fs.cwd().readFileAlloc(
        allocator,
        "input",
        20200,
    );
    defer allocator.free(raw_content);

    var banks = std.mem.splitScalar(u8, raw_content, '\n');

    while (banks.next()) |line| {
        total += find_batteries(line);
    }
    std.debug.print("Total: {d}\n", .{total});
}
