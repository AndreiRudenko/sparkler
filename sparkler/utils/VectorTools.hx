package sparkler.utils;


import luxe.Vector;


class VectorTools {


	public static inline function to_json(v:Vector) {

		return {x:v.x, y:v.y, z:v.z, w:v.w};
	    
	}

	public static inline function from_json(v:Vector, d:Dynamic) {

		v.x = d.x;
		v.y = d.y;
		v.z = d.z;
		v.w = d.w;

		return v;
	    
	}

}