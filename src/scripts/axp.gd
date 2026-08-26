extends Node
# Animation XML Parser
class_name AXP

class AnimData:
	var animations: Array[Anim] = []
	var shadowSize: int = -1

class Anim:
	var name: String
	var index: int
	var frameWidth: int
	var frameHeight: int
	var durations: Array[int]
	
	func _init(name: String, index: int, frameWidth: int, frameHeight: int, durations: Array[int]):
		self.name = name
		self.index = index
		self.frameWidth = frameWidth
		self.frameHeight = frameHeight
		self.durations = durations

func parse(xml: String):
	var res: AnimData = AnimData.new()
	var parser = XMLParser.new()
	var nodeParsing: String = ""
	var anim: Anim
	var anims: Array[Anim]
	parser.open(xml)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			nodeParsing = parser.get_node_name()
			match nodeParsing:
				"Anim":
					anim = Anim.new("", 0, 0, 0, [])
				"Anims":
					anims = []
		if parser.get_node_type() == XMLParser.NODE_TEXT:
			var txt = parser.get_node_data()
			print(nodeParsing, " ", txt)
			if txt == "":
				continue
			match nodeParsing:
				"Name":
					anim.name = txt
				"Index":
					anim.index = int(txt)
				"FrameWidth":
					anim.frameWidth = int(txt)
				"FrameHeight":
					anim.frameHeight = int(txt)
				"Duration":
					anim.durations.push_back(int(txt))
				"ShadowSize":
					res.shadowSize = int(txt)
		if parser.get_node_type() == XMLParser.NODE_ELEMENT_END:
			match parser.get_node_name():
				"AnimData":
					res.animations = anims
					return res
				"Anim":
					anims.push_back(anim)
	
	res.animations = anims
	return res
