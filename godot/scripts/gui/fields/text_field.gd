extends TextEdit
class_name TextField

func _ready():
	focus_entered.connect(_open_keyboard)
	focus_exited.connect(_close_keyboard)

func _open_keyboard():
	var local_space = get_tree().get_nodes_in_group("local_space")
	for node in local_space:
		if node is VirtualKeyboard:
			node._start_editing(true)
			return

func _close_keyboard():
	var local_space = get_tree().get_nodes_in_group("local_space")
	for node in local_space:
		if node is VirtualKeyboard:
			node._start_editing(false)
			return
