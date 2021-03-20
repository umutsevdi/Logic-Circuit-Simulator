extends Line2D
var source=null
var target=null
func _process(_delta):
	if source!=null and target!=null:
		$Light.points[self.points.size()-1]=self.points[self.points.size()-1]
		if self.points[self.points.size()-1].length()!=(source.rect_global_position-target.rect_global_position).length():
			 self.points[self.points.size()-1]=(source.rect_global_position-target.rect_global_position)

func _ready():
	if source!=null and target!=null:
		$Light.visible=true
	for p in self.points:
		$Light.add_point(p)
		
func SetColor(state):
	if state:
		$Light.set_default_color(Color("#ffff8d"))
	else:
		$Light.set_default_color(Color("#141414"))
