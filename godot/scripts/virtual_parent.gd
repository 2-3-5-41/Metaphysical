extends RemoteTransform3D
class_name VirtualParent

@export var _parent_when_ready: NodePath

func set_child(node: NodePath) -> void:
	_parent_when_ready = node

func _ready() -> void:
	global_transform = get_node(_parent_when_ready).global_transform
	set_remote_node(_parent_when_ready)
