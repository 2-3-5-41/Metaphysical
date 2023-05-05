extends Node
class_name GrabEventSystem

var current_grab : PhysicsBody3D
var offset_grab_point : Vector3

# Dangerously ambiguous variable.
# Just make sure the 'primary_grabber' at minimum has a 'get_grab_follow_point()` getter.
var primary_grabber

func _physics_process(delta: float) -> void:
	if !current_grab || !primary_grabber: return
	var follow = primary_grabber.get_grab_follow_point()
	current_grab.global_position = follow + offset_grab_point

func _on_grabbed_object(grabber, obj: PhysicsBody3D) -> void:
	if grabber != primary_grabber:
		return # TODO: Make new grabber behave as scaling hand.
	primary_grabber = grabber
	current_grab = obj
	offset_grab_point = obj.global_position - grabber.get_grab_follow_point()

func _on_released_object(grabber) -> void:
	if grabber != primary_grabber: return
	primary_grabber = null
	current_grab = null
