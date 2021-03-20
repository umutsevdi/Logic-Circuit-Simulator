extends Node
var mouse_position
var input_leg=preload("res://UI/InputLeg.tscn")
onready var displayer=get_node("../Scene/CanvasLayer/Displayer")
var fiber=preload("res://base nodes/fiber.tscn")

var selected_node
var connecting=false
var from
var line
var timer=0
func _process(delta):
	if timer>0.25:
		timer=0
		if selected_node!=null:	UpdateUI(selected_node)
		else:	return
	else:	timer+=delta
	
	if connecting and from!=null:
		if displayer.grid_value!=0:
			line.points[line.points.size()-1]=Vector2(int((UIHandler.mouse_position.x-from.rect_global_position.x)/displayer.grid_value)*displayer.grid_value,int((UIHandler.mouse_position.y-from.rect_global_position.y)/displayer.grid_value)*displayer.grid_value)
		else:
			line.points[line.points.size()-1]=UIHandler.mouse_position-from.rect_global_position
	
		if Input.is_action_just_pressed("left_click"):
			if displayer.grid_value!=0:
				line.add_point(Vector2(int((UIHandler.mouse_position.x-from.rect_global_position.x)/displayer.grid_value)*displayer.grid_value,int((UIHandler.mouse_position.y-from.rect_global_position.y)/displayer.grid_value)*displayer.grid_value))
			else:
				line.add_point(UIHandler.mouse_position-from.rect_global_position)
		if Input.is_action_just_pressed("right_click"):
			connecting=false
			from=null
			line.queue_free()
func CreateUI_variable(node):
	displayer.get_node("../DisplayerVariable").visible=true
	displayer.visible=false	
	selected_node=node
	displayer.get_node("../DisplayerVariable").get_node("Header").text=node.name
	for i in displayer.get_node("../DisplayerVariable/HBoxContainer").get_children():
		i.disabled=false
	displayer.get_node("../DisplayerVariable/Header").editable=true	
	for tab in displayer.get_node("VBoxContainer/Output").get_children():
		if !selected_node.get_node("Outputs").has_node(tab.socket):
			tab.queue_free()
	
	for i in node.get_node("Outputs").get_children():
		if not displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab").has_node(i.name):
			var tab=input_leg.instance()
			tab.name=i.name
			tab.socket=i.name
			if i.connection:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.connection)
			else:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab").add_child(tab)

func CreateUI(node):
	displayer.visible=true	
	displayer.get_node("../DisplayerVariable").visible=false
	displayer.get_node("Header").editable=true
	for i in displayer.get_node("HBoxContainer").get_children():
		i.disabled=false
	selected_node=node
	displayer.get_node("Header").text=node.name
	displayer.get_node("VBoxContainer/HBoxContainer").visible=true
	displayer.get_node("VBoxContainer/Type").text="Type : "+node.get_node("Gate/Label").text
	if node.get_node("Gate/Label").text=="NOT" or node.get_node("Gate/Label").text=="XOR" or node.get_node("Gate/Label").text=="XNOR":
		displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").editable=false
		displayer.get_node("VBoxContainer/HBoxContainer/Reduce").disabled=true
		displayer.get_node("VBoxContainer/HBoxContainer/Increase").disabled=true
	else:
		displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").editable=true
		displayer.get_node("VBoxContainer/HBoxContainer/Reduce").disabled=false
		displayer.get_node("VBoxContainer/HBoxContainer/Increase").disabled=false
	displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").text=str(node.get_node("Sockets").get_child_count())

	for tab in displayer.get_node("VBoxContainer/InputTab").get_children():
		if !selected_node.get_node("Sockets").has_node(tab.socket):
			tab.queue_free()
	
	for i in node.get_node("Sockets").get_children():
		if not displayer.get_node("VBoxContainer/InputTab").has_node("I"+str(i.get_instance_id())):
			var tab=input_leg.instance()
			tab.name="I"+str(i.get_instance_id())
			tab.socket=i.name
			if i.connected:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.source.get_node("../..").name)
			else:
				tab.get_node("VBoxContainer/Value").text="Value : null"
				tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			displayer.get_node("VBoxContainer/InputTab").add_child(tab)
	
	for tab in displayer.get_node("VBoxContainer/Output").get_children():
		if !selected_node.get_node("Outputs").has_node(tab.socket):
			tab.queue_free()
	
	for i in node.get_node("Outputs").get_children():
		if not displayer.get_node("VBoxContainer/OutputTab").has_node(i.name):
			var tab=input_leg.instance()
			tab.name=i.name
			tab.socket=i.name
			if i.connection:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.connection)
			else:
				tab.get_node("VBoxContainer/Value").text="Value : null"
				tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			displayer.get_node("VBoxContainer/OutputTab").add_child(tab)
