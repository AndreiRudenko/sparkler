package sparkler.utils;



class Mathf {


	public static inline function clamp(value:Float, a:Float, b:Float):Float {

		return ( value < a ) ? a : ( ( value > b ) ? b : value );

	}

	public static inline function clamp_bottom(value:Float, a:Float):Float {

		return value < a ? a : value;

	}
	

}