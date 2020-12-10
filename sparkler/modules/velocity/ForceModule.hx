package sparkler.modules.velocity;

import sparkler.utils.Vector2;
import sparkler.components.Velocity;
import sparkler.ParticleModule;
import sparkler.Particle;

@priority(20)
@group('force')
@addModules(sparkler.modules.velocity.UpdatePosFromVelocityModule)
class ForceModule extends ParticleModule<Particle<Velocity>> {

	public var force:Vector2;

	function new(options:{?force:{x:Float, y:Float}}) {
		force = options.force != null ? new Vector2(options.force.x, options.force.y) : new Vector2(0, 0);
	}

	override function onParticleUpdate(p:Particle<Velocity>, elapsed:Float) {
		if(localSpace) {
			p.velocity.x += force.x * elapsed;
			p.velocity.y += force.y * elapsed;
		} else {
			p.velocity.x += getRotateX(force.x, force.y) * elapsed;
			p.velocity.y += getRotateY(force.x, force.y) * elapsed;
		}
	}

	@filter('reset velocity')
	override function onParticleUnspawn(p:Particle<Velocity>) {
		p.velocity.x = 0;
		p.velocity.y = 0;
	}

}