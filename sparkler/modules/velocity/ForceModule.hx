package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(11)
@group('force')
class ForceModule extends ParticleModule<Particle<Velocity>> {

	public var force:Vector2;

	function new(options:{?force:{x:Float, y:Float}}) {
		force = options.force != null ? new Vector2(options.force.x, options.force.y) : new Vector2(0, 0);
	}

	override function onParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		if(!localSpace) {
			p.velocity.x += getRotateX(force.x, force.y) * elapsed;
			p.velocity.y += getRotateY(force.x, force.y) * elapsed;
		} else {
			p.velocity.x += force.x * elapsed;
			p.velocity.y += force.y * elapsed;
		}
	}

	@filter('velocity')
	override function onPostParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		p.x += p.velocity.x * elapsed;
		p.y += p.velocity.y * elapsed;
	}

}