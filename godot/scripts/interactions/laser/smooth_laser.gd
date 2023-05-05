extends RayCast3D
class_name XRLaser

signal grabbed_object(grabber, obj)
signal released_object(grabber)

signal gui_entered(laser, gui)
signal gui_exited(laser)
signal gui_button_pressed(laser, point)
signal gui_button_released(laser, point)
signal gui_pointer_moved(laser, before, after)

enum LaserType {
	DEFAULT,
	GUI,
	GRAB
}

@onready var curve :Curve3D = Curve3D.new()

@export_group("Laser Interaction")
@export var controller: XRController3D
@export var grip_action: String = "grip_click"
@export var gui_action: String = "trigger_click"
@export var grab_point_adjust_action: String = "primary"

@export_group("Lerp Performance")
@export var lerp_speed: float = 10.0

@export_group("Grab Adjust Performance")
@export var adjust_speed: float = 5.0

var active_laser: LaserType
var prev_laser: LaserType

var is_grabbing: bool
var distance_to_obj: float

var active_hit_object: StaticBody3D
var prev_hit_object: StaticBody3D

var raw_hit_point: Vector3
var smooth_hit_point: Vector3
var prev_hit_point: Vector3

func get_grab_follow_point() -> Vector3:
	return smooth_hit_point

func _ready():
	controller.connect("button_pressed", _handle_controller_input_press)
	controller.connect("button_released", _handle_controller_input_release)

	curve.call_deferred("add_point", Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, 0)
	curve.call_deferred("add_point", Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, 1)

func _physics_process(delta):
	active_hit_object = get_collider()

	if !active_hit_object:
		if prev_hit_object is GUI3D:
			emit_signal("gui_exited", self)
		active_laser = LaserType.DEFAULT

	if active_hit_object is GUI3D && !is_grabbing:
		active_laser = LaserType.GUI

	if is_grabbing:
		active_laser = LaserType.GRAB

	_update_pointer(delta)
	_update_path()
	_update_gui_pointer()

	prev_laser = active_laser
	prev_hit_point = smooth_hit_point
	prev_hit_object = active_hit_object

func _update_pointer(delta: float):
	match active_laser:
		LaserType.DEFAULT:
			raw_hit_point = to_global(target_position)
		LaserType.GUI:
			raw_hit_point = get_collision_point()
		LaserType.GRAB:
			raw_hit_point = _update_grabbed_point(delta)

	# Update smooth hit point.
	if active_hit_object != prev_hit_object && active_laser != LaserType.GRAB:
		smooth_hit_point = raw_hit_point
	else:
		smooth_hit_point = smooth_hit_point.lerp(raw_hit_point, delta * lerp_speed)

func _update_grabbed_point(delta: float) -> Vector3:
	var adjust_input = controller.get_vector2(grab_point_adjust_action).y
	distance_to_obj += adjust_input * delta * adjust_speed
	return to_global(-basis.z * distance_to_obj)

func _update_path():
	if !curve:
		print("What the fuck?")
		return

	var half_distance : float = (raw_hit_point - global_position).length() / 2
	var path_curve : Vector3 = Vector3(0, 0, -half_distance)

	curve.set_point_position(1, to_local(smooth_hit_point))
	curve.set_point_out(0, path_curve)

func _update_gui_pointer():
	if active_laser != LaserType.GUI: return

	if active_hit_object != prev_hit_object:
		emit_signal("gui_entered", self, active_hit_object)

	emit_signal("gui_pointer_moved", self, prev_hit_point, smooth_hit_point)

## Connect to controller signal for "button_pressed"
func _handle_controller_input_press(button: String):
	match button:
		grip_action:
			_grip_pressed()
		gui_action:
			_gui_pressed()

func _grip_pressed():
	if !active_hit_object: return

	distance_to_obj = (get_collision_point() - global_position).length()
	is_grabbing = true

	emit_signal("grabbed_object", self, active_hit_object)

func _gui_pressed():
	if !active_hit_object: return
	if active_laser != LaserType.GUI: return

	emit_signal("gui_button_pressed", self, smooth_hit_point)

## Connect to controller signal for "button_released"
func _handle_controller_input_release(button: String):
	match button:
		grip_action:
			_grip_released()
		gui_action:
			_gui_released()

func _grip_released():
	if active_laser != LaserType.GRAB: return

	is_grabbing = false
	emit_signal("released_object", self)

func _gui_released():
	emit_signal("gui_button_released", self, smooth_hit_point)
