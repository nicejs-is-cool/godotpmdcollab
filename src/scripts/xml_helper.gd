extends Node

## Converts an XML string into a structured Godot Dictionary
func xml_to_dictionary(xml_string: String) -> Dictionary:
	var parser: XMLParser = XMLParser.new()
	var error = parser.open_buffer(xml_string.to_utf8_buffer())
	
	if error != OK:
		push_error("Failed to parse XML string. Error code: ", error)
		return {}
		
	var root: Dictionary = {"name": "root", "children": []}
	var node_stack: Array = [root]
	
	while parser.read() == OK:
		var node_type = parser.get_node_type()
		
		match node_type:
			XMLParser.NODE_ELEMENT:
				var element_name = parser.get_node_name()
				var attributes = {}
				
				# Extract element attributes
				for i in range(parser.get_attribute_count()):
					attributes[parser.get_attribute_name(i)] = parser.get_attribute_value(i)
				
				var new_node = {
					"name": element_name,
					"attributes": attributes,
					"children": [],
					"content": ""
				}
				
				# Add as a child to the current top of the stack
				node_stack[-1]["children"].append(new_node)
				
				# Check if it's an empty self-closing element (e.g., <item />)
				if not parser.is_empty():
					node_stack.append(new_node)
					
			XMLParser.NODE_ELEMENT_END:
				if node_stack.size() > 1:
					node_stack.pop_back()
					
			XMLParser.NODE_TEXT:
				var text = parser.get_node_data().strip_edges()
				if not text.is_empty():
					node_stack[-1]["content"] = text
					
	return root["children"][0] if not root["children"].is_empty() else {}
