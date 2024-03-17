// https://kth.kattis.com/submissions/13114697

const std = @import("std");

var everything: [500_000 * 16]u8 = undefined;
var output: [500_000 * 16]u8 = undefined;
var numbers: [500_002]u128 = undefined;

var numbers_alt: [500_002]u128 = undefined;
inline fn countingSort(arr: []u128, into: []u128, comptime place: usize) void {
    var count = [_]usize{0} ** 256;

    for (arr) |elem| {
        const v: u8 = @truncate(elem >> place);
        count[v] += 1;
    }

    inline for (1..count.len) |i| {
        count[i] += count[i - 1];
    }

    var i = arr.len;
    while (i > 0) {
        i -= 1;
        const long_value = arr[i];
        const v: u8 = @truncate(long_value >> place);
        into[count[v] - 1] = long_value;
        count[v] -= 1;
    }
}

inline fn printNumbers(arr: []u128) usize {
    var output_index: usize = 0;
    for (arr) |num| {
        var real_num = num;
        if ((num >> 127) == 0) {
            real_num = ~num;
        }
        inline for(5..16) |revers| {
            const i = 15 - revers;
            const s: u128 = real_num >> (8 * i);
            const b: u8 = @truncate(s);
            if (b >= '-') {
                output[output_index] = b;
                output_index += 1;
            }
        }
        output[output_index] = ' ';
        output_index += 1;
    }
    return output_index;
}

inline fn doWork(n: usize) void {
    const std_out = std.io.getStdOut().writer();

    const end = std.mem.indexOfScalar(u8, &everything, ' ') orelse return;
    const spec_count = std.fmt.parseInt(usize, everything[0..end], 10) catch @panic("bad num");

    var number_index: usize = 0;
    var number_value: u128 = 0;
    var number_started: bool = false;
    var negative_number: bool = false;
    everything[n] = ' '; // Make sure we terminate last number.
    for (everything[0..n+1]) |c| {
        switch (c) {
            inline '-' => {
                negative_number = true;
                number_value = '-';
            },
            inline '0' ... '9' => |ch| {
                number_started = true;
                number_value <<= 8;
                number_value |= ch;
            },
            else => {
                if (number_started) {
                    numbers[number_index] = blk: {
                        if (negative_number) {
                            break :blk number_value ^ ~@as(u128, 0) >> 1;
                        } else {
                            break :blk number_value | (1 << 127);
                        }
                    };
                    negative_number = false;
                    number_started = false;
                    number_value = 0;
                    number_index += 1;
                    if (number_index > spec_count) {
                        break;
                    }
                }
            }
        }

    }

    @setEvalBranchQuota(20_000);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 0);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 1);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 2);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 3);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 4);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 5);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 6);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 7);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 8);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 9);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 10);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 11);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 12);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 13);
    countingSort(numbers[1..spec_count + 1], numbers_alt[1..spec_count + 1], 8 * 14);
    countingSort(numbers_alt[1..spec_count + 1], numbers[1..spec_count + 1], 8 * 15);

    const output_index = printNumbers(numbers[1..spec_count + 1]);

    _ = std_out.writeAll(output[0..output_index]) catch @panic("bad pipe");

}

pub fn main() void {
    const n = std.io.getStdIn().readAll(&everything) catch @panic("bad read");
    doWork(n);
}

test "big" {
    const s = @embedFile("big.txt");
    @memcpy(everything[0..s.len], s);
    doWork(s.len);
}
