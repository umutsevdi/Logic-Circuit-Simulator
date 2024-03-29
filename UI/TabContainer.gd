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
		for i in get_node("../CreateBar/VBoxContainer").get_children():
			if i.get_class()=="Button":
				i.disabled=true
		get_node("../PrefabBar/HBoxContainer/Path").editable=false
		get_node("../PrefabBar/HBoxContainer/UpButton").disabled=true
		get_node("../PrefabBar/HBoxContainer/Button").disabled=true
		for i in get_node("../PrefabBar/ScrollContainer/VBoxContainer").get_children():
			i.get_node("Button").disabled=true
	else:
		for i in get_node("../CreateBar/VBoxContainer").get_children():
			if i.get_class()=="Button":
				i.disabled=false
		get_node("../PrefabBar/HBoxContainer/Path").editable=true
		get_node("../PrefabBar/HBoxContainer/UpButton").disabled=false
		get_node("../PrefabBar/HBoxContainer/Button").disabled=false
		for i in get_node("../PrefabBar/ScrollContainer/VBoxContainer").get_children():
			i.get_node("Button").disabled=false
		
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
	get_node("../History").SwitchTab()


func _on_OpeningError_popup_hide():
	tabs_node.get_node(get_tab_control(current_tab).name).queue_free()
	get_tab_control(current_tab).queue_free()
	SwitchTab(get_tab_control(0).name)
