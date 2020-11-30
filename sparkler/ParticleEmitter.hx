package sparkler;

import sparkler.utils.Color;
import sparkler.Particle;

#if !macro
@:genericBuild(sparkler.utils.macro.ParticleEmitterMacro.build())
#end

class ParticleEmitter<Rest> {}

class ParticleEmitterBase<T:ParticleBase> implements IParticleEmitter<T>{

	public var x(get, set):Float;
	var _x:Float = 0;
	inline function get_x() return _x;
	function set_x(v:Float):Float {
		_lastX = _x;
		return _x = v;
	}

	public var y(get, set):Float;
	var _y:Float = 0;
	inline function get_y() return _y;
	function set_y(v:Float):Float {
		_lastY = _y;
		return _y = v;
	}

	var _lastX:Float = 0;
	var _lastY:Float = 0;

	public var rotation:Float = 0;

	public var scaleX:Float = 1;
	public var scaleY:Float = 1;

	public var originX:Float = 0;
	public var originY:Float = 0;

	// emitter name 
	public var name:String;
	// if the emitter is active, it will update
	public var active:Bool = true;
	// if the emitter is enabled, it's spawn and update modules
	public var enabled:Bool = false;

	public var cacheSize(default, null):Int = 512;
	public var progress(default, null):Float = 0;
	public var cacheWrap:Bool = false;
	public var localSpace:Bool = false;
	public var preprocess:Float = 0;
	public var loops:Int = 0;

	public var activeCount(default, null):Int = 0;
	public var particles:haxe.ds.Vector<T>;

	public var random:()->Float;
	public var sortFunc:(a:T, b:T)->Int;

	var _loopsCounter:Int = 0;
	var _wrapIdx:Int = 0;
	var _frameTime:Float = 0;

	// matrix
	var _a:Float = 0;
	var _b:Float = 0;
	var _c:Float = 0;
	var _d:Float = 0;
	var _tx:Float = 0;
	var _ty:Float = 0;

	var _sin:Float = 0;
	var _cos:Float = 0;

	// for sorting
	var _particlesSorted:haxe.ds.Vector<T>;
	var _particlesSortTmp:haxe.ds.Vector<T>;

	public function new(options:ParticleEmitterOptions) {
		if(options.x != null) _x = options.x;
		if(options.y != null) _y = options.y;

		_lastX = _x;
		_lastY = _y;

		if(options.active != null) active = options.active;
		if(options.enabled != null) enabled = options.enabled;
		if(options.cacheSize != null) cacheSize = options.cacheSize;
		if(options.cacheWrap != null) cacheWrap = options.cacheWrap;
		if(options.localSpace != null) localSpace = options.localSpace;
		if(options.preprocess != null) preprocess = options.preprocess;
		if(options.loops != null) loops = options.loops;

		random = options.random != null ? options.random : Math.random;
		particles = new haxe.ds.Vector(cacheSize);
		_particlesSorted = new haxe.ds.Vector(cacheSize);
		_particlesSortTmp = new haxe.ds.Vector(cacheSize);
	}

	public final function start() {
		_loopsCounter = 0;
		startInternal();
		if(preprocess > 0) {
			update(preprocess);
		}
	}

	public final function stop() {
		stopInternal();
	}

	public final function update(elapsed:Float) {
		if(!active) return;
		_frameTime = elapsed;
		setTransform(_x, _y, rotation, scaleX, scaleY, originX, originY, 0, 0);

		onUpdate(elapsed);

		_lastX = _x;
		_lastY = _y;
	}

	public function emit() {}

	public function unspawnAll() {
		for (i in 0...activeCount) {
			onParticleUnspawn(particles[i]);
		}
		activeCount = 0;
	}
	
	function startInternal() {
		progress = 0;
		_wrapIdx = 0;
		enabled = true;
		_lastX = _x;
		_lastY = _y;
		onStart();
	}

	function stopInternal() {
		enabled = false;
		onStop();
	}

	function restart() {
		stopInternal();
		startInternal();
	}

	function step(elapsed:Float) {
		onStepStart(elapsed);
		onStep(elapsed);
		onStepEnd(elapsed);
	}

	function updateParticles(elapsed:Float) {
		var p:T;
		var i:Int = 0;
		var len:Int = activeCount;
		var timeLeft:Float = 0;
		while(i < len) {
			p = particles[i];
			if(p.age + elapsed >= p.lifetime) {
				timeLeft = (p.age + elapsed) - p.lifetime;
				if(timeLeft > 0) onParticleUpdate(p, timeLeft);
				p.age += timeLeft;
				unspawn(p);
				len = activeCount;
			} else {
				p.age += elapsed;
				onParticleUpdate(p, elapsed);
				i++;
			}
		}
	}

	final function spawn() {
		if(activeCount < cacheSize) {
			var p = particles[activeCount];
			activeCount++;
			spawnParticle(p);
		} else if(cacheWrap) {
			var lastIdx = activeCount-1;
			swapParticles(_wrapIdx % lastIdx, lastIdx);
			_wrapIdx++;
			var p = particles[lastIdx];
			unspawnParticle(p);
			spawnParticle(p);
		}
	}

	final function unspawn(p:T) {
		swapParticles(p.index, activeCount-1);
		activeCount--;
	}

	final function swapParticles(a:Int, b:Int) {
		var pA = particles[a];
		var pB = particles[b];

		particles[a] = pB;
		particles[b] = pA;

		pB.index = a;
		pA.index = b;
	}

