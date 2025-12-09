const std = @import("std");

const LINE_WIDTH: usize = 141;
const GRID_SIZE: usize = 140;

const Valid = struct {
    can_minus_row: bool,
    can_plus_row: bool,
    can_minus_col: bool,
    can_plus_col: bool,
};

fn check_valid(row: usize, col: usize) Valid {
    return .{
        .can_minus_row = row > 0,
        .can_plus_row = row < GRID_SIZE - 1,
        .can_minus_col = col > 0,
        .can_plus_col = col < GRID_SIZE - 1,
    };
}

fn getChar(content: []const u8, row: usize, col: usize) u8 {
    return content[row * LINE_WIDTH + col];
}

fn check_neighbor(content: []const u8, row: usize, col: usize) bool {
    var count: usize = 0;
    const v = check_valid(row, col);
    const target: u8 = '@';

    if (v.can_minus_row and v.can_minus_col and getChar(content, row - 1, col - 1) == target) count += 1;
    if (v.can_minus_row and getChar(content, row - 1, col) == target) count += 1;
    if (v.can_minus_row and v.can_plus_col and getChar(content, row - 1, col + 1) == target) count += 1;
    if (v.can_minus_col and getChar(content, row, col - 1) == target) count += 1;
    if (v.can_plus_col and getChar(content, row, col + 1) == target) count += 1;
    if (v.can_plus_row and v.can_minus_col and getChar(content, row + 1, col - 1) == target) count += 1;
    if (v.can_plus_row and getChar(content, row + 1, col) == target) count += 1;
    if (v.can_plus_row and v.can_plus_col and getChar(content, row + 1, col + 1) == target) count += 1;

    return (count < 4);
}

pub fn main() !void {
    var total: usize = 0;
    const allocator = std.heap.page_allocator;
    const raw_content = try std.fs.cwd().readFileAlloc(
        allocator,
        "input",
        19740,
    );
    defer allocator.free(raw_content);
    for (0..GRID_SIZE) |row| {
        for (0..GRID_SIZE) |col| {
            const char = getChar(raw_content, row, col);
            if (char == '@' and check_neighbor(raw_content, row, col)) {
                std.debug.print("X", .{});
                total += 1;
            } else {
                std.debug.print("{c}", .{char});
            }
        }
    }
    std.debug.print("\n{d}\n", .{total});
}
