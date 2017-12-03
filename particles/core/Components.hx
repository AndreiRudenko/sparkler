package particles.core;


import particles.core.Particle;
import haxe.ds.Vector;


class Components<T> {


	var components: Vector<T>;


	public function new(_capacity:Int) {

		components = new Vector(_capacity);

	}

	public function set(p:Particle, c:T):T {

		if(has(p)) {
			remove(p);
		}

		components[p.id] = c;

		return c;

	}

	public inline function get(p:Particle):T {

		return components[p.id];

	}

	public inline function has(p:Particle):Bool {
		
		return components[p.id] != null;

	}

	public function remove(p:Particle):Bool {

		var _has:Bool = has(p);

		if(_has) {
			components[p.id] = null;
		}

		return _has;

	}

	public function clear() {
		
		for (i in 0...components.length) {
			if(components[i] != null) {
				components[i] = null;
			}
		}

	}


}

