extends Particles2D

export(AudioStream) var DuarSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/bouff.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	pass # Replace with function body.

func _enter_tree() -> void:
#	$DuarSound.stream = DuarSound
	$DuarSound.play()
	pass

func changeDuarSound(withThis:AudioStream):
	$DuarSound.stream = withThis
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
