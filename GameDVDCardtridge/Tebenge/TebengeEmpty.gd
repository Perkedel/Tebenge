extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Welcome to Tebenge")
#	yield(get_tree().create_timer(5),"timeout")
	print("Let's go.")
	get_tree().change_scene("res://TebengeLoneLoader.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
