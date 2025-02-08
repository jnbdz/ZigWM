const std = @import("std");

pub fn build(b: *std.Build) void {
    // Create a build option for debug vs release
    const mode = b.standardReleaseOptions();

    // Define the main executable
    const exe = b.addExecutable("dwm-zig", "src/main.zig");
    exe.setBuildMode(mode);

    // If we want to use zigx as a subpackage:
    exe.addPackagePath("zigx", "zigx/src/main.zig");

    // We must link to required system libraries for X
    // This often includes X11, Xinerama, Xext, etc.
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("Xinerama");
    exe.linkSystemLibrary("Xft");
    // Add more as needed

    // Install step
    exe.install();

    // Final default step
    const run_cmd = exe.run();
    if (b.args) |args| {
        // If we do `zig build run`, pass command line args to the exe
        run_cmd.addArgs(args);
    }
}
