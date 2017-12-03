package particles;


import luxe.Vector;
import luxe.Sprite;
import phoenix.Texture;
import phoenix.Batcher;

import particles.core.ComponentManager;
import particles.core.Particle;
import particles.core.ParticleData;
import particles.core.ParticleModule;
import particles.containers.ParticleVector;
import particles.containers.ModuleList;
import particles.ParticleSystem;


class ParticleEmitter {


		/** emitter active */
	public var active:Bool;
		/** emitter name */
	public var name         (default, null):String;
		/** offset from system position*/
	public var position     (default, null):Vector;

		/** emitter particles */
	public var particles 	(default, null):ParticleVector;
		/** particles components */
	public var components	(default, null):ComponentManager;
		/** emitter modules */
	public var modules   	(default, null):ModuleList;
		/** reference to system */
	public var system    	(default, null):ParticleSystem;

		/** number of particles per emit */
	public var count:Int;
		/** number of particles per emit max */
	public var count_max:Int;

		/** emitter rate, particles per sec */
	public var rate    	(default, set):Float;
		/** emitter rate, max particles per sec */
	public var rate_max	(default, set):Float;

		/** emitter duration */
	public var duration:Float;
		/** emitter cache wrap */
	public var cache_wrap:Bool;

		/** emitter random function */
	public var random : Void -> Float;

	public var enabled:Bool;

	var image:Texture;
	var batcher:Batcher;
	var depth:Float;

	// @:allow(particles.core.ParticleModule)
	@:noCompletion public var particles_data:Array<ParticleData>;

	var time:Float;
	var frame_time:Float;
	var inv_rate:Float;
	var inv_rate_max:Float;


	public function new(_options:ParticleEmitterOptions) {

		name = _options.name;

		position = new Vector();
		modules = new ModuleList();

		time = 0;
		frame_time = 0;

		active = _options.active != null ? _options.active : true;
		enabled = _options.enabled != null ? _options.enabled : true;

		duration = _options.duration != null ? _options.duration : -1;

		count = _options.count != null ? _options.count : 1;
		count_max = _options.count_max != null ? _options.count_max : 0;

		rate = _options.rate != null ? _options.rate : 10;
		rate_max = _options.rate_max != null ? _options.rate_max : 0;

		random = _options.random != null ? _options.random : Math.random;

		image = _options.image;
		batcher = _options.batcher != null ? _options.batcher : Luxe.renderer.batcher;
		depth = _options.depth != null ? _options.depth : 300;

		cache_wrap = _options.cache_wrap != null ? _options.cache_wrap : false;
		var cache_size:Int = _options.cache_size != null ? _options.cache_size : 128;
		if(cache_size <= 0) {
			cache_size = 1;
		}

		particles = new ParticleVector(cache_size);
		components = new ComponentManager(cache_size);
		particles_data = [];

		if(_options.modules != null) {
			for (m in _options.modules) {
				add_module(m);
			}
		}

	}

	public function destroy() {
		
		for (m in modules) {
			m.destroy();
		}

		for (p in particles_data) {
			p.sprite.destroy();
		}

		components.clear();

		name = null;
		particles = null;
		particles_data = null;
		components = null;
		modules = null;
		system = null;

	}

	public function add_module(_module:ParticleModule, _priority:Int = 0) {

		var _module_class = Type.getClass(_module);
		if(modules.exists(_module_class)) {
			throw('particle module already exists');
		}

		if(!_module.override_priority) {
			_module.priority = _priority;
		}

		modules.add(_module);

		if(system != null && system.inited) {
			_module._init(this);
		}

	}

	public function get_module<T:ParticleModule>(_module_class:Class<T>):T {

		var _module:T = null;
		var _name:String = Type.getClassName(_module_class);
		for (m in modules) {
			if(m.name == _name) {
				_module = cast m;
				break;
			}
		}

		return _module;
		
	}

