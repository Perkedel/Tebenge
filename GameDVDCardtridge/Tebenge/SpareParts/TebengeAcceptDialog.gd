extends AcceptDialog

class_name TebengeAcceptDialog
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func popWithMessage(ofThis:String = "Message...", centered:bool = true, titleDo:String = "Notification"):
	window_title = titleDo
	dialog_text = ofThis
	if centered:
		popup_centered()
	else:
		popup()
	pass

func get_ok_say()->String:
	var daOK = get_ok()
	return daOK.text
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
