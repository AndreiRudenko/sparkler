package sparkler.modules.helpers;

import sparkler.utils.Vector2;
import sparkler.components.PrevPos;
import sparkler.components.Speed;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(70)
class UpdateSpeedModule extends ParticleModule<Particle<Speed, PrevPos>> {

	override function onPreParticleUpdate(p:Particle<Speed, PrevPos>, elapsed:Float) {
		p.prevPos.x = p.x;
		p.prevPos.y = p.y;
	}

	override function onPostParticleUpdate(p:Particle<Speed, PrevPos>, elapsed:Float) {
		var dx = p.x - p.prevPos.x;
		var dy = p.y - p.prevPos.y;
		p.speed = Math.sqrt(dx * dx + dy * dy) / elapsed;
	}

	override function onParticleSpawn(p:Particle<Speed, PrevPos>) {
		p.prevPos.x = p.x;
		p.prevPos.y = p.y;
		p.speed = 0;
	}

}