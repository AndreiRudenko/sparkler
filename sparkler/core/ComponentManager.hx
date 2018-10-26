package sparkler.core;


import sparkler.core.Particle;
import sparkler.core.Components;
import sparkler.ParticleEmitter;
import sparkler.core.ParticleVector;


class ComponentManager {


	var capacity:Int;
	var components:Map<String, Components<Dynamic>>;


	public function new(_capacity:Int) {

		capacity = _capacity;
		components = new Map();

	}

	public function get<T>(_component_class:Class<T>):Components<T> {

		return cast components.get(Type.getClassName(_component_class));

	}

	public function has(_component_class:Class<Dynamic>):Bool {
		
		return components.exists(Type.getClassName(_component_class));

	}

	@:access(sparkler.core.Particle)
	public function set<T>(_particles:ParticleVector, _component_class:Class<T>, _f:Void->T):Components<T> {

		var cname:String = Type.getClassName(_component_class);
		var cp:Components<T> = cast components.get(cname);

		if(cp == null) {
			cp = new Components<T>(capacity);
			components.set(cname, cp);
		} else {
			if(cp.length > 0) {
				throw('type: $cname components is not empty');
			}
		}

		for (i in 0..._particles.capacity) {
			cp.set(new Particle(i), _f());
		}

		return cp;

	}

	public function remove<T>(_component_class:Class<T>):Bool {

		var cp = components.get(Type.getClassName(_component_class));

		if(cp != null) {
			cp.clear();
			return true;
		}

		return false;

	}

	public function remove_all(_particle:Particle) {

		for (c in components) {
			c.remove(_particle);
		}

	}

	public function clear() {

		for (c in components) {
			c.clear();
		}

	}


}