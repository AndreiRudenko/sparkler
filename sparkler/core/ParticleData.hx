package sparkler.core;


import sparkler.data.Color;


class ParticleData {


	public var x:Float = 0;
	public var y:Float = 0;

	public var r:Float = 0;

	public var w:Float = 32;
	public var h:Float = 32;

	public var s:Float = 1;
	public var lifetime:Float = 1;

	public var color:Color;
	public var sprite(default,null):Any;


	public function new(_sprite:Any) {
		
		color = new Color();
		sprite = _sprite;

	}


}