	inline function spawnParticle(p:T) {
		p.age = 0;
		onParticleSpawn(p);
	}

	inline function unspawnParticle(p:T) {
		onParticleUnspawn(p);
	}

	function getSorted():haxe.ds.Vector<T> {
		if(sortFunc != null) {
			var i:Int = 0;
			while(i < activeCount) {
				_particlesSorted[i] = particles[i];
				i++;
			}
			sort(_particlesSorted, _particlesSortTmp, 0, activeCount-1, sortFunc);
			return _particlesSorted;
		} else {
			return particles;
		}
	}

	function onStart() {}
	function onStop() {}
	function onUpdate(elapsed:Float) {}
	function onStepStart(elapsed:Float) {}
	function onStep(elapsed:Float) {}
	function onStepEnd(elapsed:Float) {}
	function onParticleUpdate(p:T, elapsed:Float) {}
	function onParticleSpawn(p:T) {}
	function onParticleUnspawn(p:T) {}

	function getRotateX(x:Float, y:Float):Float {
		return _cos * x - _sin * y;
	}

	function getRotateY(x:Float, y:Float):Float {
		return _sin * x + _cos * y;
	}

	function getTransformX(x:Float, y:Float):Float {
		return _a * x + _c * y + _tx;
	}

	function getTransformY(x:Float, y:Float):Float {
		return _b * x + _d * y + _ty;
	}

	function setTransform(x:Float, y:Float, angle:Float, sx:Float, sy:Float, ox:Float, oy:Float, kx:Float, ky:Float) {
		_sin = Math.sin(angle);
		_cos = Math.cos(angle);

		_a = _cos * sx - ky * _sin * sy;
		_b = _sin * sx + ky * _cos * sy;
		_c = kx * _cos * sx - _sin * sy;
		_d = kx * _sin * sx + _cos * sy;
		_tx = x - ox * _a - oy * _c;
		_ty = y - ox * _b - oy * _d;
	}

	final function random1To1(){ 
		return random() * 2 - 1; 
	}

	final function randomInt(min:Float, ?max:Null<Float>):Int {
		return Math.floor(randomFloat(min, max));
	}

	final function randomFloat(min:Float, ?max:Null<Float>):Float {
		if(max == null) { max = min; min = 0; }
		return random() * (max - min) + min;
	}

	// merge sort
	function sort(a:haxe.ds.Vector<T>, aux:haxe.ds.Vector<T>, l:Int, r:Int, compare:(p1:T, p2:T)->Int) { 
		if (l < r) {
			var m = Std.int(l + (r - l) / 2);
			sort(a, aux, l, m, compare);
			sort(a, aux, m + 1, r, compare);
			merge(a, aux, l, m, r, compare);
		}
	}

	inline function merge(a:haxe.ds.Vector<T>, aux:haxe.ds.Vector<T>, l:Int, m:Int, r:Int, compare:(p1:T, p2:T)->Int) { 
		var k = l;
		while (k <= r) {
			aux[k] = a[k];
			k++;
		}

		k = l;
		var i = l;
		var j = m + 1;
		while (k <= r) {
			if (i > m) a[k] = aux[j++];
			else if (j > r) a[k] = aux[i++];
			else if (compare(aux[j], aux[i]) < 0) a[k] = aux[j++];
			else a[k] = aux[i++];
			k++;
		}
	}

}

interface IParticleEmitter<T:ParticleBase> {

	public var cacheSize(default, null):Int;
	public var activeCount(default, null):Int;
	public var progress(default, null):Float;
	public var localSpace:Bool;
	public var enabled:Bool;
	public var particles:haxe.ds.Vector<T>;
	public var loops:Int;
	public var random:()->Float;
	public var sortFunc:(a:T, b:T)->Int;

	private var _x:Float;
	private var _y:Float;
	private var _lastX:Float;
	private var _lastY:Float;
	private var _frameTime:Float;
	private var _loopsCounter:Int;

	private var _a:Float;
	private var _b:Float;
	private var _c:Float;
	private var _d:Float;
	private var _tx:Float;
	private var _ty:Float;

	public function emit():Void;
	public function start():Void;
	public function stop():Void;
	private function updateParticles(elapsed:Float):Void;
	private function getSorted():haxe.ds.Vector<T>;
	private function restart():Void;
	private function spawn():Void;
	private function unspawn(p:T):Void;
	private function step(elapsed:Float):Void;

	private function onUpdate(elapsed:Float):Void;
	private function onStepStart(elapsed:Float):Void;
	private function onStep(elapsed:Float):Void;
	private function onStepEnd(elapsed:Float):Void;
	private function onStart():Void;
	private function onStop():Void;

	private function onParticleUpdate(p:T, elapsed:Float):Void;
	private function onParticleSpawn(p:T):Void;
	private function onParticleUnspawn(p:T):Void;

	private function getRotateX(x:Float, y:Float):Float;
	private function getRotateY(x:Float, y:Float):Float;
	
	private function getTransformX(x:Float, y:Float):Float;
	private function getTransformY(x:Float, y:Float):Float;

	private function random1To1():Float;
	private function randomInt(min:Float, ?max:Null<Float>):Int;
	private function randomFloat(min:Float, ?max:Null<Float>):Float;
	
}

typedef ParticleEmitterOptions = {
	?name:String,
	?x:Float,
	?y:Float,

	?active:Bool,
	?enabled:Bool,
	?cacheSize:Int,
	?cacheWrap:Bool,
	?localSpace:Bool,
	?preprocess:Float,

	?loops:Int,

	?random:()->Float,
}
