package sparkler.data;


class Rectangle {


    public var x:Float;
    public var y:Float;
    public var w:Float;
    public var h:Float;


    public function new(x:Float = 0, y:Float = 0, w:Float = 0, h:Float = 0) {
        
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

    }

    public function set(x:Float, y:Float, w:Float, h:Float):Rectangle {
        
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;

        return this;

    }
    
    public function clone():Rectangle {

        return new Rectangle(x, y, w, h);

    }

    public function copyFrom(other:Rectangle):Rectangle {

        x = other.x;
        y = other.y;
        w = other.w;
        h = other.h;

        return this;

    }


}