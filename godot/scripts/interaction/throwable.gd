extends RigidBody3D
class_name Throwable

@onready var _init_linear_damp: float = self.get_linear_damp()
@onready var _init_angular_damp: float = self.get_angular_damp()

@export var settings: ThrowableSettings

var _grabber: GrabberComponent
var _offhand_grabber: GrabberComponent

func grab(node: GrabberComponent) -> bool:
	if !_grabber:
		_grabber = node

		set_linear_damp(settings.grab_linear_damp)
		set_angular_damp(settings.grab_angular_damp)

		return true
	elif settings.allow_two_hands:
		_offhand_grabber = node
		return true

	return false

func release(node: GrabberComponent) -> void:
	if node == _grabber:
		if not _offhand_grabber:
			_grabber = null
			_reset_dampers()
		else:
			_grabber = _offhand_grabber
			_offhand_grabber = null
	else:
		_offhand_grabber = null

	# Disconnect signal
	if node.is_connected("release", self.release):
		node.disconnect("release", self.release)

func _reset_dampers() -> void:
	set_linear_damp(_init_linear_damp)
	set_angular_damp(_init_angular_damp)

func _physics_process(_delta: float) -> void:
	if _grabber && _offhand_grabber:
		var _center_grab_position: Vector3 = _grabber.global_transform.origin.lerp(_offhand_grabber.global_transform.origin, 0.5)

		# Apply linear force to center rigidbody to grabber.
		var _linear_force: Vector3 = _center_grab_position - self.global_transform.origin
		apply_central_force(_linear_force * (settings.grab_strength * settings.dual_grab_strength_multiplier))
		return

	if _grabber:
		# Apply linear force to center rigidbody to grabber.
		var _linear_force: Vector3 = _grabber.global_transform.origin - self.global_transform.origin
		apply_central_force(_linear_force * settings.grab_strength)

		# Apply angular torque to rotate rigidbody to grabber orientation.
		var _quat_a: Quaternion = Quaternion(_grabber.global_transform.basis)
		var _quat_b: Quaternion = Quaternion(self.global_transform.basis)

		var _torque: Vector3 = (_quat_a * _quat_b.inverse()).get_euler()
		apply_torque(_torque)
		return
