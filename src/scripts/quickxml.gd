extends Node

class_name QuickXML

class XNode:
	pass

class Element:
	var tag: String = ""
	var attrs: Dictionary[String, String] = {}
	var children: Array[Element] = []
	func _init(tag: String, attrs: Dictionary[String, String], children: Array[Element]):
		self.tag = tag
		self.attrs = attrs
		self.children = children
	func get_attr(name: String) -> String:
		return attrs.get(name)
	func add_child(el: Element):
		self.children.push_back(el)
var file: String
var _parser: XMLParser

func new(file: String):
	self.file = file
	_parser = XMLParser.new()
	_parser.open(self.file)

func parse_single_element():
	var afterFirst: bool = false
	var children = []
	while _parser.read() != ERR_FILE_EOF:
		if _parser.get_node_type() == XMLParser.NODE_ELEMENT:
			if afterFirst:
				var childEl = parse_single_element()
				children.push(childEl)
			var nName: String = _parser.get_node_name()
			var attrDict = {}
			for idx in range(_parser.get_attribute_count()):
				attrDict[_parser.get_attribute_name(idx)] = _parser.get_attribute_value(idx)
			var el = Element.new(nName, attrDict, [])
	
