extends Panel
var placeholder=null
var old_position=Vector2.ZERO
var old_rotation=0
var time=0
var grid_value=0

func _ready():
	_on_Button_pressed()

func _on_Button_pressed():
	$Header.text=""
	$VBoxContainer/Type.text="Type : "
	for i in $VBoxContainer.get_children():
		i.visible=true
	UIHandler.selected_node=null
	self.visible=false

func _on_ConfirmationDialog_confirmed():
	UIHandler.delete_node()

func _on_Delete_pressed():
	get_node("../ConfirmationDialog").popup_centered()

func _on_Header_text_changed(new_text):
	if UIHandler.selected_node.TYPE!="Label":
		UIHandler.selected_node.name=new_text
	else:
		UIHandler.selected_node.get_node("Gate/Label").text=new_text
