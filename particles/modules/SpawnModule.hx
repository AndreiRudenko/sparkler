package particles.modules;

import particles.core.Particle;
import particles.core.ParticleModule;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import phoenix.Texture;
import phoenix.Batcher;


class SpawnModule extends ParticleModule {


	public var data:Array<SpawnData>;
	public var position_variance:Vector;

	var batcher:Batcher;
	var texture:Texture;
	var depth:Float;


	public function new(_options:SpawnModuleOptions) {

		super();

		data = [];

		batcher = _options.batcher != null ? _options.batcher : Luxe.renderer.batcher;
		position_variance = _options.position_variance;
		texture = _options.image;
		depth = _options.depth != null ? _options.depth : 300;

	}

	override function spawn(p:Particle) {

		var sd:SpawnData = data[p.id];

		if(sd.sprite.geometry != null) {
			batcher.add(sd.sprite.geometry);
		}

		sd.x = emitter.system.position.x + emitter.position.x;
		sd.y = emitter.system.position.y + emitter.position.y;

		if(position_variance != null) {
			sd.x += (position_variance.x * emitter.random_1_to_1());
			sd.y += (position_variance.y * emitter.random_1_to_1());
		}

	}

	override function unspawn(p:Particle) {

		var sd:SpawnData = data[p.id];

		if(sd.sprite.geometry != null) {
			batcher.remove(sd.sprite.geometry);
		}

	}

	override function destroy() {

	    var sd:SpawnData;
		for (p in particles) {
			sd = data[p.id];
			sd.sprite.destroy();
		}

	}

	override function init() {

		for (i in 0...particles.capacity) {
			var sd:SpawnData = new SpawnData();

            sd.sprite = new Sprite({
                name: '_particle_'+i,
                depth: depth,
                texture: texture,
                no_scene: true,
                no_batcher_add: true
            });

			data[i] = sd;
		}
	    
	}

	override function update(dt:Float) {

		for (p in particles) {
			data[p.id].sync_transform();
		}

	}


}


class SpawnData {


	public var x:Float = 0;
	public var y:Float = 0;
	public var r:Float = 0;
	public var w:Float = 64;
	public var h:Float = 64;
	public var s:Float = 1;

	public var sprite:Sprite;


	public function new() {}

	public inline function sync_transform() {
		
		if(x != sprite.pos.x) {
			sprite.pos.x = x;
		}
		
		if(y != sprite.pos.y) {
			sprite.pos.y = y;
		}

		if(w != sprite.size.x) {
			sprite.size.x = w;
		}
		
		if(h != sprite.size.y) {
			sprite.size.y = h;
		}

		if(r != sprite.rotation_z) {
			sprite.rotation_z = r;
		}

		if(s != sprite.scale.x) {
			sprite.scale.set_xy(s,s);
		}

	}


}


typedef SpawnModuleOptions = {

	@:optional var batcher : Batcher;
	@:optional var depth : Float;
	@:optional var image : Texture;
	@:optional var position_variance : Vector;

}


