package sparkler.modules.size;

import sparkler.components.Size;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Vector2;

@priority(3)
@group('size')
class SizeModule extends ParticleModule<Particle<Size>> {

	public var size:Vector2;

	function new(options:{?size:{x:Float, y:Float}}) {
		size = new Vector2(32, 32);
		if(options.size != null) {
			size.x = options.size.x;
			size.y = options.size.y;
		}
	}

	override function onParticleSpawn(p:Particle<Size>) {
		p.size.x = size.x;
		p.size.y = size.y;
	}
	
}