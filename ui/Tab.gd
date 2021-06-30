extends GraphEdit
var offset_data=scroll_offset

func _process(_delta):
	if self.visible:
		var vector = (get_local_mouse_position()+scroll_offset)/zoom
		get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Cursor").text="("+str(float(int(vector.x*10000))/10000)+", "+str(float(int(vector.y*10000))/10000)+")"
	if Input.is_action_just_released("middle_click") and self.visible:
		offset_data=self.scroll_offset
	if Input.is_action_just_released("zoom_in"):
		self.zoom-=0.1
	elif Input.is_action_just_released("zoom_out"):
		self.zoom+=0.1
	if Input.is_action_just_released("zoom_in") or  Input.is_action_just_released("zoom_out") and self.visible:
		self.scroll_offset=offset_data
		get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Zoom").text=str(self.zoom*100)+"%"


func _on_Tab_node_selected(node):
	if get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").text!="":
		get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").text+=", "
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").visible=true
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/IconSelection").visible=true
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/VSeparatorSelection").visible=true
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").text+=node.name
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/IconSelection").hint_tooltip+=node.name+str(node.offset)+"\n"
	



func _on_Tab_node_unselected(_node):
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").text=""
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/IconSelection").hint_tooltip=""
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/Selection").visible=false
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/IconSelection").visible=false
	get_tree().get_root().get_node("main").get_node("BottomTab/HBoxContainer/VSeparatorSelection").visible=false


func _on_Tab_connection_request(from, from_port, to, to_port):
	for iter in self.get_connection_list():
		if iter.to == to and iter.to_port == to_port:
			return
	self.connect_node(from, from_port, to, to_port)
	
func add_node():
	var node := GraphNode.new()
	get_node("Graph").add_child(node)
	node.offset.x = get_viewport().get_mouse_position().x


func _on_Tab_disconnection_request(from, from_port, to, to_port):
	self.disconnect_node(from, from_port, to, to_port)
