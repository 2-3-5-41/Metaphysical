class_name XRUtils

static func get_controller(node: Node) -> XRController3D:
	var parent = node.get_parent()
	while not parent is XRController3D:
		parent = parent.get_parent()
	return parent
