package sparkler.utils;

abstract Color(Int) from Int to Int {

	static public inline function fromValue(value:Int):Color {
		var c = new Color();
		c.value = value;
		return c;
	}

	static public inline function lerp(a:Color, b:Color, t:Float):Color {
		var c = new Color();
		t = (t > 1) ? 1 : ((t < 0) ? 0 : t);
		c.setBytes(
			a.rB + Std.int((b.rB - a.rB) * t),
			a.gB + Std.int((b.gB - a.gB) * t),
			a.bB + Std.int((b.bB - a.bB) * t),
			a.aB + Std.int((b.aB - a.aB) * t)
		);
		return c;
	}

	static inline var invMaxChannelValue: Float = 1 / 255;

	public var r(get, set):Float;
	public var g(get, set):Float;
	public var b(get, set):Float;
	public var a(get, set):Float;

	public var rB(get, set):Int;
	public var gB(get, set):Int;
	public var bB(get, set):Int;
	public var aB(get, set):Int;

	public var value(get, set):Int;

	public inline function new(r:Float = 1, g:Float = 1, b:Float = 1, a:Float = 1) {
		this = (Std.int(a * 255) << 24) | (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
	}

	public inline function set(r:Float, g:Float, b:Float, a:Float):Color {
		this = (Std.int(a * 255) << 24) | (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
		return this;
	}

	public inline function setBytes(rB:Int, gB:Int, bB:Int, aB:Int):Color {
		this = (aB << 24) | (rB << 16) | (gB << 8) | bB;		
		return this;
	}

	public inline function clone():Color {
		return Color.fromValue(this);
	}

	inline function get_r():Float {
		return get_rB() * invMaxChannelValue;
	}

	inline function get_g():Float {
		return get_gB() * invMaxChannelValue;
	}

	inline function get_b():Float {
		return get_bB() * invMaxChannelValue;
	}

	inline function get_a():Float {
		return get_aB() * invMaxChannelValue;
	}

	inline function set_r(f:Float):Float {
		this = (Std.int(a * 255) << 24) | (Std.int(f * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
		return f;
	}

	inline function set_g(f:Float):Float {
		this = (Std.int(a * 255) << 24) | (Std.int(r * 255) << 16) | (Std.int(f * 255) << 8) | Std.int(b * 255);
		return f;
	}

	inline function set_b(f:Float):Float {
		this = (Std.int(a * 255) << 24) | (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(f * 255);
		return f;
	}

	inline function set_a(f:Float):Float {
		this = (Std.int(f * 255) << 24) | (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
		return f;
	}

	inline function get_rB():Int {
		return (this & 0x00ff0000) >>> 16;
	}

	inline function get_gB():Int {
		return (this & 0x0000ff00) >>> 8;
	}

	inline function get_bB():Int {
		return this & 0x000000ff;
	}

	inline function get_aB():Int {
		return this >>> 24;
	}

	inline function set_rB(i:Int):Int {
		this = (aB << 24) | (i << 16) | (gB << 8) | bB;
		return i;
	}

	inline function set_gB(i:Int):Int {
		this = (aB << 24) | (rB << 16) | (i << 8) | bB;
		return i;
	}

	inline function set_bB(i:Int):Int {
		this = (aB << 24) | (rB << 16) | (gB << 8) | i;
		return i;
	}

	inline function set_aB(i:Int):Int {
		this = (i << 24) | (rB << 16) | (gB << 8) | bB;
		return i;
	}

	inline function get_value():Int {
		return this;
	}

	inline function set_value(value:Int):Int {
		this = value;
		return this;
	}
	
}