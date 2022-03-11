extends Node

signal ChangeDVD_Exec()
signal Shutdown_Exec()
signal AdInterstitial_Exec()
signal AdRewarded_Exec()
signal AdBanner_Exec()
onready var loadedHexagonEngine:bool = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wantsToContinue:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _enter_tree():
	
	pass

func _frigginCheckContinue():
	if wantsToContinue:
		# continue game. check if credit inserted is there.
		
		wantsToContinue = false
	pass

func readUISignalWantsTo(nameToDo:String, ODNameOf:String,lagrangeNameOf:String):
	print("This UI wants to %s from OD %s & Lagrange %s" % [nameToDo, ODNameOf, lagrangeNameOf])
	match(lagrangeNameOf):
		"MenuLagrange":
			match(ODNameOf):
				"MainMenuOD":
					match(nameToDo):
						"Play":
							print("Less go!!")
							pass
						"Setting":
							print("Settingeh")
							pass
						"Exit":
							print("Haah?!")
							pass
						_:
							pass
					pass
				"QuitDialogOD":
					match(nameToDo):
						"Shutdown":
							print("Noooo!")
							_terminateThisDVD(false)
							pass
						"ChangeDVD":
							print("Oh nooo!!!")
							_terminateThisDVD(true)
							pass
						"Cancel":
							print("Whew")
							pass
						_:
							pass
					pass
				_:
					pass
			pass
		_:
			pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _terminateThisDVD(changeDVD:bool = false):
	if changeDVD:
		emit_signal("ChangeDVD_Exec")
	else:
		emit_signal("Shutdown_Exec")
	pass

func pauseNow(isIt:bool = false):
	pause_mode = isIt
	if isIt:
		pass
	else:
		pass

func _on_UIField_uiWantsTo(nameOf:String, fromOD:String, fromLagrange:String):
	readUISignalWantsTo(nameOf, fromOD,fromLagrange)
	pass # Replace with function body.

func _on_PlayField_game_over() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToPlay() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToQuit() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToShutdown() -> void:
	pass # Replace with function body.

func receive_AdInterstitial_success() -> void:
	_frigginCheckContinue()
	pass

func receive_AdInterstitial_closed() -> void:
	pass

func receive_AdInterstitial_failed() -> void:
	_frigginCheckContinue()
	pass

func receive_AdRewarded_success() -> void:
	pass

func receive_AdRewarded_failed() -> void:
	pass

func receive_AdBanner_success() -> void:
	
	pass

func receive_AdBanner_failed() -> void:
	# DO NOT LIMIT ANYTHING JUST BECAUSE THIS BANNER FAIL TO LOAD!!!
	pass
