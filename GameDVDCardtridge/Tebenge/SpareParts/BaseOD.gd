extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for thingThere in get_children():
		if thingThere.has_signal("pressedName"):
			thingThere.connect("pressedName", self, "sendPressedOption")
			pass
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal pressedOption(nameOf)

func sendPressedOption(name:String):
	print("Pressed %s" % [name])
	emit_signal("pressedOption",name)
	pass
