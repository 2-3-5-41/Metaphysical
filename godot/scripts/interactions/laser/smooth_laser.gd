extends RayCast3D
class_name XRLaser

signal grabbed_object(laser, obj)
signal released_object(laser)
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

@onready var laser_path: Path3D = $Path3D

@export_group("Laser Interaction")
@export var controller: XRController3D
@export var grip_action: String = "grip_click"
@export var gui_action: String = "trigger_click"

@export_group("Lerp Performance")
@export var lerp_speed: float = 10.0

var active_laser: LaserType
var prev_laser: LaserType

var is_grabbing: bool
var distance_to_obj: float

var active_hit_object: StaticBody3D
var prev_hit_object: StaticBody3D

var raw_hit_point: Vector3
var smooth_hit_point: Vector3
var prev_hit_point: Vector3

func _ready():
	controller.connect("button_pressed", _handle_controller_input_press)
	controller.connect("button_released", _handle_controller_input_release)

func _physics_process(delta):
	active_hit_object = get_collider()
	
	if !active_hit_object:
		active_laser = LaserType.DEFAULT
	
	if active_hit_object is GUI3D && !is_grabbing:
		active_laser = LaserType.GUI
	
	if is_grabbing:
		active_laser = LaserType.GRAB
	
	_update_pointer(delta)
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
			raw_hit_point = to_global(-basis.z * distance_to_obj)
	
	# Update smooth hit point.
	if active_hit_object != prev_hit_object:
		smooth_hit_point = raw_hit_point
	else:
		smooth_hit_point = smooth_hit_point.lerp(raw_hit_point, delta * lerp_speed)
		
	$MeshInstance3D.global_position = smooth_hit_point

func _update_gui_pointer():
	if active_laser != LaserType.GUI:
		if prev_hit_object is GUI3D:
			emit_signal("gui_exited", self)
		return
	
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
