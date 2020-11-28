package sparkler.modules;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('updateStep')
class DurationModule extends ParticleModule<Particle> {

	public var duration:Float = 5;
	var _time:Float = 0;

	function new(options:{?duration:Float}) {
		if(options.duration != null) duration = options.duration;
	}
	
	override function onStart() {
		_time = 0;
	}

	override function onUpdate(elapsed:Float) {
	    while(enabled && _time + elapsed >= duration) {
			step(duration - _time);
			elapsed -= (duration - _time);
			_time = duration;
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
			if(enabled) {
				_time += elapsed;
				progress = _time / duration;
			}
		}
	}

}