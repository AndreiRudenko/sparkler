package sparkler.utils;

class PropertyNode<T> {

	public var time:Float;
	public var value:T;
	public var next:PropertyNode<T>;

	public function new(time:Float, value:T) {
		this.time = time;
		this.value = value;
	}

}