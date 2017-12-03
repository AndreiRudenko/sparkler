package particles.core;


import particles.core.Particle;
import particles.containers.ParticleVector;
import particles.ParticleEmitter;


class ParticleModule {


	public var enabled:Bool = true;
	public var name (default, null):String;

	@:noCompletion public var prev : ParticleModule;
	@:noCompletion public var next : ParticleModule;
	@:noCompletion public var priority : Int = 0;
	@:noCompletion public var override_priority : Bool = false;

	var emitter:ParticleEmitter;
	var particles:ParticleVector;


	public function new() {

		name = Type.getClassName(Type.getClass(this));

	}

	public function destroy() {}

	public function update(dt:Float) {}

	public function spawn(p:Particle) {}
	public function unspawn(p:Particle) {}

	function init() {}

	@:allow(particles.ParticleEmitter)
	inline function _init(_emitter:ParticleEmitter) {

		emitter = _emitter;
		particles = emitter.particles;
		init();

	}


}

