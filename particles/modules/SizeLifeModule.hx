package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.core.ParticleData;
import particles.core.Components;
import particles.components.Life;

import luxe.Vector;


class SizeLifeModule extends ParticleModule {


	public var initial_size	(default, null):Vector;
	public var end_size    	(default, null):Vector;
	public var initial_size_max:Vector;
	public var end_size_max:Vector;

	var size_delta:Array<Vector>;
	var particles_data:Array<ParticleData>;
	var life:Components<Life>;


	public function new(_options:SizeModuleOptions) {

		super();

		size_delta = [];

		initial_size = _options.initial_size != null ? _options.initial_size : new Vector(32, 32);
		initial_size_max = _options.initial_size_max;
		end_size = _options.end_size != null ? _options.end_size : new Vector(32, 32);
		end_size_max = _options.end_size_max;

	}

	override function init() {

		particles_data = emitter.particles_data;

		life = emitter.components.get(Life);
		if(life == null) {
			throw('LifeTimeModule is required for ScaleModule');
		}

		for (i in 0...particles.capacity) {
			size_delta[i] = new Vector();
		}
	    
	}

	override function spawn(p:Particle) {

		var szd:Vector = size_delta[p.id];
		var pd:ParticleData = particles_data[p.id];
		var lf:Float = life.get(p).amount;

		if(initial_size_max != null) {
			pd.w = emitter.random_float(initial_size.x, initial_size_max.x);
			pd.h = emitter.random_float(initial_size.y, initial_size_max.y);
		} else {
			pd.w = initial_size.x;
			pd.h = initial_size.y;
		}
		
		if(end_size_max != null) {
			szd.x = emitter.random_float(end_size.x, end_size_max.x) - pd.w;
			szd.y = emitter.random_float(end_size.y, end_size_max.y) - pd.h;
		} else {
			szd.x = end_size.x - pd.w;
			szd.y = end_size.y - pd.h;
		}

		if(szd.x != 0) {
			szd.x /= lf;
		}

		if(szd.y != 0) {
			szd.y /= lf;
		}

	}

	override function update(dt:Float) {

		var szd:Vector;
		var pd:ParticleData;
		for (p in particles) {
			szd = size_delta[p.id];
			pd = particles_data[p.id];
			pd.w += szd.x * dt;
			pd.h += szd.y * dt;
		}

	}

}


typedef SizeModuleOptions = {
	
	@:optional var initial_size : Vector;
	@:optional var initial_size_max : Vector;
	@:optional var end_size : Vector;
	@:optional var end_size_max : Vector;

}


