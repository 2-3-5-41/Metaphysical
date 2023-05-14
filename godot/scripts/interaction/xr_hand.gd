extends XRController3D
class_name XRHand

signal trigger_pulled
signal trigger_released

@export var trigger_pull_weight: float = 0.16

var _trigger_pull_action: String = "trigger"
var _trigger_pulled: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_trigger_pull()

func _handle_trigger_pull() -> void:
	var _trigger_pull = get_float(_trigger_pull_action)
	if _trigger_pull >= trigger_pull_weight && !_trigger_pulled:
		emit_signal("trigger_pulled")
		_trigger_pulled = true
	if _trigger_pull <= (trigger_pull_weight - 0.1) && _trigger_pulled:
		emit_signal("trigger_released")
		_trigger_pulled = false
