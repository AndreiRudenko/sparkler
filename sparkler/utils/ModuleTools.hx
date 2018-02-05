package sparkler.utils;


import sparkler.core.ParticleModule;
import sparkler.modules.AreaSpawnModule;
import sparkler.modules.ColorLifeModule;
import sparkler.modules.DirectionModule;
import sparkler.modules.ForceModule;
import sparkler.modules.GravityModule;
import sparkler.modules.RadialSpawnModule;
import sparkler.modules.RotationModule;
import sparkler.modules.ScaleLifeModule;
import sparkler.modules.SizeLifeModule;
import sparkler.modules.VelocityLifeModule;
import sparkler.modules.VelocityModule;


class ModuleTools {


	public static var modules(default, null):Map<String, Void->ParticleModule> = new Map();
	

	public static function init() {

		modules.set(Type.getClassName(AreaSpawnModule),       function() { return new AreaSpawnModule({});});
		modules.set(Type.getClassName(ColorLifeModule),       function() { return new ColorLifeModule({});});
		modules.set(Type.getClassName(DirectionModule),       function() { return new DirectionModule({});});
		modules.set(Type.getClassName(ForceModule),           function() { return new ForceModule({});});
		modules.set(Type.getClassName(GravityModule),         function() { return new GravityModule({});});
		modules.set(Type.getClassName(RadialSpawnModule),     function() { return new RadialSpawnModule({});});
		modules.set(Type.getClassName(RotationModule),        function() { return new RotationModule({});});
		modules.set(Type.getClassName(ScaleLifeModule),       function() { return new ScaleLifeModule({});});
		modules.set(Type.getClassName(SizeLifeModule),        function() { return new SizeLifeModule({});});
		modules.set(Type.getClassName(VelocityLifeModule),    function() { return new VelocityLifeModule({});});
		modules.set(Type.getClassName(VelocityModule),        function() { return new VelocityModule({});});
	    
	}

	public static inline function create_from_string(classname:String):ParticleModule {

		var _f = modules.get(classname);
		if(_f != null) {
			return _f();
		}

		return null;
	    
	}


}

