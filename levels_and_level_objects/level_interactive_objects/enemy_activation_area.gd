extends Area2D


func _ready():
	self.body_entered.connect(_on_body_entered)
	
func _process(delta):
	position = _get_viewport_center()


func _get_viewport_center() -> Vector2:
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	var pos = (-transform.origin / scale + get_viewport_rect().size / scale / 2)
	var pos_adj_x = 241
	var pos_adj_y = 135
	pos.x += pos_adj_x
	pos.y += pos_adj_y
	return pos


func _on_body_entered(body) -> void:
	if body is Enemy:
		body.activate()
