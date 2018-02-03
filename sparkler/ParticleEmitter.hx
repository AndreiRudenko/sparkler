package sparkler;


import luxe.Vector;
import luxe.Sprite;
import phoenix.Texture;
import phoenix.Batcher;

import sparkler.core.ComponentManager;
import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;
import sparkler.containers.ParticleVector;
import sparkler.containers.ModuleList;
import sparkler.ParticleSystem;
import sparkler.utils.ModuleTools;

class ParticleEmitter {


		/** if the emitter is active, it will update */
	public var active:Bool;
		/** if the emitter is enabled, it's spawn and update modules */
	public var enabled      (default, null):Bool = false;
		/** emitter name */
	public var name:String;
		/** offset from system position */
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
	public var duration    	(default, set):Float;
		/** emitter duration max*/
	public var duration_max	(default, set):Float;
		/** emitter cache size */
	public var cache_size   (default, set):Int;
		/** emitter cache wrap */
	public var cache_wrap:Bool;

		/** emitter random function */
	public var random : Void -> Float;

		/** emitter particles image path */
	public var image_path:String;
		/** emitter particles depth */
	public var depth (default, set):Float;

	@:noCompletion public var particles_data:Array<ParticleData>;

	var batcher:Batcher;


	var time:Float;
	var frame_time:Float;
	var inv_rate:Float;
	var inv_rate_max:Float;
	var _duration:Float;
	var _need_reset:Bool = true;


	public function new(_options:ParticleEmitterOptions) {

		name = _options.name != null ? _options.name : 'emitter.${Luxe.utils.uniqueid()}';

		position = new Vector();
		modules = new ModuleList();

		time = 0;
		frame_time = 0;

		cache_size = _options.cache_size != null ? _options.cache_size : 128;
		if(cache_size <= 0) {
			cache_size = 1;
		}

		particles = new ParticleVector(cache_size);
		components = new ComponentManager(cache_size);
		particles_data = [];

		active = _options.active != null ? _options.active : true;
		// enabled = _options.enabled != null ? _options.enabled : true;

		duration = _options.duration != null ? _options.duration : -1;
		duration_max = _options.duration_max != null ? _options.duration_max : -1;

		count = _options.count != null ? _options.count : 1;
		count_max = _options.count_max != null ? _options.count_max : 0;

		rate = _options.rate != null ? _options.rate : 10;
		rate_max = _options.rate_max != null ? _options.rate_max : 0;

		random = _options.random != null ? _options.random : Math.random;

		image_path = _options.image_path;
		batcher = _options.batcher != null ? _options.batcher : Luxe.renderer.batcher;
		depth = _options.depth != null ? _options.depth : 100;

		cache_wrap = _options.cache_wrap != null ? _options.cache_wrap : false;

		if(_options.modules != null) {
			for (m in _options.modules) {
				add_module(m);
			}
		}

		// create modules from data
		if(_options.modules_data != null) {
			var _classname:String;
			for (md in _options.modules_data) {
				_classname = md.name;
				var m = ModuleTools.create_from_string(_classname);
				if(m != null) {
					add_module(m.from_json(md));
				}
			}
		}

	}

