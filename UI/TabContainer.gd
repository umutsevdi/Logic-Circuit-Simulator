extends TabContainer

onready var tabs_node = get_tree().get_root().get_node("/root/Scene/Tabs")
var tab_instance= preload("res://Scenes/Tab.tscn")
func _ready():
	for i in self.get_children():
		if i.name!="+":
			var t = tab_instance.instance()
			t.name=i.name
			tabs_node.add_child(t)
	_on_TabContainer_tab_changed(0)

func _on_TabContainer_tab_changed(tab):
	if tab!=0:
		print("Switching tab to ",get_tab_control(tab).name)
	if tabs_node.has_node(get_tab_control(tab).name):
		SwitchTab(get_tab_control(tab).name)

func _on_TabContainer_tab_selected(tab):
	if self.get_tab_control(tab).name=="+":
		get_node("../CreateScene").EmptyBox("Scene")
		get_node("../CreateScene").popup()
func CreateCustomTab(tabname,format):
	var is_existing=false
	for i in self.get_children():
		if i.name==tabname:
			is_existing=true
			print("File is already opened. Switching to tab.")
			self.SwitchTab(tabname)
			return null
	if not is_existing:
		print("File does not exist: Creating tab...")
		var tab_node = tab_instance.instance()
		tab_node.name=tabname
		tabs_node.add_child(tab_node)
		var tab_ui=Tabs.new()
		tab_ui.name=tabname
		self.add_child_below_node(get_node("+"),tab_ui,true)
		self.move_child(get_node("+"),get_tab_count()-1)
		tab_node.format=format
		SwitchTab(tabname)
		return tab_node
		
func SwitchTab(tabname):
	for tab in tabs_node.get_children():
		tab.visible=tab.name==tabname
	self.current_tab=self.get_node(tabname).get_index()
	get_node("../CreateBar/VBoxContainer/Output").visible=tabs_node.get_node(tabname).format=="Scene"

