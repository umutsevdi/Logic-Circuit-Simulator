extends AcceptDialog
var array={}
var current_scene
var header=preload("res://UI/TruthTableButton.tscn")

func _on_Truth_Table_about_to_show():
	array.clear()
	array={"Variables":{},"Outputs":{}}
	for i in $ScrollContainer/GridContainer.get_children():
		i.queue_free()
	for i in get_node("../../Tabs").get_children():
		if i.visible:
			current_scene=i
			break
	self.dialog_text="Current Scene : "+current_scene.name+"\nFormat : "+current_scene.format
	if current_scene.format=="Scene":
		for i in current_scene.get_children():
			if i.TYPE=="Variable":
				array.Variables[i.name]={"Node":i,"Value":i.value}
			elif i.TYPE=="Output":
				array.Outputs[i.name]=i
		$ScrollContainer/GridContainer.columns=array.Variables.size()+array.Outputs.size()
		for i in array.Variables.keys():
			var head=header.instance()
			head.text=i
			head.rect_min_size.x=$ScrollContainer/GridContainer.rect_min_size.x/$ScrollContainer/GridContainer.columns
			head.icon=load("res://Assets/Icons/CheckButton.svg")
			$ScrollContainer/GridContainer.add_child(head)
		for i in array.Outputs.keys():
			var head=header.instance()
			head.text=i
			head.rect_min_size.x=$ScrollContainer/GridContainer.rect_min_size.x/$ScrollContainer/GridContainer.columns
			head.icon=load("res://Assets/Icons/Control.svg")
			$ScrollContainer/GridContainer.add_child(head)
		for i in range(pow(2,array.Variables.size())):
			var binary=DectoBin(i)
			for j in range($ScrollContainer/GridContainer.columns):
				var label=Label.new()
				label.name=str(i)+","+str(j)
				if j<array.Variables.size():
					label.text=str(binary[j])
				else:
					label.text="0"
				label.align=Label.ALIGN_CENTER
				label.valign=Label.VALIGN_CENTER
				label.rect_min_size.x=$ScrollContainer/GridContainer.rect_min_size.x/$ScrollContainer/GridContainer.columns
				$ScrollContainer/GridContainer.add_child(label)
	
func DectoBin(number):
	number=int(number)
	var arr=[]
	for j in range(array.Variables.size()):arr.append(0)
	var i =0
	while number>0:
		arr[i]=number%2
		number/=2
		i+=1
	arr.invert()
	return arr
