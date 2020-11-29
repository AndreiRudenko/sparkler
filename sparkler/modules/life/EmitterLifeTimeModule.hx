package sparkler.modules.life;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('emitterLife')
class EmitterLifeTimeModule extends ParticleModule<Particle> {

	public var emitterLifeTime:Float = 5;
	var _emTime:Float = 0;

	function new(options:{?emitterLifeTime:Float}) {
		if(options.emitterLifeTime != null) emitterLifeTime = options.emitterLifeTime;
	}
	
	override function onStart() {
		_emTime = 0;
	}

	override function onUpdate(elapsed:Float) {
	    while(enabled && _emTime + elapsed >= emitterLifeTime) {
			step(emitterLifeTime - _emTime);
			elapsed -= (emitterLifeTime - _emTime);
			_emTime = emitterLifeTime;
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
				_emTime += elapsed;
				progress = _emTime / emitterLifeTime;
			}
		}
	}

}