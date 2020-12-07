package sparkler;

import sparkler.Particle;
import sparkler.ParticleEmitter.IParticleEmitter;
import sparkler.utils.Color;

#if !macro
@:autoBuild(sparkler.utils.macro.ParticleModuleMacro.build())
#end

class ParticleModule<T:ParticleBase> implements IParticleEmitter<T> {

	public var cacheSize(default, null):Int;
	public var activeCount(default, null):Int;
	public var progress(default, null):Float;
	public var loops:Int;
	public var localSpace:Bool;
	public var enabled:Bool;
	public var particles:haxe.ds.Vector<T>;
	public var random:()->Float;
	public var sortFunc:(a:T, b:T)->Int;

	var _x:Float;
	var _y:Float;
	var _lastX:Float;
	var _lastY:Float;
	var _frameTime:Float;
	var _loopsCounter:Int;

	var _a:Float;
	var _b:Float;
	var _c:Float;
	var _d:Float;
	var _tx:Float;
	var _ty:Float;

	public function emit() {}
	public function start() {}
	public function stop() {}

	function setParticlePos(p:T, x:Float, y:Float) {}
	function updateParticles(elapsed:Float) {}
	function getSorted():haxe.ds.Vector<T> return null;
	function step(elapsed:Float) {}
	function restart() {}
	function spawn() {}
	function unspawn(p:T) {}

	function onStart() {}
	function onStop() {}

	function onUpdate(elapsed:Float) {}
	function onStepStart(elapsed:Float) {}
	function onStep(elapsed:Float) {}
	function onStepEnd(elapsed:Float) {}

	function onParticleUpdate(p:T, elapsed:Float) {}
	function onParticleSpawn(p:T) {}
	function onParticleUnspawn(p:T) {}

	function getRotateX(x:Float, y:Float) return 0.0;
	function getRotateY(x:Float, y:Float) return 0.0;

	function getTransformX(x:Float, y:Float) return 0.0;
	function getTransformY(x:Float, y:Float) return 0.0;

	function random1To1() return 0;
	function randomInt(min:Float, ?max:Null<Float>) return 0;
	function randomFloat(min:Float, ?max:Null<Float>) return 0;

	// additional
	function onPreStepStart(elapsed:Float) {}
	function onPostStepStart(elapsed:Float) {}

	function onPreStep(elapsed:Float) {}
	function onPostStep(elapsed:Float) {}

	function onPreStepEnd(elapsed:Float) {}
	function onPostStepEnd(elapsed:Float) {}

	function onPreStart() {}
	function onPostStart() {}
	
	function onPreStop() {}
	function onPostStop() {}

	function onPreParticleUpdate(p:T, elapsed:Float) {}
	function onPostParticleUpdate(p:T, elapsed:Float) {}

	function onPreParticleSpawn(p:T) {}
	function onPostParticleSpawn(p:T) {}

	function onPreParticleUnspawn(p:T) {}
	function onPostParticleUnspawn(p:T) {}

}

#if !macro
@:autoBuild(sparkler.utils.macro.ParticleInjectModuleMacro.build())
#end
class ParticleInjectModule {}
