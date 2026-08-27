extends Node3D
@onready var strike_anim: Sprite3D = $StrikeAnim
@onready var animation_player_3: AnimationPlayer = $AnimationPlayer3
var animlib = preload("res://src/assets/pokemon/0001/AnimData.xml")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var axp = AXP.new()
	#var resp = axp.parse("res://src/assets/AnimData.xml")
	#print(resp.shadowSize)
	#print(resp.animations[1].index)
	"""var anims = AXP.load_anxml("res://src/assets/pokemon/0001/AnimData.xml")
	var lib = AnimationLibrary.new()
	#var anim = animation_to_gd(anims.animations[0])
	var walkAnim = AXP.get_animation(anims, &"Walk")
	var attackAnim = AXP.get_animation(anims, &"Attack")
	var strikeAnim = AXP.get_animation(anims, &"Strike")
	lib.add_animation(&"Walk", AXP.animation_to_gd(walkAnim))
	lib.add_animation(&"Attack", AXP.animation_to_gd(attackAnim))
	lib.add_animation(&"Strike", AXP.animation_to_gd(strikeAnim))
	
	$AnimationPlayer.add_animation_library("movement", lib)
	$AnimationPlayer.play(&"movement/Walk")
	$AnimationPlayer2.add_animation_library("movement", lib)
	$AnimationPlayer2.play(&"movement/Attack")
	animation_player_3.add_animation_library("movement", lib)
	animation_player_3.play(&"movement/Strike")"""
	$AnimationPlayer.play("AnimData/Walk")
	print($AnimationPlayer.get_animation_library(&"AnimData").get_animation_data(&"Walk"))
	
var frame = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame = (frame + 1) % 8
	if frame != 0:
		return
	if Input.is_action_pressed("arrow_right"):
		$Sprite3D.frame_coords.y = ($Sprite3D.frame_coords.y + 1) % 8
		$AttackAnim.frame_coords.y = ($AttackAnim.frame_coords.y + 1) % 8
		
	if Input.is_action_pressed("arrow_left"):
		$Sprite3D.frame_coords.y = ($Sprite3D.frame_coords.y - 1) % 8
		$AttackAnim.frame_coords.y = ($AttackAnim.frame_coords.y - 1) % 8
	
