extends TextEdit
class_name TextField

func _ready():
	focus_entered.connect(_open_keyboard)
	focus_exited.connect(_close_keyboard)

func _open_keyboard():
	var local_space = get_tree().get_nodes_in_group("local_space")
	for node in local_space:
		if node is VirtualKeyboard:
			var viewport := GUIUtility.get_sub_viewport(self)
			
			# Already editing
			if node.active_viewport == viewport:
				return
			
			node._start_editing(viewport)
			return

func _close_keyboard():
	var local_space = get_tree().get_nodes_in_group("local_space")
	for node in local_space:
		if node is VirtualKeyboard:
			# Already stopped editing.
			if node.active_viewport == null:
				return
			
			node._stop_editing()
			return
