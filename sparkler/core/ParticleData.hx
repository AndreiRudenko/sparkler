package sparkler.core;


import luxe.Sprite;


class ParticleData {


	public var x:Float = 0;
	public var y:Float = 0;
	public var r:Float = 0;
	public var w:Float = 32;
	public var h:Float = 32;
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
