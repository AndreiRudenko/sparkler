package sparkler.modules;

import sparkler.core.Particle;
import sparkler.core.ParticleModule;
import sparkler.core.Components;
import sparkler.components.Life;


class LifeTimeModule extends ParticleModule {


	public var lifetime:Float;
	public var lifetime_max:Float;

	var life:Components<Life>;


	public function new(_options:LifeTimeModuleOptions) {

		super(_options);

		lifetime = _options.lifetime != null ? _options.lifetime : 2;
		lifetime_max = _options.lifetime_max != null ? _options.lifetime_max : 0;

	}

	override function onspawn(p:Particle) {

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

	override function onremoved() {

		emitter.components.remove(Life);
		life = null;
		
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


// import/export

	override function from_json(d:Dynamic) {

		super.from_json(d);

		lifetime = d.lifetime;
		lifetime_max = d.lifetime_max;
		
		return this;
	    
	}

	override function to_json():Dynamic {

		var d = super.to_json();

		d.lifetime = lifetime;
		d.lifetime_max = lifetime_max;

		return d;
	    
	}


}



typedef LifeTimeModuleOptions = {

	>ParticleModuleOptions,
	@:optional var lifetime : Float;
	@:optional var lifetime_max : Float;

}


