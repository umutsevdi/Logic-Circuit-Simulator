extends Camera2D
var base_loc=Vector2.ZERO
func _physics_process(delta):
	UIHandler.mouse_position=get_global_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		base_loc=get_global_mouse_position()
	elif Input.get_action_strength("right_click"):
		self.position+=(base_loc-self.position)*5*delta
	if Input.is_action_just_released("zoom_in"):
		self.zoom.x += 0.25
		self.zoom.y += 0.25
	if Input.is_action_just_released("zoom_out") and self.zoom.x > 0.25 and self.zoom.y > 0.25:
		self.zoom.x -= 0.25
		self.zoom.y -= 0.25

