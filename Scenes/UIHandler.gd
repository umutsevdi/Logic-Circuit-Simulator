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
		if selected_node!=null:
			UpdateUI(selected_node)
		elif displayer.visible or displayer.get_node("../DisplayerVariable").visible:
			displayer.visible=false
			displayer.get_node("../DisplayerVariable").visible=false
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
	displayer.get_node("../DisplayerVariable")._on_Button_pressed()
	displayer.get_node("../DisplayerVariable").visible=true
	displayer.visible=false	
	displayer.get_node("VBoxContainer/Rotation/OptionButton").selected=node.rotation_degrees/-90
	selected_node=node
	displayer.get_node("../DisplayerVariable").get_node("Header").text=node.name
	displayer.get_node("../DisplayerVariable/VBoxContainer/Type").text="Type : "+selected_node.TYPE
	if selected_node.TYPE!="Label" and selected_node.TYPE!="Output":
		var i = node.get_node("Outputs").get_child(0)
		var tab=displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab/Output")
		if i.connection:
			tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
			tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.connection)
		else:
			tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
			tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
	elif selected_node.TYPE=="Output":
		var i = selected_node.get_node("Sockets/Input")
		var tab=displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab/Output")
		if i.connected:
			tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
			tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.source.get_node("../..").name)
		else:
			tab.get_node("VBoxContainer/Value").text="Value : null"
			tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
	else:
		displayer.get_node("../DisplayerVariable/VBoxContainer/Output").visible=false
		displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab").visible=false
func CreateUI(node):
	selected_node=node
	displayer.visible=true	
	displayer.get_node("VBoxContainer/Rotation/OptionButton").selected=node.rotation_degrees/-90
	displayer.get_node("../DisplayerVariable").visible=false
	displayer.get_node("Header").text=node.name
	displayer.get_node("VBoxContainer/Type").text="Type : "+node.get_node("Gate/Label").text
	if node.get_node("Gate/Label").text=="NOT" or node.get_node("Gate/Label").text=="XOR" or node.get_node("Gate/Label").text=="XNOR" or node.TYPE=="Prefab":
		displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").editable=false
		displayer.get_node("VBoxContainer/HBoxContainer/Reduce").disabled=true
		displayer.get_node("VBoxContainer/HBoxContainer/Increase").disabled=true
	else:
		displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").editable=true
		displayer.get_node("VBoxContainer/HBoxContainer/Reduce").disabled=false
		displayer.get_node("VBoxContainer/HBoxContainer/Increase").disabled=false
	displayer.get_node("VBoxContainer/HBoxContainer/LineEdit").text=str(node.legs)

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
	if node.TYPE!="Variable" and node.TYPE!="Label" and node.TYPE!="Output" and node.TYPE!="Clock":
		displayer.visible=true
		displayer.get_node("VBoxContainer/Position").text="Position : ( "+str(int(selected_node.position.x))+" , "+str(int(selected_node.position.y))+" )"
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
		displayer.get_node("../DisplayerVariable/VBoxContainer/Position").text="Position : ( "+str(int(selected_node.position.x))+" , "+str(int(selected_node.position.y))+" )"
		if selected_node.TYPE=="Variable" or selected_node.TYPE=="Clock":
			var i = node.get_node("Outputs").get_child(0)
			var tab=displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab/Output")
			if i.connection:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.connection)
			else:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
		elif selected_node.TYPE=="Output":
			var i = selected_node.get_node("Sockets/Input")
			var tab=displayer.get_node("../DisplayerVariable/VBoxContainer/OutputTab/Output")
			if i.connected:
				tab.get_node("VBoxContainer/Value").text="Value : "+str(i.value)
				tab.get_node("VBoxContainer/Connection").text="Connection : "+str(i.source.get_node("../..").name)
			else:
				tab.get_node("VBoxContainer/Value").text="Value : null"
				tab.get_node("VBoxContainer/Connection").text="Connection : disconnected"
		
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
	
	print(from.rect_rotation," ",from.get_parent().get_parent().rotation_degrees)
	from.add_child(line)
	
func delete_node():
	if selected_node.name in get_node("/root/Scene").selected.keys():
		for i in get_node("/root/Scene").selected.keys():
			selected_node=get_node("/root/Scene").selected[i].Node
			if selected_node.TYPE=="Gate":
				ResizeLegs(0)
			elif selected_node.TYPE=="Prefab" or selected_node.TYPE=="Variable" or selected_node.TYPE=="Clock":
				selected_node.DeleteNode()
			Database.GetCurrentTab().AppendHistory({"Action":"Delete","Node":UIHandler.selected_node.duplicate(8)})
			selected_node.queue_free()
	get_node("/root/Scene").SelectionEffect(false)
	selected_node=null
	displayer.visible=false
	timer=0
func ResizeLegs(legs):
	Database.GetCurrentTab().AppendHistory({"Action":"ResizeLegs","Node":selected_node,"From":selected_node.legs,"To":legs})
	selected_node.ResizeLegs(legs)
	CreateUI(selected_node)
	
func Rotate(index,node):
	
	if node==null:
		node=selected_node
	Database.GetCurrentTab().AppendHistory({"Action":"Rotate","Node":node,"From":abs(node.rotation_degrees),"To":90*index})
	node.rotation_degrees=-90*index
	if (node.TYPE=="Gate" or node.TYPE=="Prefab"):# and index==2:
		node.get_node("Gate/Label").rect_rotation=90*index
	#else:
	#	node.get_node("Gate/Label").rect_rotation=0
	if node.has_node("Sockets"):
		for i in node.get_node("Sockets").get_children():
			i.rect_rotation=90*index
	if node.has_node("Outputs"):
		for i in node.get_node("Outputs").get_children():
			i.rect_rotation=90*index

func CloseCurrentTab():
	
	get_node("../Scene/CanvasLayer/TabContainer/"+Database.GetCurrentTab().name).queue_free()
	Database.GetCurrentTab().queue_free()
	get_node("../Scene/CanvasLayer/TabContainer").SwitchTab(get_node("../Scene/CanvasLayer/TabContainer").get_child(0).name)
