@tool
extends ParallaxLayer

func _ready() -> void:
	self.child_entered_tree.connect(on_child_entering_tree)
	for child in self.get_children():
		child.use_parent_material = true


func on_child_entering_tree(child) -> void:
	if Engine.is_editor_hint():
		child.use_parent_material = true
		
