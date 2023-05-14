extends Control
class_name EditableField

func _get_sub_viewport() -> SubViewport:
	var start = self

	while start:
		if start is SubViewport:
			return start

		start = start.get_parent()

	return null

func _ready() -> void:
	focus_entered.connect(_open_keyboard)
	focus_exited.connect(_close_keyboard)

func _open_keyboard() -> void:
	var local_space_group = get_tree().get_nodes_in_group("local_space")
	for node in local_space_group:
		if node is VirtualKeyboard:
			node.start_editing(_get_sub_viewport())

func _close_keyboard() -> void:
	var local_space_group = get_tree().get_nodes_in_group("local_space")
	for node in local_space_group:
		if node is VirtualKeyboard:
			node.stop_editing()
