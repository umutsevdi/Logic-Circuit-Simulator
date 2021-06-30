extends GraphNode
var ratio=Vector2(4,4.65)
func resize(value):
	self.rect_size = ratio/4*value
func calculate(array : Array):
	for i in range(array.size()):
		if array[i]:
			return [false]
	return	[true] if array.size()>0 else null			
