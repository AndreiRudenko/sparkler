package sparkler.utils;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class MacroTypes {

	static public var vectorTypeInfo = {pack: ['sparkler', 'utils'], name: 'Vector2'};
	static public var colorTypeInfo = {pack: ['sparkler', 'utils'], name: 'Color'};

	static public var rangeVecTypeInfo = {pack: ['sparkler', 'utils'], name: 'Range', params: [TPType(TPath(vectorTypeInfo))]};
	static public var rangeColorTypeInfo = {pack: ['sparkler', 'utils'], name: 'Range', params: [TPType(TPath(colorTypeInfo))]};
	static public var rangeIntTypeInfo = {pack: ['sparkler', 'utils'], name: 'Range', params: [TPType(macro: Int)]};
	static public var rangeFloatTypeInfo = {pack: ['sparkler', 'utils'], name: 'Range', params: [TPType(macro: Float)]};

	static public var propListVecTypeInfo = {pack: ['sparkler', 'utils'], name: 'PropertyListVector2'};
	static public var propListColorTypeInfo = {pack: ['sparkler', 'utils'], name: 'PropertyListColor'};

}
