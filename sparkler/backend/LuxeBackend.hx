package sparkler.backend;

import luxe.Sprite;
import phoenix.Batcher;
import sparkler.core.ParticleData;
import sparkler.core.Particle;
import sparkler.data.Color;


class LuxeBackend implements Backend {


	var batcher:Batcher;


	public function new(?_batcher:Batcher) {

		batcher = _batcher;

		if(_batcher == null) {
			batcher = Luxe.renderer.batcher;
		}

	}

	public function sprite_create(p:Particle):ParticleData {

		var sprite = new Sprite({
			name: 'particle_'+p.id,
			// depth: depth,
			// texture: tex,
			no_scene: true,
			no_batcher_add: true
		});

		return new ParticleData(sprite);

	}

	public function sprite_destroy(pd:ParticleData):Void {

		var sprite:Sprite = pd.sprite;
		sprite.destroy();

	}

	public function sprite_show(pd:ParticleData):Void {

		var sprite:Sprite = pd.sprite;

		var geom = sprite.geometry;
		if(geom != null && !geom.added) {
			batcher.add(geom);
		}
		
	}

	public function sprite_hide(pd:ParticleData):Void {

		var sprite:Sprite = pd.sprite;

		var geom = sprite.geometry;
		if(geom != null && geom.added) {
			batcher.remove(geom);
		}

	}

	public function sprite_update(pd:ParticleData):Void {

		var sprite:Sprite = pd.sprite;
		var color:Color = pd.color;

		// position
		if(pd.x != sprite.pos.x) {
			sprite.pos.x = pd.x;
		}
		
		if(pd.y != sprite.pos.y) {
			sprite.pos.y = pd.y;
		}

		// size
		if(pd.w != sprite.size.x) {
			sprite.size.x = pd.w;
		}
		
		if(pd.h != sprite.size.y) {
			sprite.size.y = pd.h;
		}

		// rotation
		if(pd.r != sprite.rotation_z) {
			sprite.rotation_z = pd.r;
		}

		// scale
		if(pd.s != sprite.scale.x) {
			sprite.scale.set_xy(pd.s,pd.s);
		}

		// color
		if(color.r != sprite.color.r) {
			sprite.color.r = color.r;
		}

		if(color.g != sprite.color.g) {
			sprite.color.g = color.g;
		}

		if(color.b != sprite.color.b) {
			sprite.color.b = color.b;
		}

		if(color.a != sprite.color.a) {
			sprite.color.a = color.a;
		}

	}

	public function sprite_set_depth(pd:ParticleData, depth:Float):Void {

		var sprite:Sprite = pd.sprite;
		sprite.depth = depth;

	}

	public function sprite_set_texture(pd:ParticleData, path:String):Void {

		var sprite:Sprite = pd.sprite;
		var tex = Luxe.resources.texture(path);
		sprite.texture = tex;

	}


}

