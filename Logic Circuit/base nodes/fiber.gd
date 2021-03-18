extends Line2D
var source=null
var target=null
func _process(_delta):
	#$TextureButton.rect_size.x=self.points[1].length()
	#$TextureButton.rect_rotation=self.points[0].angle_to(self.points[1])*2*PI
	#$TextureButton.rect_size.y=6
	if source!=null and target!=null:
		$Light.points[self.points.size()-1]=self.points[self.points.size()-1]
		if self.points[self.points.size()-1].length()!=(source.rect_global_position-target.rect_global_position).length():
			 self.points[self.points.size()-1]=(source.rect_global_position-target.rect_global_position)
func _ready():
	
	
	if source!=null and target!=null:
		$Light.visible=true
		$TextureButton.rect_rotation=self.points[0].angle_to(self.points[1])*2*PI
	for p in self.points:
		$Light.add_point(p)
func _on_TextureButton_pressed():
	pass # Replace with function body.

func SetColor(state):
	if state:
		$Light.set_default_color(Color("#ffff8d"))
	else:
		$Light.set_default_color(Color("#141414"))
