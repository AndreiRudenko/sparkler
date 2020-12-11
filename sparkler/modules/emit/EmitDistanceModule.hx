package sparkler.modules.emit;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('emit')
class EmitDistanceModule extends ParticleModule<Particle> {

	public var emitDistance:Float = 32;
	var _dOffset:Float = 0;

	function new(options:{?emitDistance:Float}) {
		if(options.emitDistance != null) emitDistance = options.emitDistance;
	}

	override function onStart() {
		_dOffset = 0;
	}

	override function onStep(elapsed:Float) {
		if(enabled && !localSpace && emitDistance > 0 && (_lastX != _x || _lastY != _y)) {
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
			while(_dOffset + distLeft >= emitDistance) {
				d = emitDistance - _dOffset;

				ld += d / tickDistance;
				_x = Maths.lerp(_lastX, px, ld);
				_y = Maths.lerp(_lastY, py, ld);

				frameTime = d * f;
				updateParticles(frameTime);
				elapsed -= frameTime;
				distLeft -= d;
				_dOffset = 0;
				emit();
			}

			if (elapsed > 0) {
				framePos = elapsed / _frameTime;
				_x = Maths.lerp(_lastX, px, framePos);
				_y = Maths.lerp(_lastY, py, framePos);
				updateParticles(elapsed);
				_dOffset += distLeft;
			}

			_x = px;
			_y = py;
		} else {			
			var px:Float = _x;
			var py:Float = _y;
			var framePos = elapsed / _frameTime;
			_x = Maths.lerp(_lastX, px, framePos);
			_y = Maths.lerp(_lastY, py, framePos);
			updateParticles(elapsed);
			_x = px;
			_y = py;
		}
	}
	
}