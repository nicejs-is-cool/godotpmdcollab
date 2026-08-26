extends RefCounted
# Animation XML Parser
class_name AXP

const _execFrames = ["HitFrame", "HurtFrame", "ReturnFrame", "RushFrame"]
static var _execFramesCamelCase = _execFrames.map(func(x): return x.to_camel_case())
const _execFrameMapping = {
	"hitFrame": "_on_hit_frame",
	"hurtFrame": "_on_hurt_frame",
	"returnFrame": "_on_return_frame",
	"rushFrame": "_on_rush_frame"
}

static func find_child_node(node, cname: String):
	for child in node.children:
		if child.name == cname:
			return child
	return null

static func anim_to_dict(anim): # still missing properties but fuck it we ball
	var nameNode = find_child_node(anim, "Name")
	var indexNode = find_child_node(anim, "Index")
	var frameWidthNode = find_child_node(anim, "FrameWidth")
	var frameHeightNode = find_child_node(anim, "FrameHeight")
	var durationsNode = find_child_node(anim, "Durations")
	var copyOfNode = find_child_node(anim, "CopyOf")
	
	var rushFrameNode = find_child_node(anim, "RushFrame")
	var hitFrameNode = find_child_node(anim, "HitFrame")
	var returnFrameNode = find_child_node(anim, "ReturnFrame")
	
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
	if rushFrameNode != null:
		result.rushFrame = int(rushFrameNode.content)
	if hitFrameNode != null:
		result.hitFrame = int(hitFrameNode.content)
	if returnFrameNode != null:
		result.returnFrame = int(returnFrameNode.content)
	if copyOfNode != null:
		result.copyOf = copyOfNode.content
	return result
static func load_anxml(path: String):
	var xstr: String = FileAccess.get_file_as_string(path)
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
static func _has_any_inside(arr1: Array, arr2: Array):
	for i in arr1:
		for j in arr2:
			if arr1.has(j):
				return true
	return false
static func animation_to_gd(anim: Dictionary):
	var animation: Animation = Animation.new()
	print(anim.durations)
	var totalLen = anim.durations.reduce(func(a, b): return a+b, 0)
	var lengthInSeconds = float(totalLen) / 30 # here we assume EoS is running in 30fps
	#print(totalLen)
	animation.length = lengthInSeconds
	animation.loop_mode = Animation.LOOP_LINEAR
	var track_idx = animation.add_track(Animation.TYPE_VALUE)
	var exec_track: int = -1
	if _has_any_inside(anim.keys(), _execFramesCamelCase):
		exec_track = animation.add_track(Animation.TYPE_METHOD)
		animation.track_set_path(exec_track, ".")
	animation.track_set_interpolation_type(track_idx, Animation.INTERPOLATION_NEAREST)
	animation.track_set_path(track_idx, ".:frame_coords:x")
	
	var timeElapsed = (float(anim.durations[0])/totalLen)*lengthInSeconds
	var frames = 0
	for duration in anim.durations:
		var timeTaken = (float(duration) / totalLen) * lengthInSeconds
		print("duration: %d; time taken: %f; elapsed: %f; frames: %d" % [duration, timeTaken, timeElapsed, frames])
		timeElapsed += timeTaken
		var key_idx = animation.track_insert_key(track_idx, timeElapsed, frames)
		for execFrame in _execFramesCamelCase:
			if anim.has(execFrame) && anim.get(execFrame) == frames:
				print("adding exec frame %s" % execFrame)
				animation.track_insert_key(exec_track, timeElapsed, {
					"method": _execFrameMapping[execFrame],
					"args": []
				})
		#animation.track_set_key_transition(track_idx, key_idx, 1.0)
		frames += 1
	return animation
static func _find_animation(dict: Dictionary, name: StringName):
	for anim in dict.animations:
		if anim.name == name:
			return anim
	return null
static func get_animation(dict: Dictionary, name: StringName):
	var anim: Dictionary = _find_animation(dict, name)
	if anim.has("copyOf"):
		var newAnim = _find_animation(dict, anim.copyOf)
		if newAnim == null:
			return null
		var dupeAnim  = newAnim.duplicate(true)
		dupeAnim.name = anim.name
		return dupeAnim
	return anim
