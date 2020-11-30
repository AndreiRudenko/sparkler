package sparkler.utils;

@:structInit
class FloatRange {

	public var start:Float;
	public var end:Float;

	public function new(start:Float = 0, end:Float = 0) {
		this.start = start;
		this.end = end;
	}

}