	public function update(dt:Float) {

		if(active) {

			if(enabled && rate > 0) {
					
				frame_time += dt;

				var _inv_rate:Float;

				while(frame_time > 0) {

					_emit();

					if(rate_max > 0) {
						_inv_rate = random_float(inv_rate, inv_rate_max);
					} else {
						_inv_rate = inv_rate;
					}

					if(_inv_rate == 0) {
						frame_time = 0;
						break;
					}

					frame_time -= _inv_rate;

				}

				time += dt;

				if(duration >= 0 && time >= duration) {
					stop();
				}

			}
			
			// update modules
			for (m in modules) {
				if(m.enabled) {
					m.update(dt);
				}
			}

			// update sprites
			for (p in particles) {
				particles_data[p.id].sync_transform();
			}

		}
		
	}

	public function emit() {

		_emit();

	}
	
	public function start() {

		enabled = true;
		time = 0;
		frame_time = 0;

	}

	public function stop(_kill:Bool = false) {

		enabled = false;
		time = 0;
		frame_time = 0;

		if(_kill) {
			for (p in particles) {
				for (m in modules) {
					m.unspawn(p);
				}
			}
			particles.reset();
		}

	}

	public function pause() {
		
		active = false;

	}

	public function unpause() {

		active = true;
		
	}

	inline function spawn() {

		if(particles.length < particles.capacity) {
			var p:Particle = particles.ensure();
			for (m in modules) {
				if(m.enabled) {
					m.spawn(p);
				}
			}
		} else if(cache_wrap) {

			var p:Particle = particles.wrap();
			for (m in modules) {
				if(m.enabled) {
					m.unspawn(p);
				}
			}
			for (m in modules) {
				if(m.enabled) {
					m.spawn(p);
				}
			}

		}

	}

	public function unspawn(p:Particle) {

		particles.remove(p);
		
		for (m in modules) {
			if(m.enabled) {
				m.unspawn(p);
			}
		}
		
	}

	@:allow(particles.core.ParticleModule)
	inline function add_to_bacher(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		if(pd.sprite.geometry != null) {
			batcher.add(pd.sprite.geometry);
		}

		return pd;

	}

	@:allow(particles.core.ParticleModule)
	inline function remove_from_bacher(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		if(pd.sprite.geometry != null) {
			batcher.remove(pd.sprite.geometry);
		}

		return pd;

	}

	@:allow(particles.core.ParticleModule)
	inline function random_1_to_1(){ 

		return random() * 2 - 1; 

	}

	@:allow(particles.core.ParticleModule)
	inline function random_int( min:Float, ?max:Null<Float>=null ) : Int {

		return Math.floor( random_float(min, max) );

	}

	@:allow(particles.core.ParticleModule)
	inline function random_float( min:Float, ?max:Null<Float>=null ) : Float {

		if(max == null) { 
			max = min; 
			min = 0; 
		}

		return random() * ( max - min ) + min;
		
	}

	@:allow(particles.ParticleSystem)
	function init(_ps:ParticleSystem) {

		system = _ps;

		var pd:ParticleData;
		for (i in 0...particles.capacity) {
			pd = new ParticleData();

			pd.sprite = new Sprite({
				name: '_particle_'+i,
				depth: depth,
				texture: image,
				no_scene: true,
				no_batcher_add: true
			});

			particles_data.push(pd);
		}

		for (m in modules) {
			m._init(this);
		}

	}

	function _emit() {

		var _count:Int;

		if(count_max > 0) {
			_count = random_int(count, count_max);
		} else {
			_count = count;
		}

		for (_ in 0..._count) {
			spawn();
		}

	}

	function set_rate(value:Float):Float {

		if(value > 0) {
			inv_rate = 1 / value;
		} else {
			value = 0;
			inv_rate = 0;
		}

		return rate = value;

	}

	function set_rate_max(value:Float):Float {

		if(value > 0) {
			inv_rate_max = 1 / value;
		} else {
			value = 0;
			inv_rate_max = 0;
		}

		return rate_max = value;

	}


}

typedef ParticleEmitterOptions = {

	var name : String;
	@:optional var active : Bool;
	@:optional var enabled : Bool;
	@:optional var cache_wrap : Bool;
	@:optional var cache_size : Int;
	@:optional var count : Int;
	@:optional var count_max : Int;
	@:optional var rate : Float;
	@:optional var rate_max : Float;
	@:optional var duration : Float;
	@:optional var batcher : Batcher;
	@:optional var image : Texture;
	@:optional var depth : Float;
	@:optional var modules : Array<ParticleModule>;
	@:optional var random : Void -> Float;

}


