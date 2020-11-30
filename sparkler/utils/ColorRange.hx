package sparkler.utils;

@:structInit
class ColorRange {

	public var start:Color;
	public var end:Color;

	public function new(start:Color = 0xFFFFFF, end:Color = 0xFFFFFF) {
		this.start = start;
		this.end = end;
	}

}