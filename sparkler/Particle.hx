package sparkler;

#if !macro
@:genericBuild(sparkler.utils.ParticleMacro.build())
#end

class Particle<Rest> {}

class ParticleBase {
	
	public var id(default, null):Int;
	public var index:Int = 0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var lifetime:Float = 1;
	public var age:Float = 0;

	public function new(id:Int) {
		this.id = id;
	}

}