	public function destroy() {
		
		for (m in modules) {
			m.ondestroy();
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

	public function reset() {

		for (m in modules) {
			m.onreset();
		}

	}

	public function add_module(_module:ParticleModule) {

		var _module_class = Type.getClass(_module);
		if(modules.exists(_module_class)) {
			throw('particle module already exists');
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

	public function remove_module<T:ParticleModule>(_module_class:Class<T>):T {

		var _module:T = null;
		var _name:String = Type.getClassName(_module_class);
		for (m in modules) {
			if(m.name == _name) {
				_module = cast m;
				_module._onremoved();
				modules.remove(_module);
				break;
			}
		}

		if(_module != null && _need_reset) {
			reset_modules();
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

				if(_duration >= 0 && time >= _duration) {
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
		calc_duration();

	}

	public function stop(_kill:Bool = false) {

		enabled = false;
		time = 0;
		frame_time = 0;

		if(_kill) {
			for (p in particles) {
				for (m in modules) {
					m.onunspawn(p);
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
					m.onspawn(p);
				}
			}
		} else if(cache_wrap) {

			var p:Particle = particles.wrap();
			for (m in modules) {
				if(m.enabled) {
					m.onunspawn(p);
				}
			}
			for (m in modules) {
				if(m.enabled) {
					m.onspawn(p);
				}
			}

		}

	}

	public function unspawn(p:Particle) {

		particles.remove(p);
		
		for (m in modules) {
			if(m.enabled) {
				m.onunspawn(p);
			}
		}
		
	}

	@:allow(sparkler.core.ParticleModule)
	inline function add_to_bacher(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		var geom = pd.sprite.geometry;
		if(geom != null && !geom.added) {
			batcher.add(geom);
		}

		return pd;

	}

	@:allow(sparkler.core.ParticleModule)
	inline function remove_from_bacher(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		var geom = pd.sprite.geometry;
		if(geom != null && geom.added) {
			batcher.remove(geom);
		}

		return pd;

	}

	@:allow(sparkler.core.ParticleModule)
	inline function random_1_to_1(){ 

		return random() * 2 - 1; 

	}

	@:allow(sparkler.core.ParticleModule)
	inline function random_int( min:Float, ?max:Null<Float>=null ) : Int {

		return Math.floor( random_float(min, max) );

	}

	@:allow(sparkler.core.ParticleModule)
	inline function random_float( min:Float, ?max:Null<Float>=null ) : Float {

		if(max == null) { 
			max = min; 
			min = 0; 
		}

		return random() * ( max - min ) + min;
		
	}

	@:allow(sparkler.ParticleSystem)
	function init(_ps:ParticleSystem) {

		system = _ps;

		var tex = Luxe.resources.texture(image_path);
		var pd:ParticleData;
		for (i in 0...particles.capacity) {
			pd = new ParticleData();

			pd.sprite = new Sprite({
				name: '_particle_'+i,
				depth: depth,
				texture: tex,
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

	inline function calc_duration() {

		if(duration >= 0 && duration_max > duration) {
			_duration = random_float(duration, duration_max);
		} else {
			_duration = duration;
		}
		
	}

	function reset_modules() {

		for (m in modules) {
			m._onremoved();
		}

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

	function set_depth(value:Float):Float {

		if(depth != value) {
			for (pd in particles_data) {
				pd.sprite.depth = value;
			}
		}

		return depth = value;

	}

	function set_duration(value:Float):Float {

		duration = value;
		
		calc_duration();

		return duration;

	}

	function set_duration_max(value:Float):Float {

		duration_max = value;

		calc_duration();

		return duration_max;

	}

	function set_cache_size(value:Int):Int {
		
		if(cache_size != value) {
			cache_size = value;
			if(modules.length > 0) {

				_need_reset = false;
				for (m in modules) {
					m._onremoved();
				}
				_need_reset = true;

				for (pd in particles_data) {
					pd.sprite.destroy();
				}
				particles_data.splice(0, particles_data.length);

				particles = new ParticleVector(cache_size);
				components = new ComponentManager(cache_size);

				init(system);

			} else {
				particles = new ParticleVector(cache_size);
				components = new ComponentManager(cache_size);
			}
		}

		return cache_size;

	}

	@:access(sparkler.core.ComponentManager)
	@:noCompletion public function to_json():ParticleEmitterOptions {

		var _modules:Array<Dynamic> = [];
		for (m in modules) {
			_modules.push(m.to_json());
		}

		return { 
			name : name, 
			active : active, 
			// enabled : enabled, 
			cache_wrap : cache_wrap, 
			cache_size : particles.capacity, 
			count : count, 
			count_max : count_max, 
			rate : rate, 
			rate_max : rate_max, 
			duration : duration, 
			duration_max : duration_max, 
			image_path : image_path, 
			depth : depth, 
			modules_data : _modules
		};
	    
	}

}

typedef ParticleEmitterOptions = {

	@:optional var name : String;
	@:optional var active : Bool;
	// @:optional var enabled : Bool;
	@:optional var cache_wrap : Bool;
	@:optional var cache_size : Int;
	@:optional var count : Int;
	@:optional var count_max : Int;
	@:optional var rate : Float;
	@:optional var rate_max : Float;
	@:optional var duration : Float;
	@:optional var duration_max : Float;
	@:optional var batcher : Batcher;
	@:optional var image_path : String;
	@:optional var depth : Float;
	@:optional var modules : Array<ParticleModule>;
	@:optional var modules_data : Array<Dynamic>; // used for json import
	@:optional var random : Void -> Float;

}

