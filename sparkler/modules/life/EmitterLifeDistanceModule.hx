package sparkler.modules.life;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('emitterLife')
class EmitterLifeDistanceModule extends ParticleModule<Particle> {

	public var emitterLifeDistance:Float = 1000;
	var _emDist:Float = 0;

	function new(options:{?emitterLifeDistance:Float}) {
		if(options.emitterLifeDistance != null) emitterLifeDistance = options.emitterLifeDistance;
	}
	
	override function onStart() {
		_emDist = 0;
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
			while(_emDist + distLeft >= emitterLifeDistance) {
				d = emitterLifeDistance - _emDist;
				frameTime = d * f;
				step(frameTime);
				elapsed -= frameTime;
				distLeft -= d;
				_emDist = 0;
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
				_emDist += distLeft;
				progress = _emDist / emitterLifeDistance;
			}
		} else {			
			step(elapsed);
		}
	}

}