extends BaseOD


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.

func receiveContinueTick(with):
	pass

func setContinueNumber(say:String):
	$ContinueIndicatorDT.value = say
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _input(event: InputEvent) -> void:
	if visible:
	#	if event.is_action_pressed("Tebenge_Bawah") && event.is_action_pressed("Tebenge_Tembak"):
	#		$NOButton.pressed = true
	#		pass
	#	elif event.is_action("Tebenge_Tembak"):
	#		$YESButton.pressed = true
		
		if event.is_action_pressed("Tebenge_Start"):
			if event.is_action_pressed("Tebenge_Kanan") || event.is_action_pressed("Tebenge_Atas"):
				$YESButton.pressed = true
			elif event.is_action_pressed("Tebenge_Kiri") || event.is_action_pressed("Tebenge_Bawah"):
				$NOButton.pressed = true
		
	pass
