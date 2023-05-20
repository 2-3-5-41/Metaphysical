extends Node3D
class_name GrabberComponent

signal release(grabber: GrabberComponent)

enum Grab {
	COLLECTION,
	CLOSEST,
	REMOTE,
}

@onready var cast: ShapeCast3D = get_parent()

@export var grab_style: Grab = Grab.CLOSEST
@export var grab_action: String = "grip_click"

var throwables: Array[Throwable]
var closest_throwable: Throwable

var _controller: XRController3D

func _ready() -> void:
	_controller = XRUtils.get_controller(self)
	if _controller:
		_controller.button_pressed.connect(_on_controller_button_pressed)
		_controller.button_released.connect(_on_controller_button_released)

func _physics_process(_delta: float) -> void:
	if throwables.size() > 0: throwables.clear()
	if closest_throwable:
		closest_throwable = null

	if cast:
		var count: int = cast.get_collision_count()

		for i in count:
			var object: Node = cast.get_collider(i)
			if object is Throwable:
				throwables.append(object)

	# Get closest throwable
	if throwables.size() > 0:
		var closest: Throwable = throwables[0]
		var distance: float = self.global_position.distance_to(closest.global_position)

		for object in throwables:
			var new_distance: float = self.global_position.distance_to(object.global_position)
			if new_distance < distance:
				closest = object
				distance = new_distance
		closest_throwable = closest

func _on_controller_button_pressed(button: String) -> void:
	if button != grab_action: return
	if not throwables.size() > 0: return
	handle_grab()

func _on_controller_button_released(button: String) -> void:
	if button != grab_action: return
	emit_signal("release", self)

func handle_grab(force: Grab = grab_style) -> void:
	match force:
		Grab.COLLECTION:
			_grab_collection()
		Grab.CLOSEST:
			_grab_closest()
		Grab.REMOTE:
			return

func _grab_collection() -> void:
	for obj in throwables:
		if obj.grab(self):
			self.release.connect(obj.release)

func _grab_closest() -> void:
	if closest_throwable.grab(self):
		self.release.connect(closest_throwable.release)
