pub const Vec4 = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
    w: f32 = 0,

    pub fn asArray(self: Vec4) [4]f32 {
        return [_]f32{ self.x, self.y, self.z, self.w };
    }
};
