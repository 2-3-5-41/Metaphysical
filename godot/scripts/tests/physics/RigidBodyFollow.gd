extends Marker3D

@export var body: RigidBody3D
@export var follow_strength: float = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var follow: Vector3 = global_position - body.global_position
	body.apply_central_force(follow * follow_strength)
