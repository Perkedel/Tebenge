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

func _goPause():
	pressed = true

func _goBack():
	_goPause()

func _input(event: InputEvent) -> void:
	if visible:
		if Input.is_action_just_pressed("Tebenge_Start"):
			pass

func _notification(what: int) -> void:
	if visible:
		if what == NOTIFICATION_WM_GO_BACK_REQUEST:
			_goPause()
			pass
	pass
