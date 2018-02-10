package sparkler;

import sparkler.ParticleEmitter;

import luxe.Vector;


class ParticleSystem {


		/** if the system is active, it will update */
	public var active:Bool = true;
		/** whether or not this system has been inited yet */
	public var inited  (default, null):Bool = false;
		/** whether or not this system is enabled */
	public var enabled (get, never):Bool;
		/** whether or not this system is paused */
	public var paused  (default, null):Bool = false;
		/** the system position */
	public var position(default, null):Vector;
		/** the system emitters */
	public var emitters(default, null):Array<ParticleEmitter>;
	
		/** the system active emitters */
	var active_emitters:Int = 0;


	public function new(?_emitters:Array<ParticleEmitter>) {

		position = new Vector();

		emitters = [];

		if(_emitters != null) {
			for (e in _emitters) {
				emitters.push(e);
			}
		}

		init();

	}

		/** add emitter to the system */
	public function add(_emitter:ParticleEmitter):ParticleSystem {

		emitters.push(_emitter);

		if(inited) {
			_emitter.init(this);
		}

		active_emitters++;

		return this;

	}

		/** remove a emitter from the system */
	public function remove(_emitter:ParticleEmitter) {
		
		var ret:ParticleEmitter = null;
		for (i in 0...emitters.length) {
			if(emitters[i] == _emitter) {
				emitters.splice(i, 1);
				active_emitters--;
				break;
			}
		}

	}

		/** emit particles */
	public function emit() {

		for (i in 0...active_emitters) {
			emitters[i].emit();
		}
		
	}

		/** start update emitters */
	public function start() {
		
		for (i in 0...active_emitters) {
			emitters[i].start();
		}

	}

		/** stop update emitters */
	public function stop(_kill:Bool = false) {
		
		for (i in 0...active_emitters) {
			emitters[i].stop(_kill);
		}

	}

		/** pause update emitters */
	public function pause() {

		active = false;
		
	}

		/** unpause update emitters */
	public function unpause() {

		active = true;

	}

		/** destroy all emitters in this system. */
	public function empty() {

		for (e in emitters) {
			e.destroy();
		}

		emitters.splice(0, emitters.length);
		active_emitters = 0;
		
	}

		/** destroy the system */
	public function destroy() {

		empty();

		position = null;
		emitters = null;

	}

		/** update the system */
	public function update(dt:Float) {

		if(active) {
			for (e in emitters) {
				e.update(dt);
			}
		}
		
	}

	function init() {

		for (e in emitters) {
			e.init(this);
		}

		inited = true;
		
	}

	function get_enabled():Bool {

		for (e in emitters) {
			if(e.enabled) {
				return true;
			}
		}
		
		return false;

	}
	

}

