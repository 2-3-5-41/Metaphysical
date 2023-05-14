extends VirtualKeyBase
class_name VirtualShift

@export var caps_mod: bool = false

func _ready() -> void:
	set_focus_mode(Control.FOCUS_NONE)
	_keyboard = VirtualKeyboard.get_virtual_keyboard(self)

	if caps_mod:
		button_down.connect(_keyboard.toggle_capslock)
	else:
		button_down.connect(_keyboard.toggle_shift)
