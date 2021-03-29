extends Node2D
export var on = true
func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color("50ffffff"), false)
	var grid=get_node("CanvasLayer/GridSeperator").value
	if on and grid!=0: 
		var size = get_viewport_rect().size  * get_node("Camera2D").zoom / 2
		var cam = get_node("Camera2D").position
		for i in range(int((cam.x - size.x) / grid) - 1, int((size.x + cam.x) / grid) + 1):
			draw_line(Vector2(i * grid, cam.y + size.y + 100), Vector2(i * grid, cam.y - size.y - 100), "50ffffff")
		for i in range(int((cam.y - size.y) / grid) - 1, int((size.y + cam.y) / grid) + 1):
			draw_line(Vector2(cam.x + size.x + 100, i * grid), Vector2(cam.x - size.x - 100, i * grid), "50ffffff")

var dragging = false  # Are we currently dragging?
var selected = {}  # Array of currently selected units.
var drag_start = Vector2.ZERO  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if selected.size() == 0:
				dragging = true
				drag_start = UIHandler.mouse_position
			else:
				SelectionEffect(false)
			
		# Button released while dragging.
		elif dragging:
			dragging = false
			update()
			var drag_end = event.position
			select_rect.extents = (drag_end - drag_start) / 2
			for i in Database.GetCurrentTab().get_children():
				if i.position.x in range(drag_start.x,drag_end.x) and i.position.y in range(drag_start.y,drag_end.y):
					selected[i.name]={"Node":i,"Position":i.position}
			SelectionEffect(true)
			#selected=[]

	if event is InputEventMouseMotion and dragging:
		update()
func SelectionEffect(selecting):
	get_node("CanvasLayer/Label").text="Selected:"
	if selecting:
		for item in selected.keys():
			selected[item]={"Node":selected[item].Node,"Position":selected[item].Node.position}
			get_node("CanvasLayer/Label").text+="\n="+item+ str(selected[item].Node.position)
			selected[item].Node.modulate.a=0.4
	else:
		for item in selected.keys():
			selected[item].Node.modulate.a=1
		selected.clear()
