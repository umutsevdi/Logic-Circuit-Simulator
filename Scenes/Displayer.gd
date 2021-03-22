extends Panel
var placeholder=null
var old_position=Vector2.ZERO
var old_rotation=0
var time=0
var grid_value=0

func _on_Button_pressed():
	$Header.text=""
	$VBoxContainer/Type.text="Type : "
	for i in $VBoxContainer/InputTab.get_children():
		i.queue_free()
	for i in $VBoxContainer/OutputTab.get_children():
		i.queue_free()
	for i in $VBoxContainer.get_children():
		i.visible=true
	UIHandler.selected_node=null
	self.visible=false

func _on_Reduce_pressed():
	if ($VBoxContainer/HBoxContainer/LineEdit.text.to_int())>1:
		$VBoxContainer/HBoxContainer/LineEdit.text=str($VBoxContainer/HBoxContainer/LineEdit.text.to_int()-1)
	UIHandler.ResizeLegs($VBoxContainer/HBoxContainer/LineEdit.text.to_int())

func _on_Increase_pressed():
	if ($VBoxContainer/HBoxContainer/LineEdit.text.to_int())<10:
		$VBoxContainer/HBoxContainer/LineEdit.text=str($VBoxContainer/HBoxContainer/LineEdit.text.to_int()+1)
	UIHandler.ResizeLegs($VBoxContainer/HBoxContainer/LineEdit.text.to_int())

func _on_ConfirmationDialog_confirmed():
	UIHandler.delete_node()

func _on_Delete_pressed():
	get_node("../ConfirmationDialog").popup_centered()

func _on_Header_text_changed(new_text):
	UIHandler.selected_node.name=new_text

func _on_GridSeperator_value_changed(value):
	if value>75:
		grid_value=75
		get_node("../GridSeperator").value=75
	else:
		grid_value=value
	Move.grid_value=value

func _on_LineEdit_text_entered(new_text):
	if !new_text.is_valid_integer():
		$VBoxContainer/HBoxContainer/LineEdit.text="1"
	elif new_text.to_int()<=0:
		$VBoxContainer/HBoxContainer/LineEdit.text="1"
	elif new_text.to_int()>10:
		$VBoxContainer/HBoxContainer/LineEdit.text="10"
	UIHandler.ResizeLegs($VBoxContainer/HBoxContainer/LineEdit.text.to_int())
