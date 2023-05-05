extends Node3D

@export var display: MeshInstance3D
@export var radius: float = 1
@export var spin: bool = true

@export_range(0,360) var point_on_circle: float = 0

var spin_var: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !spin:
		display.position = Circles.get_point_on_circle(1, point_on_circle, Circles.CircleAlign.Y)
	else:
		spin_var += delta
		display.position = Circles.get_point_on_circle(1, spin_var * 32, Circles.CircleAlign.Y)
