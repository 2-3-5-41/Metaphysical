extends Button
class_name VirtualKeyBase

func _ready():
	focus_mode = Control.FOCUS_NONE

func _get_virtual_keyboard() -> VirtualKeyboard:
	var node = get_parent()
	
	while node:
		if node is VirtualKeyboard:
			return node
		
		node = node.get_parent()
	
	return null
