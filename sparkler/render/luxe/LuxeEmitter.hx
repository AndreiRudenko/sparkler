package sparkler.render.luxe;


import luxe.Sprite;
import phoenix.Texture;
import phoenix.Batcher;
import sparkler.ParticleEmitter;
import sparkler.core.ParticleData;
import sparkler.core.Particle;
import sparkler.data.Color;


class LuxeEmitter extends EmitterRenderer {


	var texture:Texture;
	var batcher:Batcher;
	var sprites:Array<Sprite>;


	public function new(_renderer:LuxeRenderer, _emitter:ParticleEmitter) {

		super(_emitter);

		batcher = _renderer.batcher;
		sprites = [];

	}

	override function init() {

		texture = Luxe.resources.texture(emitter.image_path);

		for (i in 0...emitter.particles.capacity) {
			var sprite = new Sprite({
				name: 'particle_$i',
				depth: emitter.system.depth + emitter.index * 0.001,
				texture: texture,
				no_scene: true,
				no_batcher_add: true
			});
			sprites.push(sprite);
		}

	}

	override function destroy() {

		for (s in sprites) {
			s.destroy();
		}

		sprites = null;
		texture = null;
		batcher = null;

	}
	
	override function onparticleshow(p:Particle) {

		var sprite:Sprite = sprites[p.id];

		var geom = sprite.geometry;
		if(geom != null && !geom.added) {
			batcher.add(geom);
		}

	}

	override function onparticlehide(p:Particle) {

		var sprite:Sprite = sprites[p.id];

		var geom = sprite.geometry;
		if(geom != null && geom.added) {
			batcher.remove(geom);
		}

	}

	override function update(dt:Float) {

		var pd:ParticleData;
		var sprite:Sprite;
		for (p in emitter.particles) {
			sprite = sprites[p.id];
			pd = emitter.particles_data[p.id];

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
				sprite.scale.set_xy(pd.s, pd.s);
			}

			sprite.color.set(pd.color.r, pd.color.g, pd.color.b, pd.color.a);

		}

	}

	override function ondepth(depth:Float) {

		for (s in sprites) {
			s.depth = depth + emitter.index * 0.001;
		}

	}

	override function ontexture(path:String) {

		var tex = Luxe.resources.texture(path);
		for (s in sprites) {
			s.texture = tex;
		}

	}

	override function onblendsrc(v:sparkler.data.BlendMode) {

		var sprite:Sprite;
		for (s in sprites) {
			s.blend_src = blend_convert(v);
		}

	}

	override function onblenddest(v:sparkler.data.BlendMode) {

		for (s in sprites) {
			s.blend_dest = blend_convert(v);
		}

	}

	function blend_convert(v:sparkler.data.BlendMode):BlendMode {

		switch (v) {
			case sparkler.data.BlendMode.zero :{
				return BlendMode.zero;
			}
			case sparkler.data.BlendMode.one :{
				return BlendMode.one;
			}
			case sparkler.data.BlendMode.src_color :{
				return BlendMode.src_color;
			}
			case sparkler.data.BlendMode.one_minus_src_color :{
				return BlendMode.one_minus_src_color;
			}
			case sparkler.data.BlendMode.src_alpha :{
				return BlendMode.src_alpha;
			}
			case sparkler.data.BlendMode.one_minus_src_alpha :{
				return BlendMode.one_minus_src_alpha;
			}
			case sparkler.data.BlendMode.dst_alpha :{
				return BlendMode.dst_alpha;
			}
			case sparkler.data.BlendMode.one_minus_dst_alpha :{
				return BlendMode.one_minus_dst_alpha;
			}
			case sparkler.data.BlendMode.dst_color :{
				return BlendMode.dst_color;
			}
			case sparkler.data.BlendMode.one_minus_dst_color :{
				return BlendMode.one_minus_dst_color;
			}
			case sparkler.data.BlendMode.src_alpha_saturate :{
				return BlendMode.src_alpha_saturate;
			}
		}
		
	}

}
