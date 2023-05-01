extends GUI3D
class_name VirtualKeyboard

@export var active_viewport: SubViewport

var shift_mod: bool = false
var caps_lock: bool = false

func _ready():
	visible = false

func _start_editing(value: bool):
	visible = value

func _on_key_pressed(text: String, unicode: int):
	var scan_code = OS.find_keycode_from_string(text)
	
	var input = InputEventKey.new()
	input.physical_keycode = scan_code
	input.unicode = unicode if unicode else scan_code
	input.pressed = true
	input.keycode = scan_code
	input.shift_pressed = shift_mod if !caps_lock else caps_lock
	
	print(input, "\n", text, "\n", unicode, "\n")
	
	# Dispatch the input event
	if active_viewport:
		active_viewport.push_input(input)
	
	shift_mod = false

func _on_shift_pressed():
	shift_mod = true

func _on_caps_pressed():
	caps_lock = !caps_lock
