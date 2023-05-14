extends CharacterBody3D

@export var xr_origin: Node3D
@export var camera: Node3D
@export var neck: Node3D

@export_group("Left Hand")
@export var left_hand: XRController3D
@export var left_action: String = "primary"

@export_group("Right Hand")
@export var right_hand: XRController3D
@export var right_action: String = "primary"

@export_group("Locomotion Settings")
@export var max_height: float = 2
@export var min_height: float = 0.3
@export var head_height: float = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var colliding: bool = _process_physical_movement(delta)
	if colliding: return

	_process_height()
	_process_rotation_on_input(delta)
	_process_movement_on_input(delta)

func _process_physical_movement(delta: float) -> bool:
	var current_velocity = velocity

	var camera_basis: Basis = xr_origin.transform.basis * camera.transform.basis
	var forward: Vector2 = Vector2(camera_basis.z.x, camera_basis.z.z)
	var angle: float = forward.angle_to(Vector2(0,1))

	# Rotate our rigid body
	transform.basis = transform.basis.rotated(Vector3.UP, angle)

	# Invert rotation to xr origin
	xr_origin.transform = Transform3D().rotated(Vector3.UP, -angle) * xr_origin.transform

	# Apply linear movement
	# First, move PlayerBody to correct locataion
	var player_body_origin: Vector3 = global_transform.origin
	var player_phys_location: Vector3 = xr_origin.transform * camera.transform * neck.transform.origin
	player_phys_location.y = 0
	player_phys_location = global_transform * player_phys_location

	velocity = (player_phys_location - player_body_origin) / delta
	move_and_slide()

	# Next, move the XROrigin back
	var delta_movement = global_transform.origin - player_body_origin
	xr_origin.global_transform.origin -= delta_movement

	# Return our velocity
	velocity = current_velocity

	if (player_phys_location - global_transform.origin).length() > 0.01:
		return true
	return false

func _process_height() -> void:
	var height: float = clamp(camera.transform.origin.y + head_height, min_height, max_height)
	$CollisionShape3D.get_shape().set_height(height)
	$CollisionShape3D.transform.origin.y = height / 2

func _get_rotation_input() -> float:
	return -right_hand.get_vector2(left_action).x

func _get_move_input() -> Vector2:
	var input: Vector2 = left_hand.get_vector2(right_action)
	input.y = -input.y

	return input

func _process_rotation_on_input(delta):
	rotation.y += _get_rotation_input() * delta

func _process_movement_on_input(delta):
	var movement_input = _get_move_input()

	var direction = global_transform.basis * Vector3(movement_input.x, 0, movement_input.y)
	if direction:
		velocity.x = direction.x
		velocity.z = direction.z
	else:
		velocity.x = move_toward(velocity.x, 0, delta)
		velocity.z = move_toward(velocity.z, 0, delta)

	move_and_slide()
