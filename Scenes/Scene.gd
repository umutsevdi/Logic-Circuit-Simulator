extends Node2D
export var on = true

func _draw():
	var grid=get_node("CanvasLayer/GridSeperator").value
	if on and grid!=0: 
		var size = get_viewport_rect().size  * get_node("Camera2D").zoom / 2
		var cam = get_node("Camera2D").position
		for i in range(int((cam.x - size.x) / grid) - 1, int((size.x + cam.x) / grid) + 1):
			draw_line(Vector2(i * grid, cam.y + size.y + 100), Vector2(i * grid, cam.y - size.y - 100), "50ffffff")
		for i in range(int((cam.y - size.y) / grid) - 1, int((size.y + cam.y) / grid) + 1):
			draw_line(Vector2(cam.x + size.x + 100, i * grid), Vector2(cam.x - size.x - 100, i * grid), "50ffffff")

func _process(_delta):
	update()
