extends ConfirmationDialog


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func popWithMessage(ofThis:String = "Are You sure to...", centered:bool = true, titleDo:String = "Are you sure?"):
	titleDo
	dialog_text = ofThis
	if centered:
		popup_centered()
	else:
		popup()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
