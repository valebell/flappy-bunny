# Utils

extends Node2D

func get_main_node() -> Node:
	var root_node = get_tree().root
	return root_node.get_child(root_node.get_child_count() - 1)
