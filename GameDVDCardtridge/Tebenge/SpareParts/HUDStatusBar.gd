extends HBoxContainer

export(Texture) var iconFor:Texture
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refreshLook()
	pass # Replace with function body.

func refreshLook():
	$IconOfIt.texture = iconFor

func set_Label_say(value:String):
	$LabelNumVar.text = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
