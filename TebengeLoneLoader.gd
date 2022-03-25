extends Node
# This is hastily made up Hexagon Engine Core just to run the Tebenge GameDVDCardtridge.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var admobStrings:PoolStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	$DVDsolder/Tebenge.loadedHexagonEngine = false
	_readAdmobio()
#	_testAdbmobio()
	pass # Replace with function body.

func _readAdmobio():
	# use https://godotengine.org/qa/57130/how-to-import-and-read-text
	var f = File.new()
	f.open("res://Admob/Tebenge.admob", File.READ)
	var index = 0
	while not f.eof_reached():
		admobStrings.append(f.get_line())
		index += 1
		pass
	f.close()
	
	$BuiltInSystemer/AdMob.banner_id = admobStrings[1]
	$BuiltInSystemer/AdMob.interstitial_id = admobStrings[2]
	$BuiltInSystemer/AdMob.rewarded_id = admobStrings[3]
#	$BuiltInSystemer/AdMob.init()
	$BuiltInSystemer/AdMob.load_banner()
	$BuiltInSystemer/AdMob.load_interstitial()
	$BuiltInSystemer/AdMob.load_rewarded_video()
	pass

func _testAdbmobio():
	$BuiltInSystemer/AdMob.load_banner()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AdMob_banner_loaded():
	$DVDsolder/Tebenge.receive_AdBanner_success()
	pass # Replace with function body.


func _on_AdMob_interstitial_closed():
	pass # Replace with function body.


func _on_AdMob_interstitial_failed_to_load(error_code):
	pass # Replace with function body.


func _on_AdMob_interstitial_loaded():
	$DVDsolder/Tebenge.receive_AdInterstitial_success()
	pass # Replace with function body.

func _on_AdMob_banner_failed_to_load(error_code):
	pass # Replace with function body.


func _on_Tebenge_ChangeDVD_Exec():
	pass # Replace with function body.


func _on_Tebenge_Shutdown_Exec():
	#TODO: resave all high scores!
	$DVDsolder/Tebenge.queue_free()
	
	if OS.get_name() == "iOS" || OS.get_name() == "HTML5":
		$BuiltInSystemer/AcceptDialog.window_title = "Notification"
		$BuiltInSystemer/AcceptDialog.dialog_text = "It is now safe to close this app. \n(iOS does not support auto-quit per interface guidelines)\n(HTML5 does not support auto-quit / close tab)"
		$BuiltInSystemer/AcceptDialog.popup_centered()
		pass
	
	get_tree().quit()
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Exec() -> void:
	$BuiltInSystemer/AdMob.load_interstitial()
	pass # Replace with function body.

func _on_Tebenge_AdRewarded_Exec() -> void:
	$BuiltInSystemer/AdMob.load_rewarded_video()
	pass # Replace with function body.

func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_WM_GO_BACK_REQUEST:
			# IDEA: add disabler option for some game. the gameDVD can disable / enable this anytime.
			var a = InputEventAction.new()
			a.action = "ui_cancel"
			a.pressed = true
			Input.parse_input_event(a)
			pass
		NOTIFICATION_WM_QUIT_REQUEST:
			pass
		_:
			pass
	pass

func _on_Tebenge_AdBanner_Terminate() -> void:
	$BuiltInSystemer/AdMob.hide_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Reshow() -> void:
	$BuiltInSystemer/AdMob.show_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Exec() -> void:
	pass # Replace with function body.


func _on_Tebenge_AdRewarded_Reshow() -> void:
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Reshow() -> void:
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Terminate() -> void:
	pass # Replace with function body.
