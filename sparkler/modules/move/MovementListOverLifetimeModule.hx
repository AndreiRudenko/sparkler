package sparkler.modules.move;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;
import sparkler.utils.Vector2PropertyList;
import sparkler.components.Velocity;
import sparkler.components.LifeProgress;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(65)
@group('move')
@addModules(sparkler.modules.helpers.LifeProgressModule)
class MovementListOverLifetimeModule extends ParticleModule<Particle<Vector2PropertyList, LifeProgress>> {

	public var movementListOverLifetime:Vector2PropertyList;

	function new(options:{?movementListOverLifetime:{?ease:(v:Float)->Float, list:Array<{time:Float, value:sparkler.utils.Vector2}>}}) {
		if(options.movementListOverLifetime != null) {
			movementListOverLifetime = Vector2PropertyList.create(options.movementListOverLifetime.list);
			movementListOverLifetime.ease = options.movementListOverLifetime.ease;
		} else {
			movementListOverLifetime = new Vector2PropertyList();
		}
	}

	override function onParticleSpawn(p:Particle<Vector2PropertyList, LifeProgress>) {
		p.vector2PropertyList.set(movementListOverLifetime);
	}

	override function onParticleUpdate(p:Particle<Vector2PropertyList, LifeProgress>, elapsed:Float) {
		p.vector2PropertyList.interpolate(p.lifeProgress);
		p.x += p.vector2PropertyList.value.x * elapsed;
		p.y += p.vector2PropertyList.value.y * elapsed;
	}

}