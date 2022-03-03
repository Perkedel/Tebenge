extends Node

var loadedHexagonEngine:bool = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var admobStrings:PoolStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pauseNow(isIt:bool = false):
	pause_mode = isIt
	if isIt:
		pass
	else:
		pass

func _on_AdMob_banner_failed_to_load(error_code):
	pass # Replace with function body.


func _on_AdMob_banner_loaded():
	pass # Replace with function body.


func _on_AdMob_interstitial_closed():
	pass # Replace with function body.


func _on_AdMob_interstitial_failed_to_load(error_code):
	pass # Replace with function body.


func _on_AdMob_interstitial_loaded():
	pass # Replace with function body.
