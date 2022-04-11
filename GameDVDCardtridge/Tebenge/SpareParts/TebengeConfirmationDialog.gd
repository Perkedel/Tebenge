extends ConfirmationDialog


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var confirmation_id:String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func popWithMessage(ofThis:String = "Are You sure to...", centered:bool = true, titleDo:String = "Are you sure?", forConfirmation:String = ""):
	titleDo
	dialog_text = ofThis
	confirmation_id = forConfirmation
	if centered:
		popup_centered()
	else:
		popup()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

# This is much better & more stable. resolves dialog confirmation clash
# Actualy no, you only instanced just 1 dialog, instead of spawn and free delete instance.
signal popup_confirmed(confirmFor)
func _on_TebengeConfirmationDialog_confirmed() -> void:
	emit_signal("popup_confirmed",confirmation_id)
	pass # Replace with function body.

signal popup_customAction(confirmFor,actionFor)
func _on_TebengeConfirmationDialog_custom_action(action: String) -> void:
	emit_signal("popup_customAction",confirmation_id,action)
	pass # Replace with function body.

signal popup_canceled(confirmFor)
func _on_TebengeConfirmationDialog_popup_hide() -> void:
	emit_signal("popup_canceled",confirmation_id)
	pass # Replace with function body.
