extends VirtualKeyBase
class_name VirtualShift

@export var is_caps: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	var keyboard = _get_virtual_keyboard()
	if !keyboard:
		return
	
	if is_caps:
		button_down.connect(_get_virtual_keyboard()._on_caps_pressed)
	else:
		button_down.connect(_get_virtual_keyboard()._on_shift_pressed)
