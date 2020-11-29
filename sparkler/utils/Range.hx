package sparkler.utils;

@:structInit
class Range<T> {

	public var min:T;
	public var max:T;

	public function new(min:T, max:T) {
		this.min = min;
		this.max = max;
	}

}