const std = @import("std");

fn count_digits(n: u64) u32 {
    if (n == 0) return 1;
    var num = n;
    var count: u32 = 0;
    while (num > 0) : (count += 1) {
        num /= 10;
    }
    return count;
}

fn ret_invalid(nums: [2]u64) u64 {
    var sum: u64 = 0;
    var current = nums[0];

    while (current <= nums[1]) : (current += 1) {
        const digits = count_digits(current);

        if (digits % 2 != 0) continue;

        var divisor: u64 = 1;
        var i: u32 = 0;
        while (i < digits / 2) : (i += 1) {
            divisor *= 10;
        }

        const left = current / divisor;
        const right = current % divisor;

        if (left == right) {
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
