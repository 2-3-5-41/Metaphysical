class_name XRUtils

static func get_controller(node: Node) -> XRController3D:
	var parent = node.get_parent()
	while not parent is XRController3D:
		parent = parent.get_parent()
	return parent

static func get_xr_camera(node: Node) -> XRCamera3D:
	var group = node.get_tree().get_nodes_in_group("local_space")
	for n in group:
		if n is XRCamera3D:
			return n
	return null
