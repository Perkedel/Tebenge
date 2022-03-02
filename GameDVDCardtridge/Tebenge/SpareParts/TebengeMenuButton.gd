extends Button

class_name TebengeMenuButton
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal pressedName(name)

func _on_TebengeMenuButton_pressed():
	emit_signal("pressedName",text)
	pass # Replace with function body.
