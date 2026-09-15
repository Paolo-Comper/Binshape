const std = @import("std");
const File = std.Io.File;

pub fn error_opening_file(writer: *std.Io.Writer, path: []const u8, err: File.OpenError) noreturn {
    switch (err) {
        File.OpenError.AccessDenied => {
            writer.print("Access denied to file '{s}': you do not have the required permissions.\n", .{path}) catch {};
        },
        File.OpenError.AntivirusInterference => {
            writer.print("Cannot open '{s}': antivirus software is interfering with the operation.\n", .{path}) catch {};
        },
        File.OpenError.BadPathName => {
            writer.print("Invalid path for '{s}': the file or directory name contains disallowed characters.\n", .{path}) catch {};
        },
        File.OpenError.Canceled => {
            writer.print("Opening of '{s}' was canceled before completion.\n", .{path}) catch {};
        },
        File.OpenError.DeviceBusy => {
            writer.print("Cannot open '{s}': the device is busy.\n", .{path}) catch {};
        },
        File.OpenError.FileBusy => {
            writer.print("File '{s}' is currently in use by another process.\n", .{path}) catch {};
        },
        File.OpenError.FileLocksUnsupported => {
            writer.print("Cannot open '{s}': the filesystem does not support file locking.\n", .{path}) catch {};
        },
        File.OpenError.FileNotFound => {
            writer.print("File '{s}' not found: the specified path does not exist.\n", .{path}) catch {};
        },
        File.OpenError.FileTooBig => {
            writer.print("File '{s}' is too large to open.\n", .{path}) catch {};
        },
        File.OpenError.IsDir => {
            writer.print("'{s}' is a directory, not a file.\n", .{path}) catch {};
        },
        File.OpenError.NameTooLong => {
            writer.print("Path '{s}' is too long for the filesystem.\n", .{path}) catch {};
        },
        File.OpenError.NetworkNotFound => {
            writer.print("Cannot open '{s}': the network resource is unreachable.\n", .{path}) catch {};
        },
        File.OpenError.NoDevice => {
            writer.print("Cannot open '{s}': the underlying device does not exist.\n", .{path}) catch {};
        },
        File.OpenError.NoSpaceLeft => {
            writer.print("Cannot open '{s}': no space left on device.\n", .{path}) catch {};
        },
        File.OpenError.NotDir => {
            writer.print("'{s}' is not a directory (a path component is not a directory).\n", .{path}) catch {};
        },
        File.OpenError.PathAlreadyExists => {
            writer.print("Path '{s}' already exists.\n", .{path}) catch {};
        },
        File.OpenError.PermissionDenied => {
            writer.print("Permission denied for '{s}': user lacks required rights.\n", .{path}) catch {};
        },
        File.OpenError.PipeBusy => {
            writer.print("Cannot open '{s}': the pipe is busy.\n", .{path}) catch {};
        },
        File.OpenError.ProcessFdQuotaExceeded => {
            writer.print("Cannot open '{s}': process file descriptor quota exceeded.\n", .{path}) catch {};
        },
        File.OpenError.ReadOnlyFileSystem => {
            writer.print("Cannot open '{s}' for writing: filesystem is mounted read-only.\n", .{path}) catch {};
        },
        File.OpenError.SymLinkLoop => {
            writer.print("Cannot open '{s}': symbolic link loop detected.\n", .{path}) catch {};
        },
        File.OpenError.SystemFdQuotaExceeded => {
            writer.print("Cannot open '{s}': system file descriptor quota exceeded.\n", .{path}) catch {};
        },
        File.OpenError.SystemResources => {
            writer.print("Cannot open '{s}': insufficient system resources (memory, fds, etc.).\n", .{path}) catch {};
        },
        File.OpenError.Unexpected => {
            writer.print("Unexpected error while opening '{s}'.\n", .{path}) catch {};
        },
        File.OpenError.WouldBlock => {
            writer.print("Cannot open '{s}': operation would block (non-blocking I/O).\n", .{path}) catch {};
        },
    }

    writer.flush() catch {};
    @panic("impossibile aprire il file");
}
