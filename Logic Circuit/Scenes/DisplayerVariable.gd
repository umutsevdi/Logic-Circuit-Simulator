extends Panel
var placeholder=null
var old_position=Vector2.ZERO
var old_rotation=0
var time=0
var grid_value=0

func _ready():
	_on_Button_pressed()

func _on_Button_pressed():
	$Header.editable=false
	$Header.text=""
	for i in $VBoxContainer/OutputTab.get_children():
		i.queue_free()
	for i in $HBoxContainer.get_children():
		i.disabled=true
	UIHandler.selected_node=null
	self.visible=false

func _on_ConfirmationDialog_confirmed():
	UIHandler.delete_node()

func _on_Delete_pressed():
	get_node("../ConfirmationDialog").popup_centered()



func _on_Header_text_changed(new_text):
	UIHandler.selected_node.name=new_text
