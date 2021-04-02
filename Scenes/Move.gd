extends Node
var node
var hold=false
var time=0
var grid_value=0
var old_position=Vector2.ZERO
var old_rotation=0
var create=false
var mouse_dist=Vector2.ZERO
var on_group=false
var selected_units
func _process(delta):
	time+=delta
	if node!=null:
		if hold:
			for i in selected_units.keys():
				node.get_node("Gate").rect_rotation=sin(time*2.5)*5
				if grid_value==0:
					selected_units[i].Node.position=UIHandler.mouse_position+mouse_dist+selected_units[i].Position-old_position
				else:
					selected_units[i].Node.position.x=int((UIHandler.mouse_position.x+mouse_dist.x)/grid_value)*grid_value
					selected_units[i].Node.position.y=int((UIHandler.mouse_position.y+mouse_dist.y)/grid_value)*grid_value
					selected_units[i].Node.position+=selected_units[i].Position-old_position
				if Input.is_action_just_pressed("right_click"):
					MoveEnd(old_position)
		else:
			MoveEnd(node.global_position)
				
func MoveStart(order,object):
	on_group=object.name in get_node("/root/Scene").selected.keys()

	UIHandler.selected_node=object
	node=object
	create=order
	hold=true
	
	old_position=node.global_position
	if create:
		old_rotation=0
		mouse_dist=Vector2.ZERO
	else:
		old_rotation=node.get_node("Gate").rect_rotation
		mouse_dist=node.position-UIHandler.mouse_position
	if on_group==false and get_node("/root/Scene").dragging==false:
		get_node("/root/Scene").SelectionEffect(false)
		get_node("/root/Scene").selected[object.name]={"Node":object,"Position":object.position}
		get_node("/root/Scene").SelectionEffect(true)
	selected_units=get_node("/root/Scene").selected
	#node.modulate.a=0.3
	#node.position=Vector2(0,0)
	set_process(true)
	
func MoveEnd(_position):
	set_process(false)
	#node.modulate.a=1
	node.global_position=_position
	node.get_node("Gate").rect_rotation=old_rotation
	if old_position==_position and create:
		UIHandler.delete_node()
	else:
		if create:
			Database.GetCurrentTab().AppendHistory({"Action":"Create","Node":UIHandler.selected_node})
		elif old_position!=_position:
			for i in selected_units.keys():
				Database.GetCurrentTab().AppendHistory({"Action":"Move","Node":selected_units[i].Node,"From":selected_units[i].Position,"To":selected_units[i].Node.position})
		get_node("/root/Scene").SelectionEffect(true)			
		if UIHandler.selected_node.TYPE=="Variable" or UIHandler.selected_node.TYPE=="Clock" or UIHandler.selected_node.TYPE=="Label" or UIHandler.selected_node.TYPE=="Output":
			UIHandler.CreateUI_variable(UIHandler.selected_node)
		else:
			UIHandler.CreateUI(UIHandler.selected_node)
	create=false
