package particles.core;


import particles.core.Particle;
import particles.core.Components;
import particles.ParticleEmitter;
import particles.containers.ParticleVector;


class ComponentManager {


	var id:Int = 0;
	var capacity:Int;
	var components:Array<Components<Dynamic>>;
	var types:Map<String, Int>;


	public function new(_capacity:Int) {

		capacity = _capacity;
		components = [];
		types = new Map();

	}

	public function get<T>(_component_class:Class<T>):Components<T> {

		var ct:Int = -1;
		var tname:String = Type.getClassName(_component_class);
		if(types.exists(tname)) {
			ct = types.get(tname);
			return cast components[ct];
		}

		return null;

	}

	public function has(_component_class:Class<Dynamic>):Bool {
		
		var tname:String = Type.getClassName(_component_class);
		return types.exists(tname);

	}

	@:access(particles.core.Particle)
	public function set<T>(_particles:ParticleVector, _component_class:Class<T>, _f:Void->T):Components<T> {
		
		var tname:String = Type.getClassName(_component_class);

		if(types.exists(tname)) {
			throw('type: $tname already exists in particle components');
		}

		var ct:Int = id++;
		types.set(tname, ct);

		var cp = new Components<T>(capacity);
		components[ct] = cp;

		for (i in 0..._particles.capacity) {
			cp.set(new Particle(i), _f());
		}

		return cp;

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