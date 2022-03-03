extends BaseLagrange


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _receiveOdeePressOption(named:String, fromLagrangeOf:String):
	print("weha")
	match(fromLagrangeOf):
		"MainMenuOD":
			print("You selected %s" % [named])
			match(named):
				"Play":
					pass
				"Setting":
					pass
				"Exit":
					$MainMenuOD.hide()
					$QuitDialogOD.show()
					pass
				_:
					pass
		"QuitDialogOD":
			print("Fated to %s" % [named])
			match(named):
				"Shutdown":
					pass
				"ChangeDVD":
					pass
				"Cancel":
					$MainMenuOD.show()
					$QuitDialogOD.hide()
					pass
				_:
					pass
		_:
			pass
	pass


func _on_MainMenuOD_pressedOption(nameOf):
	pass # Replace with function body.
