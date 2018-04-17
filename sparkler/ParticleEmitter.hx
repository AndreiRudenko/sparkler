package sparkler;


import sparkler.core.ComponentManager;
import sparkler.core.Particle;
import sparkler.core.ParticleData;
import sparkler.core.ParticleModule;
import sparkler.containers.ParticleVector;
import sparkler.ParticleSystem;
import sparkler.data.Vector;
import sparkler.utils.ModulesFactory;


class ParticleEmitter {


	public var inited      (default, null):Bool = false;
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
	public var modules   	(default, null):Map<String, ParticleModule>;
		/** active emitter modules */
	public var active_modules   	(default, null):Array<ParticleModule>;
		/** reference to system */
	public var system    	(default, null):ParticleSystem;

		/** number of particles per emit */
	public var count:Int; // todo: if cache_size < count
		/** number of particles per emit max */
	public var count_max:Int;

		/** lifetime for particles */
	public var lifetime:Float;
		/** max lifetime for particles, if > 0, 
			particle lifetime is random between lifetime and lifetime_max */
	public var lifetime_max:Float;

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
	public var image_path(default, set):String;
		/** emitter particles depth */
	public var depth (default, set):Float;

	@:noCompletion public var particles_data:Array<ParticleData>;

	var time:Float;
	var frame_time:Float;
	var inv_rate:Float;
	var inv_rate_max:Float;
	var _duration:Float;
	var _need_reset:Bool = true;


	public function new(_options:ParticleEmitterOptions) {

		name = _options.name != null ? _options.name : 'emitter.${Luxe.utils.uniqueid()}';

		position = new Vector();
		modules = new Map();
		active_modules = [];

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
		enabled = _options.enabled != null ? _options.enabled : true;

		duration = _options.duration != null ? _options.duration : -1;
		duration_max = _options.duration_max != null ? _options.duration_max : -1;

		count = _options.count != null ? _options.count : 1;
		count_max = _options.count_max != null ? _options.count_max : 0;

		lifetime = _options.lifetime != null ? _options.lifetime : 1;
		lifetime_max = _options.lifetime_max != null ? _options.lifetime_max : 0;

		rate = _options.rate != null ? _options.rate : 10;
		rate_max = _options.rate_max != null ? _options.rate_max : 0;

		random = _options.random != null ? _options.random : Math.random;

		image_path = _options.image_path;
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
				var m = ModulesFactory.create(_classname, md);
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

		for (pd in particles_data) {
			ParticleSystem.backend.sprite_destroy(pd);
		}

		components.clear();

		name = null;
		particles = null;
		particles_data = null;
		components = null;
		modules = null;
		active_modules = null;
		system = null;

	}

	public function reset() {

		for (m in modules) {
			m.onreset();
		}

	}

	public function add_module(_module:ParticleModule):ParticleEmitter {

		var cname:String = Type.getClassName(Type.getClass(_module));

		if(modules.exists(cname)) {
			throw('particle module: $cname already exists');
		}

		modules.set(cname, _module);
		_module._onadded(this);

		if(_module.enabled) {
			_enable_m(_module);
		}

		if(inited) {
			_module._init();
		}

		return this;

	}

	public function get_module<T:ParticleModule>(_module_class:Class<T>):T {

		return cast modules.get(Type.getClassName(_module_class));
		
	}

	public function remove_module<T:ParticleModule>(_module_class:Class<T>):T {

		var cname:String = Type.getClassName(_module_class);

		var _module:T = cast modules.get(cname);

		if(_module != null) {
			if(_module.enabled) {
				_disable_m(_module);
			}

			modules.remove(cname);
			_module._onremoved();

			if(_need_reset) {
				reset_modules();
			}
		}

		return _module;
		
	}

	public function enable_module(_module_class:Class<Dynamic>) {
		
		var cname:String = Type.getClassName(_module_class);
		var m = modules.get(cname);
		if(m == null) {
			throw('module: $cname doesnt exists');
		}

		if(!m.enabled) {
			_enable_m(m);
		}

	}

	public function disable_module(_module_class:Class<Dynamic>) {
		
		var cname:String = Type.getClassName(_module_class);
		var m = modules.get(cname);
		if(m == null) {
			throw('module: $cname doesnt exists');
		}

		if(m.enabled) {
			_disable_m(m);
		}

	}

	public function update(dt:Float) {

		if(active) {

			// check lifetime
			var p:Particle;
			var pd:ParticleData;
			var i:Int = 0;
			var len:Int = particles.length;
			while(i < len) {
				p = particles.get(i);
				pd = particles_data[p.id];
				pd.lifetime -=dt;
				if(pd.lifetime <= 0) {
					unspawn(p);
					len = particles.length;
				} else {
					i++;
				}
			}

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
			for (m in active_modules) {
				m.update(dt);
			}

			// update particle changes to sprite 
			for (p in particles) {
				ParticleSystem.backend.sprite_update(particles_data[p.id]);
			}

		}
		
	}

	public function emit() {

		_emit();

	}
	
	public function start(?_dur:Float) {

		enabled = true;
		time = 0;
		frame_time = 0;

		if(_dur == null) {
			calc_duration();
		} else {
			_duration = _dur;
		}

	}

