package particles;

import particles.ParticleEmitter;

import luxe.Vector;


class ParticleSystem {


	public var inited  (default, null):Bool = false;
	public var enabled (default, null):Bool = false;
	public var paused  (default, null):Bool = false;
	public var position(default, null):Vector;

	public var emitters:Array<ParticleEmitter>;

	public var random : Void -> Float;

	var active_emitters:Int = 0;


	public function new(?_emitters:Array<ParticleEmitter>) {

		random = Math.random;

		position = new Vector();

		emitters = [];

		if(_emitters != null) {
			for (e in _emitters) {
				emitters.push(e);
			}
		}

		init();

	}

	public function add(_emitter:ParticleEmitter):ParticleSystem {

		emitters.push(_emitter);

		if(inited) {
			_emitter.init(this);
		}

		active_emitters++;

		return this;

	}

	public function remove(_name:String):ParticleEmitter {
		
		var ret:ParticleEmitter = null;
		for (i in 0...emitters.length) {
			if(emitters[i].name == _name) {
				ret = emitters[i];
				emitters.splice(i, 1);
				active_emitters--;
				break;
			}
		}

		return ret;

	}

	public function start() {
		
		for (i in 0...active_emitters) {
			emitters[i].start();
		}

	}

	public function emit() {

		for (i in 0...active_emitters) {
			emitters[i].emit();
		}
		
	}

	public function stop() {
		
		for (i in 0...active_emitters) {
			emitters[i].stop();
		}

	}

	public function pause() {

		if(!paused) {
			for (i in 0...active_emitters) {
				emitters[i].pause();
			}
			paused = true;
		}
		
	}

	public function unpause() {

		if(paused) {
			for (i in 0...active_emitters) {
				emitters[i].unpause();
			}	
			paused = false;	
		}

	}

	public function empty() {

		emitters.splice(0, emitters.length);
		active_emitters = 0;
		
	}

	public function update(dt:Float) {

		for (e in emitters) {
			e.update(dt);
		}
		
	}

	function init() {

		for (e in emitters) {
			e.init(this);
		}

		inited = true;
		
	}
	

}

