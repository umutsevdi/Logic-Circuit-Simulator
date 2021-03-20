extends Button
onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
func _ready():
	self.connect("button_down",self,"_on_Button_down")
func _on_Button_down():
	
	var node=BaseGateHandler.SetupUnit(self.name)
	node.name=self.name+" "+str(node.get_instance_id())
	var selected_tab=null
	for i in tabs_node.get_children():
		if i.visible:	
			selected_tab=i
			break
	selected_tab.add_child(node)
	node.CreateNode()

