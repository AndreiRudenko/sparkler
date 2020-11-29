package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('rate')
class SpawnRateModule extends ParticleModule<Particle> {

	public var spawnRate:Float = 40;
	var _frameOffset:Float = 0;

	function new(options:{?spawnRate:Float}) {
		if(options.spawnRate != null) spawnRate = options.spawnRate;
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

		if(enabled && spawnRate > 0) {
			var invRate = 1 / spawnRate;
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
			if (enabled && spawnRate > 0) {
				_frameOffset += elapsed;
			}
		}

		_x = px;
		_y = py;
	}
	
}