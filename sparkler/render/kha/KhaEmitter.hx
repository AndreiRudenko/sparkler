package sparkler.render.kha;


import sparkler.ParticleEmitter;
import sparkler.core.ParticleData;


class KhaEmitter extends EmitterRenderer {


    static private function _parse_image_path(name:String):String {

    	name = haxe.io.Path.withoutExtension(name);
        name = Std.parseInt(name.charAt(0)) != null ? "_" + name : name;
        return (~/[\/\.-\s]/gi).replace(haxe.io.Path.normalize(name), "_");

    }


	var texture:kha.Image;


	public function new(_renderer:KhaRenderer, _emitter:ParticleEmitter) {

		super(_emitter);

	}

	override function init() {

		ontexture(emitter.image_path);

	}

	override function render(c:kha.Canvas) {

		var g = c.g2;

		var pd:ParticleData;
		for (p in emitter.particles) {
			pd = emitter.particles_data[p.id];

			g.color = kha.Color.fromFloats(pd.color.r, pd.color.g, pd.color.b, pd.color.a);
            g.pushRotation(pd.r, pd.x, pd.y);

			var _x:Float = pd.x;
			var _y:Float = pd.y;

			if(pd.centered) {
				_x -= pd.w * 0.5 * pd.s;
				_y -= pd.h * 0.5 * pd.s;
			} else {
				_x -= pd.ox * pd.s;
				_y -= pd.oy * pd.s;
			}

			g.drawScaledSubImage(texture, 
				0, 0, 
				texture.width, texture.height, 
				_x, _y,
				pd.w * pd.s, pd.h * pd.s
			);

            g.popTransformation();

		}
		
	}

	override function ontexture(path:String) {

		texture = kha.Assets.images.get(_parse_image_path(path));

		if(texture == null) {
			throw('can`t load image from path: ${path}');
		}

	}


}
