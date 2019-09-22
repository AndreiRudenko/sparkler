package sparkler.utils;


import sparkler.data.Vector;


class VectorExtender {


	public static inline function toJson(v:Vector):Dynamic {

		return { x: v.x, y: v.y };
	    
	}

	public static inline function fromJson(v:Vector, json:Dynamic):Vector {

		return v.set(json.x, json.y);
	    
	}
	

}