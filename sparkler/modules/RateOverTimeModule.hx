package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.RateOverTimeModule.RateOverTime;

class RateOverTime {

	public var rate:Float = 40;
	public var time:Float = 1;

	public function new() {}

}

@group('rate')
class RateOverTimeModule extends ParticleModule<Particle> {

	public var rateOverTime:RateOverTime;
	var _frameOffset:Float = 0;

	function new(options:{?rateOverTime: {?rate:Float, ?time:Float}}) {
		rateOverTime = new RateOverTime();
		if(options.rateOverTime != null) {
			if(options.rateOverTime.time != null) rateOverTime.time = options.rateOverTime.time;
			if(options.rateOverTime.rate != null) rateOverTime.rate = options.rateOverTime.rate;
		}
	}

	override function onStart() {
	    _frameOffset = 0;
	}

	inline function lerp(start:Float, end:Float, t:Float) {
		return (start + t * (end - start));
	}

	override function onStep(elapsed:Float) {
		var px:Float = _x;
		var py:Float = _y;

		var ft:Float = 0;
		var lt:Float = 0;

		var rate = rateOverTime.rate / rateOverTime.time;

		if(enabled && rate > 0) {
			var invRate = 1 / rate;
			var t:Float = 0;
			while (_frameOffset + elapsed >= invRate) { // TODO: test >=
				t = invRate - _frameOffset;
				ft += t;
				if(!localSpace) {
					lt = ft / _frameTime;
					_x = lerp(_lastX, px, lt);
					_y = lerp(_lastY, py, lt);
				}
				updateParticles(t);
				elapsed -= t;
				_frameOffset = 0;
				emit();
			}
		}

		if (elapsed > 0) {
			ft += elapsed;
			if(!localSpace) {
				lt = ft / _frameTime;
				_x = lerp(_lastX, px, ft / _frameTime);
				_y = lerp(_lastY, py, ft / _frameTime);
			}
			updateParticles(elapsed);
			if (enabled && rate > 0) {
				_frameOffset += elapsed;
			}
		}

		_x = px;
		_y = py;
	}
	
}