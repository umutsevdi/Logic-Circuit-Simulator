extends LineEdit

var commands = ["new","free","clear"]

func _on_LineEdit_text_entered(new_text):
	var args= new_text.to_lower().split(" ")

	for i in range(args.size()):
		args[i]=args[i].replace(" ","")
	print(args)
	self.text=""
	$RichTextLabel.add_text("\n"+new_text)
	if args[0]=="clear":
		$RichTextLabel.clear()
	elif args[0]=="new" and args.size():
		commands.append(args[1])
		if args[2]=="=" and args.size()>2:
			args[3]=args[3].dedent()
			var gate = args[3].split("(")[0]
			var value = args[3].split("(")[1].replace(")","") if args[3].split("(")[1].split(")")[0] !="" else 2
			print(">", args[3].split("(")[1].replace(")",""))
			print(gate," value=",value)
			if gate.to_upper() in GateConstructor.gates:
				$RichTextLabel.push_color(Color.green)
				$RichTextLabel.add_text("\n>created "+gate.to_upper()+" "+args[1])
			else:
				$RichTextLabel.push_color(Color.red)
				$RichTextLabel.add_text("\n>Error: "+args[1]+" invalid equation")
		elif args.size()==1:
			$RichTextLabel.push_color(Color.green)
			$RichTextLabel.add_text("\n> "+args[1]+" is defined")
		$RichTextLabel.push_color(Color.white)
		
	elif args[0].find_last("free(")!=-1:
		if args[0].split("free(")[1].split(")")[0] in commands:
			commands.remove(commands.find(args[0].split("free(")[1].split(")")[0]))
			$RichTextLabel.push_color(Color.green)
			$RichTextLabel.add_text("\n>removed: "+args[0].split("free(")[1].split(")")[0])
			#args[0].split("free(")[1].split(")")[0]
		else:
			$RichTextLabel.push_color(Color.red)
			$RichTextLabel.add_text("\n>Error: "+args[0].split("free(")[1].split(")")[0]+" is undefined")
		$RichTextLabel.push_color(Color.white)
	elif not args[0] in commands:
		$RichTextLabel.push_color(Color.red)
		$RichTextLabel.add_text("\n>Error: Unexpected indentation")
		$RichTextLabel.push_color(Color.white)
	print(commands)
	
