package sparkler.core;

import sparkler.data.Color;

class Particle {

	@:allow(sparkler.core.ParticleVector)
	public var id(default, null):Int;

	public var x:Float = 0;
	public var y:Float = 0;
	
	public var lifetime:Float = 1;
	public var age:Float = 0;


	public function new(id:Int) {
		
		this.id = id;

	}


}
