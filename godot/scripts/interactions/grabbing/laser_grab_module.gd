extends Node
class_name LaserGrabModule

signal grabbed(laser, grabbable)
signal released(laser)

@export_group("Controller Interactions")
@export var grabbing_input: String = "grip_click"
@export var adjust_input: String = "primary"
@export var adjust_deadzone: float = 0.2

@export_group("Lerp performance")
@export var lerp_speed: float = 8.0

@export_group("Adjust performance")
@export var adjust_speed: float = 5.0

@onready var laser: RayCast3D = $".."
@onready var controller: XRController3D = $"../.."

var grabbing: bool
var distance_to_grabbed: float
var hit_object: StaticBody3D
var prev_object: StaticBody3D
var hit_pos: Vector3

func _ready():
	if controller:
		controller.connect("button_pressed", _handle_controller_button_pressed)
		controller.connect("button_released", _handle_controller_button_released)

func _physics_process(delta):
	hit_object = laser.get_collider()
	
	_position_ref_point(delta)

	prev_object = hit_object

func _handle_controller_button_pressed(input: String):
	if input != grabbing_input: return
	if !hit_object: return
	
	distance_to_grabbed = (hit_object.global_position - laser.global_position).length()
	grabbing = true
	
	emit_signal("grabbed", self, hit_object)

func _handle_controller_button_released(input: String):
	if input != grabbing_input: return
	
	grabbing = false
	
	emit_signal("released", self)

func _position_ref_point(delta: float):
	var point: Vector3
	
	if !grabbing:
		if !hit_object:
			point = laser.to_global(laser.target_position)
		elif hit_object != prev_object:
			hit_pos = laser.to_global(-laser.basis.z * (hit_object.global_position - laser.global_position).length())
		else:
			point = laser.to_global(-laser.basis.z * (hit_object.global_position - laser.global_position).length())
	else:
		_adjust_distance(delta)
		point = laser.to_global(-laser.basis.z * distance_to_grabbed)
	
	hit_pos = hit_pos.lerp(point, delta * lerp_speed)

func _adjust_distance(delta: float):
	var adjust_vector = controller.get_vector2(adjust_input).y
	distance_to_grabbed += adjust_vector * (delta * adjust_speed)