	public function stop(_kill:Bool = false) {

		enabled = false;
		time = 0;
		frame_time = 0;

		if(_kill) {
			unspawn_all();
		}

	}

	public function unspawn_all() {
		
		for (p in particles) {
			for (m in modules) {
				m.onunspawn(p);
			}
		}
		particles.reset();

	}

	public function pause() {
		
		active = false;

	}

	public function unpause() {

		active = true;
		
	}

	inline function _enable_m(m:ParticleModule) {
		
		var added:Bool = false;
		var am:ParticleModule = null;
		for (i in 0...active_modules.length) {
			am = active_modules[i];
			if (m.priority <= am.priority) {
				active_modules.insert(i,m);
				added = true;
				break;
			}
		}
		
		if(!added) {
			active_modules.push(m);
		}

		m.onenabled();

	}

	inline function _disable_m(m:ParticleModule) {

		m.ondisabled();
		active_modules.remove(m);
		
	}

	inline function _sort_active() {

		haxe.ds.ArraySort.sort(
			active_modules,
			function(a,b) {
				if (a.priority < b.priority) {
					return -1;
				} else if (a.priority > b.priority) {
					return 1;
				}
				return 0;
			}
		);
		
	}

	inline function spawn() {

		if(particles.length < particles.capacity) {
			_spawn_particle(particles.ensure());
		} else if(cache_wrap) {
			var p:Particle = particles.wrap();
			_unspawn_particle(p);
			_spawn_particle(p);
		}

	}

	public function unspawn(p:Particle) {

		particles.remove(p);
		_unspawn_particle(p);
		
	}

	inline function _spawn_particle(p:Particle) {

		for (m in active_modules) {
			if(lifetime_max > 0) {
				particles_data[p.id].lifetime = random_float(lifetime, lifetime_max);
			} else {
				particles_data[p.id].lifetime = lifetime;
			}
			m.onspawn(p);
		}
		
	}

	inline function _unspawn_particle(p:Particle) {
		
		for (m in active_modules) {
			m.onunspawn(p);
		}

	}

	@:allow(sparkler.core.ParticleModule)
	inline function show_particle(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		ParticleSystem.backend.sprite_show(pd);

		return pd;

	}

	@:allow(sparkler.core.ParticleModule)
	inline function hide_particle(p:Particle):ParticleData { 

		var pd:ParticleData = particles_data[p.id];
		ParticleSystem.backend.sprite_hide(pd);

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

		var pd:ParticleData;
		for (i in 0...particles.capacity) {
			pd = ParticleSystem.backend.sprite_create(new Particle(i));
			ParticleSystem.backend.sprite_set_depth(pd,depth);
			ParticleSystem.backend.sprite_set_texture(pd,image_path);
			particles_data.push(pd);
		}

		for (m in modules) {
			m._init();
		}

		inited = true;

	}

	function _emit() {

		var _count:Int;

		if(count_max > 0) {
			_count = random_int(count, count_max);
		} else {
			_count = count;
		}

		_count = _count > cache_size ? cache_size : _count;

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

		_need_reset = false;

		for (m in active_modules) {
			m.ondisabled();
		}

		for (m in modules) {
			m._onremoved();
		}

		for (m in modules) {
			m._onadded(this);
		}

		for (m in active_modules) {
			m.onenabled();
		}

		for (m in modules) {
			m._init();
		}
		
		_need_reset = true;

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
				ParticleSystem.backend.sprite_set_depth(pd,value);
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

	function set_image_path(value:String):String {

		image_path = value;

		if(inited) {
			for (pd in particles_data) {
				ParticleSystem.backend.sprite_set_texture(pd, image_path);
			}
		}

		return image_path;

	}

	function set_cache_size(value:Int):Int {
		
		if(cache_size != value) {
			cache_size = value;
			if(Lambda.count(modules) > 0) {

				_need_reset = false;
				for (m in modules) {
					m._onremoved();
				}
				_need_reset = true;

				for (pd in particles_data) {
					ParticleSystem.backend.sprite_destroy(pd);
				}
				particles_data.splice(0, particles_data.length);

				particles = new ParticleVector(cache_size);
				components = new ComponentManager(cache_size);

				for (m in modules) {
					m._onadded(this);
				}

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
			enabled : enabled, 
			cache_wrap : cache_wrap, 
			cache_size : particles.capacity, 
			count : count, 
			count_max : count_max, 
			lifetime : lifetime, 
			lifetime_max : lifetime_max, 
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
	@:optional var enabled : Bool;
	@:optional var cache_wrap : Bool;
	@:optional var cache_size : Int;
	@:optional var count : Int;
	@:optional var count_max : Int;
	@:optional var lifetime : Float;
	@:optional var lifetime_max : Float;
	@:optional var rate : Float;
	@:optional var rate_max : Float;
	@:optional var duration : Float;
	@:optional var duration_max : Float;
	@:optional var image_path : String;
	@:optional var depth : Float;
	@:optional var modules : Array<ParticleModule>;
	@:optional var modules_data : Array<Dynamic>; // used for json import
	@:optional var random : Void -> Float;

}

