package sparkler.core;


import sparkler.core.Particle;
import sparkler.containers.ParticleVector;
import sparkler.ParticleEmitter;


class ParticleModule {


       /** if the module is enabled it will update */
	public var enabled:Bool = true;
       /** the name */
	public var name (default, null):String;
       /** the module priority */
	public var priority (default, set) : Int = 0;

        /** if the module is in a emitter, this is not null */
	var emitter:ParticleEmitter;
        /** reference to emitter particles */
	var particles:ParticleVector;

        /** linked list stuff */
	@:noCompletion public var prev : ParticleModule;
	@:noCompletion public var next : ParticleModule;


	public function new(_options:ParticleModuleOptions) {

		name = Type.getClassName(Type.getClass(this));
		
		if(_options.enabled != null) {
			enabled = _options.enabled;
		}

		if(_options.priority != null) {
			priority = _options.priority;
		}

	}

       /** called when the emitter initiated */
	public function init() {}
       /** called when the emitter starts or is reset */
	public function onreset() {}

        /** called when the module is attached to an emitter */
	public function onadded() {}
        /** called when the module is removed from an emitter */
	public function onremoved() {}

        /** called when the emitter spawn particle */
	public function onspawn(p:Particle) {}
        /** called when the emitter unspawn particle */
	public function onunspawn(p:Particle) {}

        /** called once per frame, passing the delta time */
	public function update(dt:Float) {}

        /** called when the module is destroyed */
	public function ondestroy() {}

        /** save settings to json */
	public function to_json():Dynamic {

		return {
			name : name,
			enabled : enabled,
			priority : priority
		};

	}

        /** load settings from json */
	public function from_json(d:Dynamic):ParticleModule {
		
		enabled = d.enabled;
		priority = d.priority;

		return this;

	}

	@:allow(sparkler.ParticleEmitter)
	inline function _init(_emitter:ParticleEmitter) {

		// trace('called _init on: $name');

		emitter = _emitter;
		particles = emitter.particles;
		init();
		onreset();

	}
	
	@:allow(sparkler.ParticleEmitter)
	inline function _onremoved() {

		// trace('called _onremoved on: $name');

		onremoved();
		emitter = null;
		particles = null;

	}

	function set_priority(value:Int):Int {

		priority = value;

		if(emitter != null) {
			emitter.modules.update(this);
		}

		return priority;

	}


}

typedef ParticleModuleOptions = {

	@:optional var enabled:Bool;
	@:optional var priority:Int;

}