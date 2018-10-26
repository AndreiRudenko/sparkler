package sparkler;


import sparkler.render.Renderer;

import sparkler.ParticleEmitter;
import sparkler.core.ParticleModule;
import sparkler.core.ParticleData;
import sparkler.core.Particle;
import sparkler.data.Vector;

@:access(sparkler.ParticleEmitter)
class ParticleSystem {


	public static var renderer:Renderer;


		/** if the system is active, it will update */
	public var active:Bool;
		/** whether or not this system has been inited yet */
	public var inited  (default, null):Bool = false;
		/** whether or not this system is enabled */
	public var enabled (get, never):Bool;
		/** whether or not this system is paused */
	public var paused  (default, null):Bool = false;
		/** the system position */
	public var pos(default, null):Vector;
		/** the system emitters */
	public var emitters(default, null):Array<ParticleEmitter>;

		/** the system z-ordering depth, used in some renderers */
	public var depth(default, set):Float;
		/** the system layer, used in some renderers */
	public var layer(default, set):Int;
	
		/** the system active emitters */
	var active_emitters:Int = 0;


	public function new(?options:ParticleSystemOptions) {

		active = true;
		pos = new Vector();
		emitters = [];

		depth = 0;
		layer = 0;

		if(options != null) {

			if(options.active != null) {
				active = options.active;
			}

			if(options.pos != null) {
				pos = options.pos;
			}

			if(options.emitters != null) {
				emitters = options.emitters;
			}

			if(options.depth != null) {
				depth = options.depth;
			}

			if(options.layer != null) {
				layer = options.layer;
			}
			
		}

		_init();

	}

		/** add emitter to the system */
	public function add(_emitter:ParticleEmitter):ParticleSystem {

		emitters.push(_emitter);

		_emitter.index = active_emitters;

		if(inited) {
			_emitter.init(this);
		}

		active_emitters++;

		return this;

	}

		/** remove a emitter from the system */
	public function remove(_emitter:ParticleEmitter) {
		
		var i:Int = 0;
		while(active_emitters > i) {
			if(emitters[i] == _emitter) {
				emitters.splice(i, 1);
				active_emitters--;
			}
			emitters[i].index = i;
			i++;
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

		pos = null;
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

	#if kha

	public function render(canvas:kha.Canvas) {

		if(active) {
			for (e in emitters) {
				e.renderer.render(canvas);
			}
		}
		
	}

	#end

	function _init() {

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

	function set_depth(v:Float):Float {

		depth = v;
		
		for (e in emitters) {
			e.renderer.ondepth(depth);
		}

		return v;

	}

	function set_layer(v:Int):Int {

		layer = v;
		
		for (e in emitters) {
			e.renderer.onlayer(layer);
		}

		return v;

	}


}


typedef ParticleSystemOptions = {

	@:optional var active:Bool;
	@:optional var pos:Vector;

	@:optional var emitters:Array<ParticleEmitter>;

	@:optional var depth:Float;
	@:optional var layer:Int;

}


