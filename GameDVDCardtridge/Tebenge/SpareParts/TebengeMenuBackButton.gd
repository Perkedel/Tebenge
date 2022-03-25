extends TebengeMenuButton


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _goBack():
	pressed = true

func _input(event: InputEvent) -> void:
#	if event is InputEventAction && event.is_action_pressed("ui_cancel"):
#		pass
#	if Input.is_action_just_pressed("ui_cancel"):
#		_goBack()
#		pass
	pass

func _notification(what: int) -> void:
	if visible:
		match(what):
			NOTIFICATION_WM_GO_BACK_REQUEST:
				_goBack()
				pass
		pass
	pass

func _on_TebengeMenuBackButton_pressedName(name) -> void:
	if visible:
		_goBack()
	pass # Replace with function body.
