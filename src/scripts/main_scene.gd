extends Node3D

func find_child_node(node, cname: String):
	for child in node.children:
		if child.name == cname:
			return child
	return null

func anim_to_dict(anim): # still missing properties but fuck it we ball
	var nameNode = find_child_node(anim, "Name")
	var indexNode = find_child_node(anim, "Index")
	var frameWidthNode = find_child_node(anim, "FrameWidth")
	var frameHeightNode = find_child_node(anim, "FrameHeight")
	var durationsNode = find_child_node(anim, "Durations")
	var copyOfNode = find_child_node(anim, "CopyOf")
	var durations: Array[int] = []
	var result = {}
	if durationsNode != null:
		for durationNode in durationsNode.children:
			if durationNode.name != "Duration":
				print("unexpected node: {}", durationNode.name)
				continue
			durations.push_back(int(durationNode.content))
		result.durations = durations
	if nameNode != null:
		result.name = nameNode.content
	if indexNode != null:
		result.index = int(indexNode.content)
	if frameWidthNode != null:
		result.frameWidth = int(frameWidthNode.content)
	if frameHeightNode != null:
		result.frameHeight = int(frameHeightNode.content)
	if copyOfNode != null:
		result.copyOf = copyOfNode.content
	return result
	"""return {
		"name": nameNode.content,
		"index": int(indexNode.content),
		"frameWidth": int(frameWidthNode.content),
		"frameHeight": int(frameHeightNode.content),
		"durations": durations,
		"copyOf": copyOfNode
	}"""
func load_anxml():
	var xstr: String = FileAccess.get_file_as_string("res://src/assets/pokemon/0001/AnimData.xml")
	var dict = XmlHelper.xml_to_dictionary(xstr)
	# name, attributes, children, content
	var animationsNode = find_child_node(dict, "Anims")
	if animationsNode == null:
		printerr("Couldn't find child node Anims")
		return null
	var animations: Array[Dictionary] = []
	for animation in animationsNode.children:
		animations.push_back(anim_to_dict(animation))
	return {
		"animations": animations
	}
func animation_to_gd(anim: Dictionary):
	var animation: Animation = Animation.new()
	print(anim.durations)
	var totalLen = anim.durations.reduce(func(a, b): return a+b, 0)
	var lengthInSeconds = float(totalLen) / 30 # here we assume EoS is running in 30fps
	#print(totalLen)
	animation.length = lengthInSeconds
	animation.loop_mode = Animation.LOOP_LINEAR
	var track_idx = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
	animation.track_set_path(track_idx, ".:frame_coords:x")
	var timeElapsed = (float(anim.durations[0])/totalLen)*lengthInSeconds
	var frames = 0
	for duration in anim.durations:
		var timeTaken = (float(duration) / totalLen) * lengthInSeconds
		print("duration: %d; time taken: %f; elapsed: %f; frames: %d" % [duration, timeTaken, timeElapsed, frames])
		timeElapsed += timeTaken
		var key_idx = animation.track_insert_key(track_idx, timeElapsed, frames)
		#animation.track_set_key_transition(track_idx, key_idx, 1.0)
		frames += 1
	return animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var axp = AXP.new()
	#var resp = axp.parse("res://src/assets/AnimData.xml")
	#print(resp.shadowSize)
	#print(resp.animations[1].index)
	var anims = load_anxml()
	var lib = AnimationLibrary.new()
	var anim = animation_to_gd(anims.animations[0])
	lib.add_animation(anims.animations[0].name, anim)
	lib.add_animation(anims.animations[1].name, animation_to_gd(anims.animations[1]))
	print(anims.animations[0].name)
	print(anims.animations[1].name)
	
	$AnimationPlayer.add_animation_library("movement", lib)
	$AnimationPlayer.play("movement/"+anims.animations[0].name)
	$AnimationPlayer2.add_animation_library("movement", lib)
	$AnimationPlayer2.play(&"movement/Attack")
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
	
