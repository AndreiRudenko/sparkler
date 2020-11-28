package sparkler.utils;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class MacroUtils {

	public static function getStringFromTypes(types:Array<Type>, delimiter:String = '_', sort:Bool = true):String {
		var len = types.length;
		var typesStrings = [];
		for (i in 0...len) {
			switch (types[i]) {
				case TInst(t, params):
					typesStrings.push(t.toString());
				case TType(t, params):
					typesStrings.push(t.toString());
				case TAbstract(t, params):
					typesStrings.push(t.toString());
				default:
			}
		}

		if(sort) {
			typesStrings.sort(function(a:String, b:String):Int {
				a = a.toUpperCase();
				b = b.toUpperCase();

				if (a < b) {
					return -1;
				} else if (a > b) {
					return 1;
				} else {
					return 0;
				}
			});
		}

		return typesStrings.join(delimiter);
	}
	
	public static function buildTypeExpr(pack:Array<String>, module:String, name:String):Expr {
		var pack_module = pack.concat([module, name]);
		
		var type_expr = macro $i{pack_module[0]};
		for (idx in 1...pack_module.length){
			var field = $i{pack_module[idx]};
			type_expr = macro $type_expr.$field;
		}
		
		return macro $type_expr;
	}
	
	public static inline function toCamelCase(name:String):String {
		return name.substr(0, 1).toLowerCase() + name.substr(1);
	}

	static public function hasType(types:Array<Type>, type:Type):Bool {
		for (t in types) {
			if(getTypePath(t) == getTypePath(type)) {
				return true;
			}
		}
		return false;
	}

	static public function hasFieldMeta(field:Field, meta:String):Bool {
		return getFieldMeta(field, meta) != null;
	}

	static public function getFieldMeta(field:Field, meta:String):MetadataEntry {
		for (m in field.meta) {
			if(m.name == meta) {
				return m;
			}
		}
		return null;
	}

	static public function hasField(fields:Array<Field>, name:String):Bool {
		return getField(fields, name) != null;
	}

	static public function getField(fields:Array<Field>, name:String):Field {
		for (f in fields) {
			if(f.name == name) {
				return f;
			}
		}
		return null;
	}

	static public function hasObjectField(ofields:Array<ObjectField>, name:String) {
		return getObjectField(ofields, name) != null;
	}

	static public function getObjectField(ofields:Array<ObjectField>, name:String):ObjectField {
		for (f in ofields) {
			if(f.field == name) {
				return f;
			}
		}
		return null;
	}

	#if macro
	static public function buildVar(name:String, access:Array<Access>, type:ComplexType, e:Expr = null, m:Metadata = null):Field {
		return {
			pos: Context.currentPos(),
			name: name,
			access: access,
			kind: FVar(type, e),
			meta: m == null ? [] : m
		};
	}
	
	static public function buildProp(name:String, access:Array<Access>, get:String, set:String, type:ComplexType, e:Expr = null, m:Metadata = null):Field {
		return {
			pos: Context.currentPos(),
			name: name,
			access: access,
			kind: FProp(get, set, type, e),
			meta: m == null ? [] : m
		};
	}
	
	static public function buildFunction(name:String, access:Array<Access>, args:Array<FunctionArg>, ret:ComplexType, exprs:Array<Expr>, m:Metadata = null):Field {
		return {
			pos: Context.currentPos(),
			name: name,
			access: access,
			kind: FFun({
				args: args,
				ret: ret,
				expr: macro $b{exprs}
			}),
			meta: m == null ? [] : m
		};
	}

	static public function buildConstructor(name:String, pack:Array<String>, params:Array<TypeParam>, exprs:Array<Expr>):Expr {
		return {
			pos: Context.currentPos(),
			expr: ENew(
				{
					name: name, 
					pack: pack, 
					params: params
				}, 
				exprs
			)
		}
	}
	#end
	
	static public function getPathInfo(type:Type):PathInfo {
		var data:PathInfo = {
			pack: null,
			module: null,
			name: null
		}

		switch (type) {
			case TInst(ref, types):
				data.pack = ref.get().pack;
				data.module = ref.get().module.split('.').pop();
				data.name = ref.get().name;
			case TType(ref, types):
				data.pack = ref.get().pack;
				data.module = ref.get().module.split('.').pop();
				data.name = ref.get().name;
			case TAbstract(t, params):
				data.pack = t.get().pack;
				data.module = t.get().module.split('.').pop();
				data.name = t.get().name;
			default:
				throw false;
		}
		
		return data;
	}

	static public function getTypePath(type:Type):String {
		switch (type) {
			case TType(ref, types):
				return ref.toString();
			case TAbstract(ref, types):
				return ref.toString();
			case TInst(ref, types):
				return ref.toString();
			default:
				throw false;
		}
		
		return null;
	}

	static public function getClassTypePath(type:haxe.macro.Type) {
		switch (type) {
			case TType(ref, types):
				var name = ref.get().name;
				if(!StringTools.startsWith(name, 'Class')) throw '$name must be Class<T>';
				var pack = name.substring(6, name.length-1).split('.');
				name = pack.pop();
				return {pack: pack, name: name, sub: null, params: []};
			default:
				throw 'Invalid type';
		}
	}

	static public function subclasses(type:ClassType, root:String):Bool {
		var name = type.module + '.' + type.name;
		return (name.substr(0, root.length) == root || type.superClass != null && subclasses(type.superClass.t.get(), root));
	}

}

typedef PathInfo = {
	var pack:Array<String>;
	var module:String;
	var name:String;
}

enum abstract OFType(Int){
	var UNKNOWN;
	var VECTOR;
	var RANGE;
	var LIST;
	var LIST_RANGE;
	var INT;
	var FLOAT;
}