func UpdateUI(node):
	selected_node=node
	if node.get_node("Gate/Label").text!="Variable" and node.get_node("Gate/Label").text!="Clock" :
		displayer.visible=true
		for tab in displayer.get_node("VBoxContainer/InputTab").get_children():
			if selected_node.get_node("Sockets").has_node(tab.socket):
				var found_node=selected_node.get_node("Sockets").get_node(tab.socket)
				if found_node.source!=null:
					tab.get_node("VBoxContainer/Value").text="Value : "+str(found_node.value)
					tab.get_node("VBoxContainer/Connection").text="Connection : "+str(found_node.source.get_node("../..").name)
				else:
					tab.get_node("VBoxContainer/Value").text="Value : null"
					tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			else:
				tab.queue_free()
				
		for tab in displayer.get_node("VBoxContainer/OutputTab").get_children():
			if selected_node.get_node("Outputs").has_node(tab.socket):
				var found_node=selected_node.get_node("Outputs").get_node(tab.socket)
				if found_node.connection:
					tab.get_node("VBoxContainer/Value").text="Value : "+str(found_node.value)
					tab.get_node("VBoxContainer/Connection").text="Connection : "+str(found_node.connection)
				else:
					tab.get_node("VBoxContainer/Value").text="Value : null"
					tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			else:
				tab.queue_free()
	else:
		displayer.get_node("../DisplayerVariable").visible=true
		for tab in displayer.get_node("../DisplayerVariable").get_node("VBoxContainer/OutputTab").get_children():
			if selected_node.get_node("Outputs").has_node(tab.socket):
				var found_node=selected_node.get_node("Outputs").get_node(tab.socket)
				if found_node.connection:
					tab.get_node("VBoxContainer/Value").text="Value : "+str(found_node.value)
					tab.get_node("VBoxContainer/Connection").text="Connection : "+str(found_node.connection)
				else:
					tab.get_node("VBoxContainer/Value").text="Value : "+str(found_node.value)
					tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
			else:
				tab.queue_free()
		
func ResizeLegs(legs):
	selected_node.ResizeLegs(legs)
	CreateUI(selected_node)

func connect_nodes(to):
	var source=null
	var target=null
	var valid=false
	if to.TYPE=="Output" and from.TYPE=="Input":
		source=to
		target=from
		valid=true
	elif from.TYPE=="Output" and to.TYPE=="Input":
		source=from
		target=to
		valid=true
		var tmp
		for p in line.points:
			p+=from.rect_global_position-to.rect_global_position
		for i in line.points.size()/2:
			tmp=line.points[i]
			line.points[i]=line.points[line.points.size()-1-i]
			line.points[line.points.size()-1-i]=tmp
	else:
		print("\trequest:\t",from,"\tto",to,"\treturns\tinvalid")
	if valid and target.connected==false:
		print("\trequest:\t",source,"\tto\t",target,"\treturns\tvalid")
		target.ConnectOutput(source,line)
		source.SetValue(source.value)
	from=null
	connecting=false
	line.queue_free()
func start_connection(node):
	connecting=true
	from=node
	line=fiber.instance()
	line.modulate.a=0.3
	line.position=Vector2(0,0)
	line.add_point(Vector2(0,0))
	from.add_child(line)
func delete_node():
	if selected_node.TYPE=="Gate":
		ResizeLegs(0)
	elif selected_node.TYPE=="Prefab":
		selected_node.DeleteNode()
	selected_node.queue_free()
	selected_node=null
	displayer.visible=false
