extends Control

var label = Label
var time = Timer

func _ready():
	label = $Label
	time = $Timer
	
	time.start()
	
func _process(delta):
	update_label_text()
	
func update_label_text():
	label.text = str(ceil(time.time_left))
	
