const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

test "expect program to solve example solution for part 1" {
    const input = [_][]const u8{
        "vJrwpWtwJgWrhcsFMMfFFhFp",
        "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
        "PmmdzqPrVvPwwTWBwg",
        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
        "ttgJtRGJQctTZtZT",
        "CrZsJsPPZsGzwwsLwLmpwMDw"
    };
    const expected: u32 = 157;
    const actual = try solvePart1(input[0..]);
    try std.testing.expectEqual(expected, actual);
}

test "expect program to solve example solution for part 2" {
    const input = [_][]const u8{
        "vJrwpWtwJgWrhcsFMMfFFhFp",
        "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
        "PmmdzqPrVvPwwTWBwg",
        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
        "ttgJtRGJQctTZtZT",
        "CrZsJsPPZsGzwwsLwLmpwMDw"
    };
    const expected: u32 = 70;
    const actual = try solvePart2(input[0..]);
    try std.testing.expectEqual(expected, actual);
}

fn solvePart1(input: []const[]const u8) !u32 {
    var prioritySum: u32 = 0;
    for (input) |rucksack| {
        const compartmentSize = rucksack.len / 2;
        const itemsInCompartment1 = rucksack[0..compartmentSize];
        const itemsInCompartment2 = rucksack[compartmentSize..];
        for (itemsInCompartment1) |item| {
            const needle = [_]u8{item};
            if (std.mem.containsAtLeast(u8, itemsInCompartment2, 1, needle[0..])) {
                prioritySum += priorityForItem(item);
                break;
            }
        }
    }
    return prioritySum;
}

fn priorityForItem(item: u8) u32 {
    if (item >= 'a' and item <= 'z') {
        return item + 1 - 'a';
    } else {
        return item + 27 - 'A';
    }
}

fn solvePart2(input: []const[]const u8) !u32 {
    var prioritySum: u32 = 0;
    const length = input.len;
    var index: usize = 0;
    while (index < length) {
        defer index += 3;
        const elf1 = input[index];
        const elf2 = input[index+1];
        const elf3 = input[index+2];
        for (elf1) |item| {
            const needle = [_]u8{item};
            if (std.mem.containsAtLeast(u8, elf2, 1, needle[0..]) and
                std.mem.containsAtLeast(u8, elf3, 1, needle[0..])) {
                prioritySum += priorityForItem(item);
                break;
            }
        }
    }
    return prioritySum;
}

pub fn main() !void {
    var linesList = try readLines();
    const lines = linesList.toOwnedSlice();
    const solutionPart1 = try solvePart1(lines);
    try std.io.getStdOut().writer().print("Solution part 1: {}\n", .{solutionPart1});
    const solutionPart2 = try solvePart2(lines);
    try std.io.getStdOut().writer().print("Solution part 2: {}\n", .{solutionPart2});
}

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
