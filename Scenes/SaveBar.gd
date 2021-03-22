extends AcceptDialog



func _process(delta):
	if $ProgressBar.value<100:
		$ProgressBar.value+=2
	else:
		self.visible=false
		set_process(false)
func Save():
	pass
	
