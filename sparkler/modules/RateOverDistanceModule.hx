package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.modules.RateOverDistanceModule.RateOverDistance;

class RateOverDistance {

	public var rate:Float = 1;
	public var distance:Float = 64;

	public function new() {}

}

@group('rate')
class RateOverDistanceModule extends ParticleModule<Particle> {

	public var rateOverDistance:RateOverDistance;
	var _dOffset:Float = 0;

	function new(options:{?rateOverDistance: {?rate:Float, ?distance:Float}}) {
		rateOverDistance = new RateOverDistance();
		if(options.rateOverDistance != null) {
			if(options.rateOverDistance.distance != null) rateOverDistance.distance = options.rateOverDistance.distance;
			if(options.rateOverDistance.rate != null) rateOverDistance.rate = options.rateOverDistance.rate;
		}
	}

	override function onStart() {
	    _dOffset = 0;
	}

	inline function lerp(start:Float, end:Float, t:Float) {
		return (start + t * (end - start));
	}

	override function onStep(elapsed:Float) {
		if(enabled && !localSpace && (_lastX != _x || _lastY != _y)) {
			var distance = rateOverDistance.distance / rateOverDistance.rate;
			var px:Float = _x;
			var py:Float = _y;

			var dx = _x - _lastX;
			var dy = _y - _lastY;

			var len:Float = Math.sqrt(dx * dx + dy * dy);

			var framePos:Float = elapsed / _frameTime;
			var tickDistance = len * framePos;
			var distLeft = tickDistance;

			var f = elapsed / tickDistance;

			var frameTime:Float = 0;
			var ld:Float = 0;

			var d:Float = 0;
			while(_dOffset + distLeft >= distance) {
				d = distance - _dOffset;

				ld += d / tickDistance;
				_x = lerp(_lastX, px, ld);
				_y = lerp(_lastY, py, ld);

				frameTime = d * f;
				updateParticles(frameTime);
				elapsed -= frameTime;
				distLeft -= d;
				_dOffset = 0;
				emit();
			}

			if (elapsed > 0) {
				framePos = elapsed / _frameTime;
				_x = lerp(_lastX, px, framePos);
				_y = lerp(_lastY, py, framePos);
				updateParticles(elapsed);
				_dOffset += distLeft;
			}

			_x = px;
			_y = py;
		} else {			
			var px:Float = _x;
			var py:Float = _y;
			var framePos = elapsed / _frameTime;
			_x = lerp(_lastX, px, framePos);
			_y = lerp(_lastY, py, framePos);
			updateParticles(elapsed);
			_x = px;
			_y = py;
		}
	}
	
}