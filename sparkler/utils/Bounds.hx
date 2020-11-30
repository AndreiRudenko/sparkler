package sparkler.utils;

@:structInit
class Bounds<T> {

	public var min:T;
	public var max:T;

	public function new(min:T, max:T) {
		this.min = min;
		this.max = max;
	}

}