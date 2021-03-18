extends Button

onready var CreateBar=get_node("../..")
func _ready():
	self.connect("button_down",self,"_on_Button_down")
func _on_Button_down():
	var node=CreateBar.gates[self.name].instance()
	node.name=self.name+" "+str(node.get_instance_id())
	var selected_tab=null
	for i in CreateBar.tabs_node.get_children():
		if i.visible:	
			selected_tab=i
			break
	selected_tab.add_child(node)
	node.CreateNode()

