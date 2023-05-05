extends GUI3D
class_name VirtualKeyboard

var active_viewport: SubViewport

var shift_mod: bool = false
var caps_lock: bool = false

func _ready():
	visible = false
	super()

func _process(_delta):
	visible = true if active_viewport else false
	super(_delta)

func _start_editing(sub_viewport: SubViewport):
	if viewport:
		active_viewport = sub_viewport
	else:
		push_warning(self, " Can't use keyboard with `null` `viewport`")
		active_viewport = null

func _stop_editing():
	if active_viewport:
		active_viewport = null

func _on_key_pressed(text: String, unicode: int):
	if !active_viewport:
		return

	var scan_code = OS.find_keycode_from_string(text)

	var input = InputEventKey.new()
	input.physical_keycode = scan_code
	input.unicode = unicode if unicode else scan_code
	input.pressed = true
	input.keycode = scan_code
	input.shift_pressed = shift_mod if !caps_lock else caps_lock

	# Dispatch the input event
	active_viewport.push_input(input)

	shift_mod = false

func _on_shift_pressed():
	shift_mod = true

func _on_caps_pressed():
	caps_lock = !caps_lock
