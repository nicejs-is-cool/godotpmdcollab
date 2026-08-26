@tool
extends EditorPlugin


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	#add_custom_type("PC_AnimationPlayer", 'AnimationPlayer', preload("res://addons/godot_pmdcollab/src/scripts/anim_importer.gd"), preload("res://icon.svg"))
	#add_import_plugin()
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	#remove_custom_type("PC_AnimationPlayer")
	pass
