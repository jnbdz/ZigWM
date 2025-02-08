const std = @import("std");
const zigx = @import("zigx");

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    // Open X Display
    const display = zigx.x11.XOpenDisplay(null);
    if (display == null) {
        std.debug.print("Failed to open X display.\n", .{});
        return;
    }

    // Get default screen
    const screen_num = zigx.x11.XDefaultScreen(display);
    const screen = zigx.x11.XScreenOfDisplay(display, screen_num);
    const root_window = zigx.x11.XRootWindowOfScreen(screen);

    // Create a simple window
    const black_pixel = zigx.x11.XBlackPixel(display, screen_num);
    const white_pixel = zigx.x11.XWhitePixel(display, screen_num);

    const win = zigx.x11.XCreateSimpleWindow(
        display,
        root_window,
        100,   // x
        100,   // y
        400,   // width
        300,   // height
        1,     // border_width
        black_pixel,
        white_pixel,
    );

    // Select input events (keyboard, exposure, close, etc.)
    zigx.x11.XSelectInput(display, win,
        zigx.x11.ExposureMask
        | zigx.x11.KeyPressMask
        | zigx.x11.ButtonPressMask
        | zigx.x11.StructureNotifyMask
    );

    // Set the window title
    const title = "Hello from Zig!\0";
    zigx.x11.XStoreName(display, win, title);

    // Map (show) the window
    zigx.x11.XMapWindow(display, win);

    // Event loop
    var event: zigx.x11.XEvent = .{};
    var running = true;

    while (running) {
        zigx.x11.XNextEvent(display, &event);
        switch (event.@type) {
            zigx.x11.Expose => {
                // (re-draw or handle expose event if needed)
            },
            zigx.x11.KeyPress => {
                std.debug.print("Key pressed!\n", .{});
                // For example: if we press 'q', we might exit
            },
            zigx.x11.DestroyNotify => {
                // The window was destroyed or we want to quit
                running = false;
            },
            else => {
                // no-op
            },
        }
    }

    // Cleanup
    zigx.x11.XDestroyWindow(display, win);
    zigx.x11.XCloseDisplay(display);
    std.debug.print("Exited cleanly.\n", .{});
}
