extends Node
class_name NodePool

@export var node_scene: PackedScene
var cached_nodes: Array[Node2D]

func create_new():
	var node = node_scene.instantiate()
	get_tree().get_root().add_child.call_deferred(node)
	cached_nodes.append(node)
	return node
	
func spawn():
	for node in cached_nodes:
		if node.visible == false:
			node.visible = true
			return node
	
	return create_new()
