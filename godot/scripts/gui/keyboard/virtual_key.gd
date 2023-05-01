extends VirtualKeyBase
class_name VirtualKey

@export var key_text: String = ""
@export var lower_case_unicode: int = 0
@export var shift_mod_unicode: int = 0
var _key_code: int
var _keyboard: VirtualKeyboard

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	_keyboard = _get_virtual_keyboard()
	
	if _keyboard:
		button_down.connect(_send_key_input)

func _process(_delta):
	var shift_mod: bool = _keyboard.shift_mod || _keyboard.caps_lock
	_key_code = shift_mod_unicode if shift_mod else lower_case_unicode

func _send_key_input():
	_keyboard._on_key_pressed(key_text, _key_code)
