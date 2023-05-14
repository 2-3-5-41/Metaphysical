extends VirtualKeyBase
class_name VirtualKey

@export var key_text: String = ""
@export var lower_unicode: int = 0
@export var upper_unicode: int = 0

func get_key_code() -> int:
	return upper_unicode if _keyboard._are_we_shifting() else lower_unicode

func _send_key_input() -> void:
	_keyboard._process_key_press(self)
