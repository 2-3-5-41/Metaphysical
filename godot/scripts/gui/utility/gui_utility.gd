extends Node
class_name GUIUtility

static func get_sub_viewport(start_node: Control) -> SubViewport:
	var node = start_node
	
	while node:
		if node is SubViewport:
			return node
		
		node = node.get_parent()
	
	return null
