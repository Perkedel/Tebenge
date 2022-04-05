extends TebengeAcceptDialog

class_name TebengeAboutDialog
const aboutFilePath:String = "res://README.md"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _checkAboutFile():
	var daTextWillBe:String = ""
	var faeel:File = File.new()
	
	var try = faeel.open(aboutFilePath,File.READ)
	if try == OK:
		daTextWillBe = faeel.get_as_text()
		faeel.close()
		pass
	else:
		daTextWillBe = "WERROR "+ String(try) +"! Readme file " + aboutFilePath + " Not found / Unreadable!\n"
		daTextWillBe += "Please consult technician immediately!\n"
		daTextWillBe += "Redownload software at: https://github.com/Perkedel/Tebenge\n"
		daTextWillBe += "\n\n(c) Pinball Agung Indonesia (Perkedel Technologies)"
		pass
	$TextBoxThingy.text = daTextWillBe
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_VISIBILITY_CHANGED:
			if visible:
				_checkAboutFile()
				pass
			pass
