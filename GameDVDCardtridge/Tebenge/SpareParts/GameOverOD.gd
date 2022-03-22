extends BaseOD

func _input(event: InputEvent) -> void:
	if visible:
		if Input.is_action_just_pressed("Tebenge_Start"):
			$BackToMenuButton.pressed = true
			pass
	pass

func _on_BackToMenuButton_pressedName(name) -> void:
	
	pass # Replace with function body.
