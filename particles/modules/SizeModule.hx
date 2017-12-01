package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.modules.SpawnModule;

import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class SizeModule extends ParticleModule {


	public var data:Array<SizeData>;

	var spawn_data:Array<SpawnData>;
	var life_data:Array<Float>;

	var initial_size:Vector;
	var initial_size_max:Vector;
	var end_size:Vector;
	var end_size_max:Vector;



	public function new(_options:SizeModuleOptions) {

		super();

		data = [];

		initial_size = _options.initial_size != null ? _options.initial_size : new Vector(32, 32);
		initial_size_max = _options.initial_size_max;
		end_size = _options.end_size != null ? _options.end_size : new Vector(32, 32);
		end_size_max = _options.end_size_max;

	}

	override function spawn(p:Particle) {

		var szd:SizeData = data[p.id];
		var sd:SpawnData = spawn_data[p.id];
		var lf:Float = life_data[p.id];

		if(initial_size_max != null) {
			sd.w = emitter.random_float(initial_size.x, initial_size_max.x);
			sd.h = emitter.random_float(initial_size.y, initial_size_max.y);
		} else {
			sd.w = initial_size.x;
			sd.h = initial_size.y;
		}
		
		if(end_size_max != null) {
			szd.size_delta_x = emitter.random_float(end_size.x, end_size_max.x) - sd.w;
			szd.size_delta_y = emitter.random_float(end_size.y, end_size_max.y) - sd.h;
		} else {
			szd.size_delta_x = end_size.x - sd.w;
			szd.size_delta_y = end_size.y - sd.h;
		}

		if(szd.size_delta_x != 0) {
			szd.size_delta_x /= lf;
		}

		if(szd.size_delta_y != 0) {
			szd.size_delta_y /= lf;
		}

	}

	override function init() {

		var sm:SpawnModule = emitter.get_module(SpawnModule);
		if(sm == null) {
			throw('SpawnModule is required for SizeModule');
		}
		spawn_data = sm.data;

		var lm:LifeTimeModule = emitter.get_module(LifeTimeModule);
		if(lm == null) {
			throw('LifeTimeModule is required for SizeModule');
		}
		life_data = lm.life;

		for (i in 0...particles.capacity) {
			data[i] = new SizeData();
		}
	    
	}

	override function update(dt:Float) {

		var szd:SizeData;
		var sd:SpawnData;
		for (p in particles) {
			szd = data[p.id];
			sd = spawn_data[p.id];
			if(szd.size_delta_x != 0) {
				sd.w += szd.size_delta_x * dt;
			}
			if(szd.size_delta_y != 0) {
				sd.h += szd.size_delta_y * dt;
			}
		}

	}

}

class SizeData {

	public var scale_delta:Float = 0;
	public var size_delta_x:Float = 0;
	public var size_delta_y:Float = 0;

	public function new() {
		
	}

}


typedef SizeModuleOptions = {
	
	@:optional var initial_size : Vector;
	@:optional var initial_size_max : Vector;
	@:optional var end_size : Vector;
	@:optional var end_size_max : Vector;

}


