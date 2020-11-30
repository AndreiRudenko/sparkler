package sparkler.utils;

@:structInit
class Range<T> {

	public var start:T;
	public var end:T;

	public function new(start:T, end:T) {
		this.start = start;
		this.end = end;
	}

}