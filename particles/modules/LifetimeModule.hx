package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;

import luxe.Vector;
import phoenix.Texture;
import phoenix.Batcher;


class LifeTimeModule extends ParticleModule {


	public var life:Array<Float>;

	public var lifetime:Float;
	public var lifetime_max:Float;


	public function new(_options:LifeTimeModuleOptions) {

		super();

		life = [];

		lifetime = _options.lifetime != null ? _options.lifetime : 2;
		lifetime_max = _options.lifetime_max != null ? _options.lifetime_max : 0;

	}

	override function spawn(p:Particle) {

		if(lifetime_max > 0) {
			life[p.id] = emitter.random_float(lifetime, lifetime_max);
		} else {
			life[p.id] = lifetime;
		}

	}

	override function init() {

		for (i in 0...particles.capacity) {
			life[i] = lifetime;
		}
	    
	}

	override function update(dt:Float) {

		var p:Particle;
		var i:Int = 0;
		var len:Int = particles.length;
		while(i < len) {
			p = particles.get(i);
			life[p.id] -=dt;
			if(life[p.id] <= 0) {
				emitter.unspawn(p);
				len = particles.length;
			} else {
				i++;
			}
		}

	}


}



typedef LifeTimeModuleOptions = {

	@:optional var lifetime : Float;
	@:optional var lifetime_max : Float;

}


