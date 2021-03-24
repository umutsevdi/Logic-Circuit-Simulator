extends Button
onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
func _ready():
	var _s1=self.connect("button_down",self,"_on_Button_down")
func _on_Button_down():
	if Move.hold and UIHandler.selected_node!=null:
		Move.MoveEnd(Move.old_position)
	var node=BaseGateHandler.SetupUnit(self.name)
	node.name=self.name+" "+str(node.get_instance_id())
	var selected_tab=Database.GetCurrentTab()
	selected_tab.add_child(node)
	node.CreateNode()
