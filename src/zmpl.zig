const std = @import("std");

const build_options = @import("build_options");

pub const zmd = @import("zmd");
pub const jetcommon = @import("jetcommon");

// XXX: Ensure that `@import("zmpl").zmpl` always works. This is a workaround to allow Zmpl to be
// imported at build time because `@import("zmpl")` at build time imports `zmpl/build.zig`.
pub const zmpl = @This();

/// Generic, JSON-compatible data type.
pub const Data = @import("zmpl/Data.zig");
pub const Template = @import("zmpl/Template.zig");
pub const Manifest = Template.Manifest;
pub const colors = @import("zmpl/colors.zig");
pub const Format = @import("zmpl/Format.zig");
pub const debug = @import("zmpl/debug.zig");

pub const isZmplValue = Data.isZmplValue;

pub const InitOptions = struct {
    templates_path: []const u8 = "src/templates",
};

pub const util = @import("zmpl/util.zig");

pub const find = Manifest.find;
pub const findPrefixed = Manifest.findPrefixed;

pub fn chomp(input: []const u8) []const u8 {
    return std.mem.trimRight(u8, input, "\r\n");
}

/// Sanitize input. Used internally for rendering data refs. Use `zmpl.fmt.sanitize` to manually
/// sanitize other values.
pub fn sanitize(writer: anytype, input: []const u8) !void {
    if (!build_options.sanitize) {
        _ = try writer.write(input);
        return;
    }

    const fmt = Format{ .writer = if (@TypeOf(writer) == *Data) writer.output_writer else writer };
    _ = try fmt.sanitize(input);
}

/// Helper function for accessing properties from both ZmplValue objects and regular objects
/// Used by @if for field access
pub fn getProperty(obj: anytype, field_name: []const u8) ![]const u8 {
    if (comptime isZmplValue(@TypeOf(obj))) {
        return try obj.chainRefT([]const u8, field_name);
    } else {
        return try std.fmt.allocPrint(std.heap.page_allocator, "{}", .{@field(obj, field_name)});
    }
}

test {
    std.testing.refAllDecls(@This());
}
