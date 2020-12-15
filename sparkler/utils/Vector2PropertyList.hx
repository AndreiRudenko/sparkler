package sparkler.utils;

import sparkler.utils.Vector2;
import sparkler.utils.Maths;

class Vector2PropertyList {

	public static function create(items:Array<{time:Float, value:Vector2}>):Vector2PropertyList {
		var list = new Vector2PropertyList();

		if(items.length > 0) {
			items.sort(function(a, b) {
				return a.time - b.time > 0 ? 1 : -1;
			});

			var item = items[0];
			list.head = new PropertyNode<Vector2>(item.time, item.value);
			var node = list.head;
			var i:Int = 1;
			while(i < items.length) {
				item = items[i];
				node.next = new PropertyNode<Vector2>(item.time, item.value);
				node = node.next;
				i++;
			}
		}

		return list;
	}

	var head:PropertyNode<Vector2>;
	var current:PropertyNode<Vector2>;
	var next:PropertyNode<Vector2>;

	public var value(default, null):Vector2;
	public var ease:(v:Float)->Float;

	public function new() {
		value = new Vector2();
	}
	
	public function interpolate(lerp:Float) {
		if(ease != null) lerp = ease(lerp);
		
		while (lerp > this.next.time) {
			this.current = this.next;
			this.next = this.next.next;
		}

		lerp = (lerp - this.current.time) / (this.next.time - this.current.time);
		
		value.x = Maths.lerp(this.current.value.x, this.next.value.x, lerp);
		value.y = Maths.lerp(this.current.value.y, this.next.value.y, lerp);
	}

	public function set(p:Vector2PropertyList) {
		current = p.head;
		next = current.next;
		value.x = current.value.x;
		value.y = current.value.y;
	}

}