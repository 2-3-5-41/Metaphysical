extends Gui3D
class_name VirtualKeyboard

enum ShiftMod {
	NONE,
	SHIFT,
	CAPSLOCK,
}

var active_viewport: SubViewport
var shift: ShiftMod = ShiftMod.NONE

func _process_key_press(key: VirtualKey) -> void:
	if active_viewport:
		var scan_code = OS.find_keycode_from_string(key.key_text)

		var input = InputEventKey.new()
		input.physical_keycode = scan_code
		input.unicode = key.get_key_code() if key.get_key_code() else scan_code
		input.pressed = true
		input.keycode = scan_code
		input.shift_pressed = _are_we_shifting()
		# Dispatch the input event
		active_viewport.push_input(input)

	_reset_shift()

func _are_we_shifting() -> bool:
	match shift:
		ShiftMod.NONE:
			return false
		ShiftMod.SHIFT:
			return true
		ShiftMod.CAPSLOCK:
			return true

	return false

func start_editing(editable_view: SubViewport) -> void:
	if active_viewport == editable_view || !editable_view: return
	else: active_viewport = editable_view

func stop_editing() -> void:
	if active_viewport: active_viewport = null

func toggle_shift() -> void:
	if shift == ShiftMod.SHIFT:
		shift = ShiftMod.NONE
	else:
		shift = ShiftMod.SHIFT

func toggle_capslock() -> void:
	if shift == ShiftMod.CAPSLOCK:
		shift = ShiftMod.NONE
	else:
		shift = ShiftMod.CAPSLOCK

func _reset_shift() -> void:
	if shift == ShiftMod.CAPSLOCK: return
	shift = ShiftMod.NONE

static func get_virtual_keyboard(node: VirtualKeyBase) -> VirtualKeyboard:
	var start = node.get_parent()

	while start:
		if start is VirtualKeyboard:
			return start

		start = start.get_parent()

	return null
