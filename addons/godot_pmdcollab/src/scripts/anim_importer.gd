@tool
extends EditorImportPlugin

## PMDCollab Animation Player
#class_name PC_AnimationPlayer

func update_animations(xmlFile: String):
	var parser = XMLParser.new()
	parser.open(xmlFile)
	

func _get_importer_name() -> String:
	return "pmdcollab.animdata.xml.importer"

func _get_visible_name() -> String:
	return "PMDCollab Animation Data"

func _get_recognized_extensions() -> PackedStringArray:
	return ["xml"]

func _get_save_extension() -> String:
	return "xmlal"

func _get_resource_type() -> String:
	return "AnimationLibrary"

#func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
#	pass
