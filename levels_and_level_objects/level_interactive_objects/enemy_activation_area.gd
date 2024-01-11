extends Area2D


func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)
	
func _process(_delta):
	position = _get_viewport_center()


func _get_viewport_center() -> Vector2:
	var view_transform : Transform2D = get_viewport_transform()
	var view_scale : Vector2 = view_transform.get_scale()
	var pos = (-view_transform.origin / view_scale + get_viewport_rect().size / view_scale / 2)
	var pos_adj_x = 241
	var pos_adj_y = 135
	pos.x += pos_adj_x
	pos.y += pos_adj_y
	return pos


func _on_body_entered(body) -> void:
	if body is Enemy:
		body.activate()
	elif body is Dropper:
		body.activate()

func _on_body_exited(body) -> void:
		if body is Dropper:
			body.deactivate()			

func _on_area_entered(area) -> void:
	if area.owner is WaterSpring:
		area.owner.activate()


func _on_area_exited(area) -> void:
	if area.owner is WaterSpring:
		area.owner.deactivate()
