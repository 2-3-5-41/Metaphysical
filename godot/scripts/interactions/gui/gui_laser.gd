extends RayCast3D
class_name GUILaser

signal laser_entered_gui(gui)
signal laser_exited_gui
signal laser_moved(laser, point, prev_point)
signal laser_button_pressed(laser, point)
signal laser_button_released(laser, point)

@export var ui_interact_action: String = "trigger_click"

@onready var controller: XRController3D = $".."

var target_gui: GUI3D
var prev_hit: Vector3

#----------------------------------------
# One shot vars
#----------------------------------------
var ui_interacted: bool = false

#----------------------------------------
# Rutime
#----------------------------------------
func _ready():
	controller.connect("button_pressed", _handle_button_pressed)
	controller.connect("button_released", _handle_button_released)

func _process(_delta):
	if !self.is_colliding():
		if target_gui == null:
			return
		
		target_gui = null
		emit_signal("laser_exited_gui")
		
		return
	
	var hit = self.get_collider()
	
	if hit is GUI3D:
		target_gui = hit
		emit_signal("laser_entered_gui", hit)
	else: 
		return
	
	_handle_pointer_moved()

func _handle_pointer_moved():
	var point = self.get_collision_point()
	
	emit_signal("laser_moved", self, point, prev_hit)
	
	prev_hit = point

func _handle_button_pressed(button: String):
	if button != ui_interact_action:
		return
	if !target_gui:
		push_warning("can't send 'button_pressed' event to `null` `target_gui`")
		return
	
	emit_signal("laser_button_pressed", self, self.get_collision_point())

func _handle_button_released(button: String):
	if button != ui_interact_action:
		return
	if !target_gui:
		push_warning("can't send 'button_pressed' event to `null` `target_gui`")
		return
	
	emit_signal("laser_button_released", self, self.get_collision_point())