package sparkler.utils;

import sparkler.utils.Color;

class FloatPropertyList {

	public static function create(items:Array<{time:Float, value:Float}>):FloatPropertyList {
		var list = new FloatPropertyList();

		if(items.length > 0) {
			items.sort(function(a, b) {
				return a.time - b.time > 0 ? 1 : -1;
			});

			var item = items[0];
			list.head = new PropertyNode<Float>(item.time, item.value);
			var node = list.head;
			var i:Int = 1;
			while(i < items.length) {
				item = items[i];
				node.next = new PropertyNode<Float>(item.time, item.value);
				node = node.next;
				i++;
			}
		}

		return list;
	}

	var head:PropertyNode<Float>;
	var current:PropertyNode<Float>;
	var next:PropertyNode<Float>;

	public var value(default, null):Float = 0;
	public var ease:(v:Float)->Float;

	public function new() {}
	
	public function interpolate(lerp:Float) {
		if(ease != null) lerp = ease(lerp);
		
		while (lerp > this.next.time) {
			this.current = this.next;
			this.next = this.next.next;
		}

		lerp = (lerp - this.current.time) / (this.next.time - this.current.time);

		value = this.current.value + (this.next.value - this.current.value) * lerp;
	}

	public function set(p:FloatPropertyList) {
		current = p.head;
		next = current.next;
		value = current.value;
	}

}	
