package sparkler.utils;

class Maths {

	static public inline var TAU = 6.28318530717958648;
	static public inline var DEG2RAD:Float = 6.28318530717958648 / 360;
	static public inline var RAD2DEG:Float = 360 / 6.28318530717958648;
	static public inline var EPSILON:Float = 1e-10;

	static public inline function lerp(start:Float, end:Float, t:Float):Float {
		return start + t * (end - start);
	}

	static public inline function inverseLerp(start:Float, end:Float, value:Float):Float {
		return end == start ? 0.0 : (value - start) / (end - start);
	}

	static public inline function clamp(value:Float, a:Float, b:Float):Float {
		return ( value < a ) ? a : ( ( value > b ) ? b : value );
	}

	static public inline function map(istart:Float, iend:Float, ostart:Float, oend:Float, value:Float):Float {
		return ostart + (oend - ostart) * ((value - istart) / (iend - istart));
	}

	static public inline function imap(istart:Int, iend:Int, ostart:Int, oend:Int, value:Float):Int {
		return Std.int(map(istart, iend, ostart, oend, value));
	}

	static public inline function distanceSq(dx:Float, dy:Float) {
		return dx * dx + dy * dy;
	}

	static public inline function distance(dx:Float, dy:Float) {
		return Math.sqrt(distanceSq(dx,dy));
	}

	static public inline function radians(degrees:Float):Float {
		return degrees * DEG2RAD;
	}

	static public inline function degrees(radians:Float):Float {
		return radians * RAD2DEG;
	}

}