package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('updateStep')
class DistanceModule extends ParticleModule<Particle> {

	public var distance:Float = 1000;
	var _distanceOffset:Float = 0;

	function new(options:{?distance:Float}) {
		if(options.distance != null) distance = options.distance;
	}
	
	override function onStart() {
		_distanceOffset = 0;
	}

	override function onUpdate(elapsed:Float) {
		if(enabled && !localSpace && (_lastX != _x || _lastY != _y)) {
			var dx = _x - _lastX;
			var dy = _y - _lastY;
			var currentDistance:Float = Math.sqrt(dx * dx + dy * dy);
			var framePos:Float = elapsed / _frameTime;
			var f = elapsed / currentDistance;
			var distLeft = currentDistance;
			var frameTime:Float = 0;

			var d:Float = 0;
			while(_distanceOffset + distLeft >= distance) {
				d = distance - _distanceOffset;
				frameTime = d * f;
				step(frameTime);
				elapsed -= frameTime;
				distLeft -= d;
				_distanceOffset = 0;
				progress = 1;
				if(loops >= 0 && _loopsCounter >= loops) {
					stop();
					break;
				}
				_loopsCounter++;
				restart();
			}

			if(elapsed > 0) {
				step(elapsed);
				_distanceOffset += distLeft;
				progress = _distanceOffset / distance;
			}
		} else {			
			step(elapsed);
		}
	}

}