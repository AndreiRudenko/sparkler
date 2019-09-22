package sparkler.utils;



class Mathf {


	public static inline function clamp(value:Float, a:Float, b:Float):Float {

		return ( value < a ) ? a : ( ( value > b ) ? b : value );

	}

	public static inline function clampBottom(value:Float, a:Float):Float {

		return value < a ? a : value;

	}

		/** Convert a number from degrees to radians */
	public static inline function radians(degrees:Float):Float {

		return degrees * DEG2RAD;

	}

		/** Convert a number from radians to degrees */
	public static inline function degrees(radians:Float):Float {

		return radians * RAD2DEG;

	}

		/** Used by `degrees()` and `radians()`, use those to convert, unless needed */
	public static inline var DEG2RAD:Float = 3.14159265358979 / 180;
		/** Used by `degrees()` and `radians()`, use those to convert, unless needed */
	public static inline var RAD2DEG:Float = 180 / 3.14159265358979;

	public static inline var EPSILON:Float = 1e-8;


}