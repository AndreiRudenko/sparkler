package sparkler.utils;

import sparkler.utils.Color;

class ColorFloat {

	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;

	public function new(r:Float = 1, g:Float = 1, b:Float = 1, a:Float = 1) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public inline function fromColor(c:Color) {
		r = c.r;
		g = c.g;
		b = c.b;
		a = c.a;
	}

}
