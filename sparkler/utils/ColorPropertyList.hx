package sparkler.utils;

import sparkler.utils.Color;

class ColorPropertyList {

	public static function create(items:Array<{time:Float, value:Color}>):ColorPropertyList {
		var list = new ColorPropertyList();

		if(items.length > 0) {
			items.sort(function(a, b) {
				return a.time - b.time > 0 ? 1 : -1;
			});

			var item = items[0];
			list.head = new PropertyNode<Color>(item.time, item.value);
			var node = list.head;
			var i:Int = 1;
			while(i < items.length) {
				item = items[i];
				node.next = new PropertyNode<Color>(item.time, item.value);
				node = node.next;
				i++;
			}
		}

		return list;
	}

	var head:PropertyNode<Color>;
	var current:PropertyNode<Color>;
	var next:PropertyNode<Color>;

	public var value(default, null):Color;
	public var ease:(v:Float)->Float;

	public function new() {
		value = new Color();
	}
	
	public function interpolate(lerp:Float) {
		if(ease != null) lerp = ease(lerp);
		
		while (lerp > this.next.time) {
			this.current = this.next;
			this.next = this.next.next;
		}

		lerp = (lerp - this.current.time) / (this.next.time - this.current.time);

		value = Color.lerp(this.current.value, this.next.value, lerp);
	}

	public function set(p:ColorPropertyList) {
		current = p.head;
		next = current.next;
		value = current.value;
	}

}