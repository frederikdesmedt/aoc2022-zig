const std = @import("std");
const ArrayList = std.ArrayList;
const allocator = std.heap.page_allocator;

test "expect program to solve example solution for part 1" {
    const input = [_][]const u8{
        "A Y",
        "B X",
        "C Z"
    };
    const expected: u32 = 15;
    const actual = try solvePart1(input[0..]);
    try std.testing.expectEqual(expected, actual);
}

test "expect program to solve example solution for part 2" {
    const input = [_][]const u8{
        "A Y",
        "B X",
        "C Z"
    };
    const expected: u32 = 12;
    const actual = try solvePart2(input[0..]);
    try std.testing.expectEqual(expected, actual);
}

fn solvePart1(input: []const[]const u8) GameError!u32 {
    var totalScore: u32 = 0;
    for (input) |game| {
        const opponentsMove = try Move.parseChar(game[0]);
        const myMove = try Move.parseChar(game[2]);
        const outcome = calculateOutcome(opponentsMove, myMove);
        totalScore += calculateScore(outcome, myMove);
    }
    return totalScore;
}

fn solvePart2(input: []const[]const u8) GameError!u32 {
    var totalScore: u32 = 0;
    for (input) |game| {
        const opponentsMove = try Move.parseChar(game[0]);
        const desiredOutcome = try Outcome.parseChar(game[2]);
        const moveToPlay = findMove(opponentsMove, desiredOutcome);
        totalScore += calculateScore(desiredOutcome, moveToPlay);
    }
    return totalScore;
}

fn calculateScore(outcome: Outcome, move: Move) u32 {
    const outcomeScore: u32 = switch (outcome) {
        Outcome.won => 6,
        Outcome.draw => 3,
        Outcome.lost => 0
    };
    const moveScore: u32 = switch (move) {
        Move.rock => 1,
        Move.paper => 2,
        Move.scissors => 3
    };
    return outcomeScore + moveScore;
}

fn findMove(opponentMove: Move, desiredOutcome: Outcome) Move {
    return switch (opponentMove) {
        Move.rock => switch (desiredOutcome) {
            Outcome.draw => Move.rock,
            Outcome.won => Move.paper,
            Outcome.lost => Move.scissors
        },
        Move.paper => switch (desiredOutcome) {
            Outcome.lost => Move.rock,
            Outcome.draw => Move.paper,
            Outcome.won => Move.scissors
        },
        Move.scissors => switch (desiredOutcome) {
            Outcome.won => Move.rock,
            Outcome.lost => Move.paper,
            Outcome.draw => Move.scissors
        }
    };
}

fn calculateOutcome(opponentMove: Move, myMove: Move) Outcome {
    return switch (opponentMove) {
        Move.rock => switch (myMove) {
            Move.rock => Outcome.draw,
            Move.paper => Outcome.won,
            Move.scissors => Outcome.lost
        },
        Move.paper => switch (myMove) {
            Move.rock => Outcome.lost,
            Move.paper => Outcome.draw,
            Move.scissors => Outcome.won
        },
        Move.scissors => switch (myMove) {
            Move.rock => Outcome.won,
            Move.paper => Outcome.lost,
            Move.scissors => Outcome.draw
        }
    };
}

const GameError = error{
    InvalidMove,
    InvalidOutcome
};

const Move = enum{
    rock,
    paper,
    scissors,

    fn parseChar(char: u8) GameError!Move {
        return switch (char) {
            'A' => Move.rock,
            'B' => Move.paper,
            'C' => Move.scissors,
            'X' => Move.rock,
            'Y' => Move.paper,
            'Z' => Move.scissors,
            else => GameError.InvalidMove
        };
    }
};

const Outcome = enum{
    won,
    lost,
    draw,

    fn parseChar(char: u8) GameError!Outcome {
        return switch (char) {
            'X' => Outcome.lost,
            'Y' => Outcome.draw,
            'Z' => Outcome.won,
            else => GameError.InvalidOutcome
        };
    }
};

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
