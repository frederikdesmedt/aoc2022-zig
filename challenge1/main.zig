const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

fn readLines() !ArrayList([]const u8) {
    var input = try readInput();
    var lineIterator = std.mem.split(u8, input, "\n");
    var lines = ArrayList([]const u8).init(allocator);
    while (lineIterator.next()) |line| {
        try lines.append(line);
    }
    return lines;
}

fn readInput() ![]u8 {
    var file = try std.fs.cwd().openFile("input.txt", .{.read=true});
    defer file.close();
    var size = (try file.stat()).size;
    var buffer: []u8 = try allocator.alloc(u8, size);
    _ = try file.reader().readAll(buffer);
    return buffer;
}

pub fn main() !void {
    var lines = try readLines();
    const solution = findMaxCaloriesWithBackupElves(3, lines);
    try std.io.getStdOut().writer().print("Solution: {}\n", .{solution});
}

fn findMaxCalories(lines: ArrayList([]const u8)) std.fmt.ParseIntError!u32 {
    var max: u32 = 0;
    var curr: u32 = 0;
    for (lines.items) |line| {
        if (std.mem.eql(u8, line, "")) {
            if (curr > max) {
                max = curr;
            }
            curr = 0;
        } else {
            curr += try std.fmt.parseInt(u32, line, 10);
        }
    }
    return max;
}

fn findMaxCaloriesWithBackupElves(
    comptime amountOfBackups: u8,
    lines: ArrayList([]const u8)
) !u32 {
    var elfCaloriesList = ArrayList(u32).init(allocator);
    var curr: u32 = 0;
    for (lines.items) |line| {
        if (std.mem.eql(u8, line, "")) {
            try elfCaloriesList.append(curr);
            curr = 0;
        } else {
            curr += try std.fmt.parseInt(u32, line, 10);
        }
    }
    var elfCalories = elfCaloriesList.toOwnedSlice();
    std.sort.sort(u32, elfCalories, {}, comptime std.sort.desc(u32));
    var solution: u32 = 0;
    for (elfCalories[0..amountOfBackups]) |calory| {
        solution += calory;
    }
    return solution;
}