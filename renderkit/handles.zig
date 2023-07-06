const std = @import("std");

/// generates versioned "handles" (https://floooh.github.io/2018/06/17/handles-vs-pointers.html)
/// you choose the type of the handle (aka its size) and how much of that goes to the index and the version.
/// the bitsize of version + id must equal the handle size.
pub fn Handles(comptime HandleType: type, comptime IndexType: type, comptime VersionType: type) type {
    std.debug.assert(@typeInfo(HandleType) == .Int and std.meta.Int(.unsigned, @bitSizeOf(HandleType)) == HandleType);
    std.debug.assert(@typeInfo(IndexType) == .Int and std.meta.Int(.unsigned, @bitSizeOf(IndexType)) == IndexType);
    std.debug.assert(@typeInfo(VersionType) == .Int and std.meta.Int(.unsigned, @bitSizeOf(VersionType)) == VersionType);

    if (@bitSizeOf(IndexType) + @bitSizeOf(VersionType) != @bitSizeOf(HandleType))
        @compileError("IndexType and VersionType must sum to HandleType's bit count");

    return struct {
        const Self = @This();

        handles: []HandleType,
        append_cursor: IndexType = 1, // reserve 0 for invalid
        last_destroyed: ?IndexType = null,
        allocator: std.mem.Allocator,

        const invalid_id = std.math.maxInt(IndexType);

        pub fn init(allocator: std.mem.Allocator, capacity: usize) Self {
            return Self{
                .handles = allocator.alloc(HandleType, capacity) catch unreachable,
                .allocator = allocator,
            };
        }

        pub fn deinit(self: Self) void {
            self.allocator.free(self.handles);
        }

        pub fn extractIndex(self: Self, handle: HandleType) IndexType {
            _ = self;
            return @as(IndexType, @truncate(handle));
        }

        pub fn extractVersion(self: Self, handle: HandleType) VersionType {
            _ = self;
            return @as(VersionType, @truncate(handle >> @bitSizeOf(IndexType)));
        }

        fn forge(id: IndexType, version: VersionType) HandleType {
            return id | @as(HandleType, version) << @bitSizeOf(IndexType);
        }

        pub fn create(self: *Self) HandleType {
            if (self.last_destroyed == null) {
                // ensure capacity
                std.debug.assert(self.handles.len - 1 != self.append_cursor);

                const id = self.append_cursor;
                const handle = forge(self.append_cursor, 0);
                self.handles[id] = handle;

                self.append_cursor += 1;
                return handle;
            }

            const version = self.extractVersion(self.handles[self.last_destroyed.?]);
            const destroyed_id = self.extractIndex(self.handles[self.last_destroyed.?]);

            const handle = forge(self.last_destroyed.?, version);
            self.handles[self.last_destroyed.?] = handle;

            self.last_destroyed = if (destroyed_id == invalid_id) null else destroyed_id;

            return handle;
        }

        pub fn destroy(self: *Self, handle: HandleType) void {
            const id = self.extractIndex(handle);
            const next_id = self.last_destroyed orelse invalid_id;
            std.debug.assert(next_id != id);

            const version = self.extractVersion(handle);
            self.handles[id] = forge(next_id, version +% 1);

            self.last_destroyed = id;
        }

        pub fn alive(self: Self, handle: HandleType) bool {
            const id = self.extractIndex(handle);
            return id < self.append_cursor and self.handles[id] == handle;
        }
    };
}

/// Fixed size object cache that uses versioned Handles to identify resources. All objects are stored in a preallocated array
/// so they do not need to be stack allocated outside of the HandledCache.
pub fn HandledCache(comptime T: type) type {
    const HandleType = u16;

    return struct {
        items: []T,
        handles: Handles(u16, u8, u8),

        pub fn init(allocator: std.mem.Allocator, capacity: usize) @This() {
            return .{
                .items = allocator.alloc(T, capacity) catch unreachable,
                .handles = Handles(u16, u8, u8).init(allocator, capacity),
            };
        }

        pub fn deinit(self: @This()) void {
            self.handles.allocator.free(self.items);
            self.handles.deinit();
        }

        pub fn append(self: *@This(), item: T) HandleType {
            var handle = self.handles.create();
            self.items[self.handles.extractIndex(handle)] = item;
            return handle;
        }

        pub fn get(self: @This(), handle: HandleType) *T {
            std.debug.assert(self.handles.alive(handle));
            return &self.items[self.handles.extractIndex(handle)];
        }

        pub fn free(self: *@This(), handle: HandleType) *T {
            std.debug.assert(self.handles.alive(handle));
            var obj = &self.items[self.handles.extractIndex(handle)];
            self.handles.destroy(handle);
            return obj;
        }
    };
}

test "cache" {
    var cache = HandledCache(u32).init(std.testing.allocator, 5);
    defer cache.deinit();

    var h1 = cache.append(666);
    std.debug.assert(cache.get(h1).* == 666);
    _ = cache.free(h1);

    h1 = cache.append(667);
    std.debug.assert(cache.get(h1).* == 667);
    _ = cache.free(h1);

    h1 = cache.append(6);
    std.debug.assert(cache.get(h1).* == 6);
}

test "handles" {
    var hm = Handles(u32, u20, u12).init(std.testing.allocator, 10);
    defer hm.deinit();

    const e0 = hm.create();
    const e1 = hm.create();
    const e2 = hm.create();

    std.debug.assert(hm.alive(e0));
    std.debug.assert(hm.alive(e1));
    std.debug.assert(hm.alive(e2));

    hm.destroy(e1);
    std.debug.assert(!hm.alive(e1));

    var e_tmp = hm.create();
    std.debug.assert(hm.alive(e_tmp));

    hm.destroy(e_tmp);
    std.debug.assert(!hm.alive(e_tmp));

    hm.destroy(e0);
    std.debug.assert(!hm.alive(e0));

    hm.destroy(e2);
    std.debug.assert(!hm.alive(e2));

    e_tmp = hm.create();
    std.debug.assert(hm.alive(e_tmp));

    e_tmp = hm.create();
    std.debug.assert(hm.alive(e_tmp));

    e_tmp = hm.create();
    std.debug.assert(hm.alive(e_tmp));
}
