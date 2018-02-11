package sparkler.utils;


import luxe.Color;


class ColorTools {


	public static inline function to_json(c:Color) {

		return {r:c.r, g:c.g, b:c.b, a:c.a};
		
	}

	public static inline function from_json(c:Color, d:Dynamic) {

		c.r = d.r;
		c.g = d.g;
		c.b = d.b;
		c.a = d.a;

		return c;
	    
	}

}