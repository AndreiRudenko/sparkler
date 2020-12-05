package sparkler.modules.size;

import sparkler.components.Size;
import sparkler.ParticleModule;
import sparkler.Particle;
import sparkler.utils.Vector2;

@priority(3)
@group('size')
class InitialSizeModule extends ParticleModule<Particle<Size>> {

	public var initialSize:Vector2;

	function new(options:{?initialSize:{x:Float, y:Float}}) {
		initialSize = new Vector2(32, 32);
		if(options.initialSize != null) {
			initialSize.x = options.initialSize.x;
			initialSize.y = options.initialSize.y;
		}
	}

	override function onParticleSpawn(p:Particle<Size>) {
		p.size.x = initialSize.x;
		p.size.y = initialSize.y;
	}
	
}