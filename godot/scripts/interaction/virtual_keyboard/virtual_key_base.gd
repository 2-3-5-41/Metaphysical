extends Button
class_name VirtualKeyBase

var _keyboard: VirtualKeyboard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_focus_mode(Control.FOCUS_NONE)
	_keyboard = VirtualKeyboard.get_virtual_keyboard(self)

	if _keyboard:
		button_down.connect(_send_key_input)

func _send_key_input() -> void:
	pass
