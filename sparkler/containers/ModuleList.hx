package sparkler.containers;


import sparkler.core.ParticleModule;


class ModuleList {


	public var head (default, null) : ParticleModule;
	public var tail (default, null) : ParticleModule;

	public var length(default, null):Int = 0;

	public function new() {}

	public function add(module:ParticleModule):ModuleList {

		if (head == null) {
			head = tail = module;
			module.next = module.prev = null;
		} else {
			var node:ParticleModule = tail;
			while (node != null) {
				if (node.priority <= module.priority){
					break;
				}

				node = node.prev;
			}

			if (node == tail) {
				tail.next = module;
				module.prev = tail;
				module.next = null;
				tail = module;
			} else if (node == null) {
				module.next = head;
				module.prev = null;
				head.prev = module;
				head = module;
			} else {
				module.next = node.next;
				module.prev = node;
				node.next.prev = module;
				node.next = module;
			}
		}

		length++;

		return this;

	}

	public function exists(module_class:Class<Dynamic>):Bool {

		var ret:Bool = false;

		var node:ParticleModule = head;
		while (node != null){
			if (Type.getClass(node) == module_class){
				ret = true;
				break;
			}

			node = node.next;
		}

		return ret;

	}

	public function get(module_class:Class<Dynamic>):ParticleModule { 

		var ret:ParticleModule = null;

		var node:ParticleModule = head;
		while (node != null){
			if (Type.getClass(node) == module_class){
				ret = node;
				break;
			}

			node = node.next;
		}

		return ret;

	}

	public function remove(module:ParticleModule):ModuleList {

		if (module == head){
			head = head.next;
			
			if (head == null) {
				tail = null;
			}
		} else if (module == tail) {
			tail = tail.prev;
				
			if (tail == null) {
				head = null;
			}
		}

		if (module.prev != null){
			module.prev.next = module.next;
		}

		if (module.next != null){
			module.next.prev = module.prev;
		}

		module.next = module.prev = null;

		length--;

		return this;

	}

	public function update(module:ParticleModule):ModuleList {

		remove(module);
		add(module);

		return this;

	}

	public function updateAll():ModuleList {

		var _sort_array:Array<ParticleModule> = [];

		var node:ParticleModule = head;
		while (node != null){
			_sort_array.push(node);
			node = node.next;
		}

		clear();
		
		for (n in _sort_array) {
			add(n);
		}

		return this;

	}

	public function clear():ModuleList {

		var module:ParticleModule = null;
		while (head != null) {
			module = head;
			head = head.next;
			module.prev = null;
			module.next = null;
		}

		tail = null;
		
		length = 0;

		return this;

	}

	public function toArray():Array<ParticleModule> {

		var _arr:Array<ParticleModule> = []; 

		var node:ParticleModule = head;
		while (node != null){
			_arr.push(node);
			node = node.next;
		}

		return _arr;

	}

	@:noCompletion public function toString() {

		var _list:Array<String> = []; 

		var cn:String;
		var node:ParticleModule = head;
		while (node != null){
			cn = Type.getClassName(Type.getClass(node));
			_list.push('$cn / priority: ${node.priority}');
			node = node.next;
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():ModuleListIterator {

		return new ModuleListIterator(head);

	}
	

}

@:final @:unreflective @:dce
class ModuleListIterator {


	public var node:ParticleModule;


	public inline function new(head:ParticleModule) {

		node = head;

	}

	public inline function hasNext():Bool {

		return node != null;

	}

	public inline function next():ParticleModule {

		var n = node;
		node = node.next;
		return n;

	}


}

