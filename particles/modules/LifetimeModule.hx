package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.Components;
import particles.components.Life;


class LifeTimeModule extends ParticleModule {


	public var lifetime:Float;
	public var lifetime_max:Float;

	var life:Components<Life>;


	public function new(_options:LifeTimeModuleOptions) {

		super();

		lifetime = _options.lifetime != null ? _options.lifetime : 2;
		lifetime_max = _options.lifetime_max != null ? _options.lifetime_max : 0;

	}

	override function spawn(p:Particle) {

		if(lifetime_max > 0) {
			life.get(p).amount = emitter.random_float(lifetime, lifetime_max);
		} else {
			life.get(p).amount = lifetime;
		}

	}

	override function init() {

		life = emitter.components.get(Life);

		if(life == null) {
			life = emitter.components.set(
				particles, 
				Life, 
				function() {
					return new Life(lifetime);
				}
			);
		}
		
	}

	override function update(dt:Float) {

		var p:Particle;
		var i:Int = 0;
		var len:Int = particles.length;
		while(i < len) {
			p = particles.get(i);
			life.get(p).amount -=dt;
			if(life.get(p).amount <= 0) {
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


