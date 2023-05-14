extends Node
class_name GuiLaserComponent

@export var visual_instance: LaserLineMesh
@export var lerp_speed: float = 16

var _ray: RayCast3D
var _smooth_hit: Vector3
var _last_hit: Vector3
var _exited_gui: bool = false

func _ready() -> void:
	if not get_parent() or not get_parent() is RayCast3D:
		push_error(self, " can't work if not under a RayCast3D!")
		return
	else:
		_ray = get_parent()

	var controller = XRUtils.get_controller(self)
	if controller and controller is XRHand:
		controller.trigger_pulled.connect(_on_trigger_pull)
		controller.trigger_released.connect(_on_trigger_release)

func _physics_process(delta: float) -> void:
	if not _ray: return

	var hit: Vector3 = _ray.get_collision_point()
	var hit_obj: GuiBody3D = _ray.get_collider()

	if not hit_obj:
		if not _exited_gui:
			GuiEventSystem.on_exited_gui()
			_exited_gui = true

		visual_instance.visible = false
		return
	else:
		if !visual_instance.visible:
			visual_instance.visible = true

	if hit_obj and _exited_gui:
		GuiEventSystem.on_entered_gui(hit_obj)
		_exited_gui = false
		_smooth_hit = hit
	else:
		_smooth_hit = _smooth_hit.lerp(hit, delta * lerp_speed)

	GuiEventSystem.handle_laser_moved(self, _last_hit, _smooth_hit)

	# Update laser visual curve
	var curve_tangent: Vector3 = Vector3(0,0,_ray.global_position.distance_to(_smooth_hit) / 2)
	visual_instance.update_curve(Vector3.ZERO, -curve_tangent, _ray.to_local(_smooth_hit))

func _on_trigger_pull() -> void:
	GuiEventSystem.handle_laser_input_pressed(self, _smooth_hit)

func _on_trigger_release() -> void:
	GuiEventSystem.handle_laser_input_released(_smooth_hit)
