extends Control
var input_count := 2 
const  output_count = 1

func calculate(array : Array):
	for i in range(array.size()):
		if array[i]:
			return [true]
	return	[false] if array.size()>0 else null			

