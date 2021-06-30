extends TabContainer



func _on_TabContainer_tab_selected(tab):
	get_node("../BottomTab/HBoxContainer/CurrentTab").text=self.get_child(tab).name
