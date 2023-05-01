extends Node
class_name StartupGUISpawner

@export var startup_gui: PackedScene
@export var gui_3d: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var gui = gui_3d.instantiate()
	call_deferred("add_sibling", gui)
	
	gui.insert_prefab_gui(startup_gui)
	gui.set_resolution(Vector2(1024, 512))
	gui.set_global_position(Vector3(0,1,-4))
