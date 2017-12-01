package particles;


import luxe.Vector;

import particles.core.Particle;
import particles.core.ParticleModule;
import particles.containers.ParticleVector;
import particles.containers.ModuleList;
import particles.ParticleSystem;


class ParticleEmitter {


		/** emitter active */
	public var active:Bool = true;
		/** emitter name */
	public var name:String;
		/** offset from system position*/
	public var position:Vector;

		/** emitter modules */
	public var modules:ModuleList;
		/** emitter particles */
	public var particles:ParticleVector;
		/** reference to system */
	public var system:ParticleSystem;

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

	public var enabled:Bool = true;

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
		duration = _options.duration != null ? _options.duration : -1;

		count = _options.count != null ? _options.count : 1;
		count_max = _options.count_max != null ? _options.count_max : 0;

		rate = _options.rate != null ? _options.rate : 10;
		rate_max = _options.rate_max != null ? _options.rate_max : 0;

		random = _options.random != null ? _options.random : Math.random;

		cache_wrap = _options.cache_wrap != null ? _options.cache_wrap : false;
		var cache_size:Int = _options.cache_size != null ? _options.cache_size : 128;
		if(cache_size <= 0) {
			cache_size = 1;
		}

		particles = new ParticleVector(cache_size);

		if(_options.modules != null) {
			for (m in _options.modules) {
				add_module(m);
			}
		}

	}

	public function add_module(_module:ParticleModule, _priority:Int = 0) {

		var _module_class = Type.getClass(_module);
		if(modules.exists(_module_class)) {
			throw('particle module already exists');
		}

		_module.priority = _priority;

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

	public function destroy() {
		
		for (m in modules) {
			m.destroy();
		}

		name = null;
		particles = null;
		modules = null;
		system = null;

	}

	public function update(dt:Float) {

		if(active) {

			if(enabled) {
					
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
			
			for (m in modules) {
				if(m.enabled) {
					m.update(dt);
				}
			}

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

	public function emit() {

		_emit();

	}
	
	public function start() {

		enabled = true;
		time = 0;
		frame_time = 0;

	}

	public function stop(_unspawn:Bool = false) {

		enabled = false;
		time = 0;
		frame_time = 0;

		if(_unspawn) {
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

		for (m in modules) {
			m._init(this);
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
	@:optional var cache_wrap : Bool;
	@:optional var cache_size : Int;
	@:optional var count : Int;
	@:optional var count_max : Int;
	@:optional var rate : Float;
	@:optional var rate_max : Float;
	@:optional var duration : Float;
	@:optional var modules : Array<ParticleModule>;
	@:optional var random : Void -> Float;

}


