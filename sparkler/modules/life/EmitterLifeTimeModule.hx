package sparkler.modules.life;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@group('emitterLife')
class EmitterLifetimeModule extends ParticleModule<Particle> {

	public var emitterLifetime:Float = 5;
	var _emTime:Float = 0;

	function new(options:{?emitterLifetime:Float}) {
		if(options.emitterLifetime != null) emitterLifetime = options.emitterLifetime;
	}
	
	override function onStart() {
		_emTime = 0;
	}

	override function onUpdate(elapsed:Float) {
		while(enabled && _emTime + elapsed >= emitterLifetime) {
			step(emitterLifetime - _emTime);
			elapsed -= (emitterLifetime - _emTime);
			_emTime = emitterLifetime;
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
				progress = _emTime / emitterLifetime;
			}
		}
	}

}