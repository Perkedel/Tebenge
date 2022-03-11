extends Node

# inspire from our own Where is Loading Functionality demo
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
signal ChangeDVD_Exec()
signal Shutdown_Exec()

func QuitNauYo():
	print("\n\nQuit Nau Yo\n\n")
	emit_signal("ChangeDVD_Exec")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Tebenge_ChangeDVD_Exec() -> void:
	emit_signal("ChangeDVD_Exec")
	pass # Replace with function body.


func _on_Tebenge_Shutdown_Exec() -> void:
	emit_signal("Shutdown_Exec")
	pass # Replace with function body.
