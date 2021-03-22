extends Node
var node
var hold=false
var time=0
var grid_value=0
var old_position=Vector2.ZERO
var old_rotation=0

var create=false
func _process(delta):
	time+=delta
	if node!=null:
		if hold:
			node.get_node("Gate").rect_rotation=sin(time*2.5)*5
			if grid_value==0:
				node.position=UIHandler.mouse_position
			else:
				node.position.x=int(UIHandler.mouse_position.x/grid_value)*grid_value
				node.position.y=int(UIHandler.mouse_position.y/grid_value)*grid_value
			
			if Input.is_action_just_pressed("right_click"):
				MoveEnd(old_position)
		else:
			MoveEnd(node.global_position)
				
func MoveStart(order):
	create=order
	hold=true
	node=UIHandler.selected_node
	old_position=node.global_position
	if create==false:
		old_rotation=0
	else:
		old_rotation=node.get_node("Gate").rect_rotation
	node.modulate.a=0.3
	node.position=Vector2(0,0)
	set_process(true)
	
func MoveEnd(_position):
	set_process(false)
	node.modulate.a=1
	node.global_position=_position
	node.get_node("Gate").rect_rotation=old_rotation
	if old_position==_position and create:
		UIHandler.delete_node()
	else:
		if UIHandler.selected_node.TYPE=="Variable" or UIHandler.selected_node.TYPE=="Clock" or UIHandler.selected_node.TYPE=="Label" or UIHandler.selected_node.TYPE=="Output":
			UIHandler.CreateUI_variable(UIHandler.selected_node)
		else:
			UIHandler.CreateUI(UIHandler.selected_node)
		
		
		
