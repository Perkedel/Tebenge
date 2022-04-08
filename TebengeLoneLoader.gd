extends Node
# This is hastily made up Hexagon Engine Core just to run the Tebenge GameDVDCardtridge.

onready var insertCoinSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/deleh.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var admobStrings:PoolStringArray
var play_games_services:Object
var is_play_games_signed_in:bool = false
var is_play_games_available:bool = false
var __secret_GoogleCloud_Oauth_Client_ID:String = ""
var creditInserted:int = 0
onready var requiresCredit:int = 1

func _init() -> void:
	print("Initen")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Welcome to Tebenge")
	yield(get_tree().create_timer(5),"timeout")
	print("Ready")
	$DVDsolder/Tebenge.loadedHexagonEngine = false
	var tryGoogleCloud:bool = _readGoogleCloud()
	_readAdmobio()
#	_testAdbmobio()
	if tryGoogleCloud:
		print("Load Google Play Service")
		_readGooglePlay()
		
	else:
		printerr("Google Cloud failed to load! Check firmware software! Contact technician & Reflash if corrupted.")
#		$DVDsolder/Tebenge._releaseDelay()
		pass
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventAction:
		pass
	
	pass

func _readGoogleCloud() -> bool:
	print("Let's begin Google Cloud")
	# read Oauth client ID
	# https://github.com/mauville-technologies/PGSGP
	var f = File.new()
	if f.file_exists("res://GoogleCloud/Tebenge.googlecloud"):
		f.open("res://GoogleCloud/Tebenge.googlecloud", File.READ)
		var index = 0
		var linese:PoolStringArray
		while not f.eof_reached():
			linese.append(f.get_line())
			index += 1
			pass
		__secret_GoogleCloud_Oauth_Client_ID = linese[0]
		f.close()
		return true
	else:
		printerr("WERROR 404 Google Cloud Client ID file missing!!! Software corrupted! Please redownload & reinstall new firmware!")
		return false
	return false
	pass

func _readGooglePlay():
	print("Now Google Play")
	# https://github.com/cgisca/PGSGP
	# https://github.com/mauville-technologies/PGSGP
	# Check if plugin was added to the project
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")

		# Initialize plugin by calling init method and passing to it a boolean to enable/disable displaying game pop-ups

		var show_popups := true 
		var request_email := true
		var request_profile := true
#		var request_token := __secret_GoogleCloud_Oauth_Client_ID
		var request_token := "" # leave empty?
		__secret_GoogleCloud_Oauth_Client_ID = ""
#		play_games_services.init(show_popups)
		# For enabling saved games functionality use below initialization instead
#		play_games_services.initWithSavedGames(show_popups, "Tebenge")
		
#		play_games_services.init(show_popups, request_email, request_profile, request_token)

		# For enabling saved games functionality use below initialization instead
		play_games_services.initWithSavedGames(show_popups, "Tebenge", request_email, request_profile, request_token)
		
		# Connect callbacks (Use only those that you need)
		play_games_services.connect("_on_sign_in_success", self, "_on_sign_in_success") # account_id: String
		play_games_services.connect("_on_sign_in_failed", self, "_on_sign_in_failed") # error_code: int
		play_games_services.connect("_on_sign_out_success", self, "_on_sign_out_success") # no params
		play_games_services.connect("_on_sign_out_failed", self, "_on_sign_out_failed") # no params
		play_games_services.connect("_on_achievement_unlocked", self, "_on_achievement_unlocked") # achievement: String
		play_games_services.connect("_on_achievement_unlocking_failed", self, "_on_achievement_unlocking_failed") # achievement: String
		play_games_services.connect("_on_achievement_revealed", self, "_on_achievement_revealed") # achievement: String
		play_games_services.connect("_on_achievement_revealing_failed", self, "_on_achievement_revealing_failed") # achievement: String
		play_games_services.connect("_on_achievement_incremented", self, "_on_achievement_incremented") # achievement: String
		play_games_services.connect("_on_achievement_incrementing_failed", self, "_on_achievement_incrementing_failed") # achievement: String
		play_games_services.connect("_on_achievement_info_loaded", self, "_on_achievement_info_loaded") # achievements_json : String
		play_games_services.connect("_on_achievement_info_load_failed", self, "_on_achievement_info_load_failed")
		play_games_services.connect("_on_leaderboard_score_submitted", self, "_on_leaderboard_score_submitted") # leaderboard_id: String
		play_games_services.connect("_on_leaderboard_score_submitting_failed", self, "_on_leaderboard_score_submitting_failed") # leaderboard_id: String
		play_games_services.connect("_on_game_saved_success", self, "_on_game_saved_success") # no params
		play_games_services.connect("_on_game_saved_fail", self, "_on_game_saved_fail") # no params
		play_games_services.connect("_on_game_load_success", self, "_on_game_load_success") # data: String
		play_games_services.connect("_on_game_load_fail", self, "_on_game_load_fail") # no params
		play_games_services.connect("_on_create_new_snapshot", self, "_on_create_new_snapshot") # name: String
		play_games_services.connect("_on_player_info_loaded", self, "_on_player_info_loaded")  # json_response: String
		play_games_services.connect("_on_player_info_loading_failed", self, "_on_player_info_loading_failed")
		play_games_services.connect("_on_player_stats_loaded", self, "_on_player_stats_loaded")  # json_response: String
		play_games_services.connect("_on_player_stats_loading_failed", self, "_on_player_stats_loading_failed")
		
		_postCheckGooglePlay()
	else:
		print("No Google Play Singleton found!")
	pass

func _postCheckGooglePlay():
	if play_games_services != null:
		#is_play_games_available = play_game_services.isGooglePlayServicesAvailable()
		play_games_services.signIn()
		is_play_games_signed_in = play_games_services.isSignedIn()
#		$DVDsolder/Tebenge._releaseDelay()
	else:
		print("No Play Service available. Mevem")
	pass

func _readAdmobio():
	# use https://godotengine.org/qa/57130/how-to-import-and-read-text
	var f = File.new()
	if f.file_exists("res://Admob/Tebenge.admob"):
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
	else:
		printerr("WERROR 404 Admob ID file missing!")
	
	
#	$BuiltInSystemer/AdMob.init()
	$BuiltInSystemer/AdMob.load_banner()
	$BuiltInSystemer/AdMob.load_interstitial()
	$BuiltInSystemer/AdMob.load_rewarded_video()
	pass

func _testAdbmobio():
	$BuiltInSystemer/AdMob.load_banner()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Tebenge_InsertCoin"):
		insertCoin()
		pass
	pass

func _on_AdMob_banner_loaded():
	$DVDsolder/Tebenge.receive_AdBanner_success()
	pass # Replace with function body.


func _on_AdMob_interstitial_closed():
	$DVDsolder/Tebenge.receive_AdInterstitial_closed()
	pass # Replace with function body.


func _on_AdMob_interstitial_failed_to_load(error_code):
	$DVDsolder/Tebenge.receive_AdInterstitial_failed()
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

# Da Admobion

func _on_Tebenge_AdBanner_Terminate() -> void:
	$BuiltInSystemer/AdMob.hide_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Reshow() -> void:
	$BuiltInSystemer/AdMob.show_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Exec() -> void:
	pass # Replace with function body.


func _on_Tebenge_AdRewarded_Reshow() -> void:
	$BuiltInSystemer/AdMob.show_rewarded_video()
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Reshow() -> void:
	$BuiltInSystemer/AdMob.show_interstitial()
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Terminate() -> void:
#	$BuiltInSystemer/AdMob
	pass # Replace with function body.


func _on_AdMob_rewarded(currency, ammount) -> void:
	$DVDsolder/Tebenge.receive_AdRewarded_success()
	pass # Replace with function body.


func _on_AdMob_rewarded_video_closed() -> void:
	pass # Replace with function body.


func _on_AdMob_rewarded_video_failed_to_load(error_code) -> void:
	$DVDsolder/Tebenge.receive_AdRewarded_failed()
	pass # Replace with function body.


func _on_AdMob_rewarded_video_left_application() -> void:
	pass # Replace with function body.


func _on_AdMob_rewarded_video_loaded() -> void:
	pass # Replace with function body.


func _on_AdMob_rewarded_video_opened() -> void:
	pass # Replace with function body.


func _on_AdMob_rewarded_video_started() -> void:
	pass # Replace with function body.

# Da Play service
# Callbacks: play_games_services.signIn()
func _on_sign_in_success(userProfile_json: String) -> void:
	var userProfile = parse_json(userProfile_json)

	# The returned JSON contains an object of userProfile info.
	# Use the following keys to access the fields
#	userProfile["displayName"] # The user's display name
#	userProfile["email"] # The user's email
#	userProfile["token"] # User token for backend use
#	userProfile["id"] # The user's id
	print("Successful login as ID " + userProfile["displayName"])
	# do not mistake again!!! `userProfile` Dictionary is the parsed version of `userProfile_json` String!!!
	$DVDsolder/Tebenge.googlePlayLoggedIn(true,userProfile_json,0)
	pass
  
func _on_sign_in_failed(error_code: int) -> void:
	printerr("WERROR login Google Play Faile " + String(error_code))
	$DVDsolder/Tebenge.googlePlayLoggedIn(false,"",error_code)
	pass

# Callbacks: play_games_services.signOut()
func _on_sign_out_success():
	pass
  
func _on_sign_out_failed():
	pass

# Callbacks: play_games_services.unlockAchievement("ACHIEVEMENT_ID")
func _on_achievement_unlocked(achievement: String):
	pass

func _on_achievement_unlocking_failed(achievement: String):
	pass

# Callbacks: play_games_services.setAchievementSteps("ACHIEVEMENT_ID", steps) 
func _on_achievement_steps_set(achievement: String):
	pass

func _on_achievement_steps_setting_failed(achievement: String):
	pass

# Callbacks: play_games_services.revealAchievement("ACHIEVEMENT_ID")
func _on_achievement_revealed(achievement: String):
	pass

func _on_achievement_revealing_failed(achievement: String):
	pass

# Callbacks: play_games_services.loadAchievementInfo(false) # forceReload
func _on_achievement_info_load_failed(event_id: String):
	pass

func _on_achievement_info_loaded(achievements_json: String):
	var achievements = parse_json(achievements_json)

	# The returned JSON contains an array of achievement info items.
	# Use the following keys to access the fields
#	for a in achievements:
#		a["id"] # Achievement ID
#		a["name"]
#		a["description"]
#		a["state"] # unlocked=0, revealed=1, hidden=2 (for the current player)
#		a["type"] # standard=0, incremental=1
#		a["xp"] # Experience gain when unlocked
#
#		# Steps only available for incremental achievements
#		if a["type"] == 1:
#			a["current_steps"] # Users current progress
#			a["total_steps"] # Total steps to unlock achievement

# Callbacks: play_games_services.submitLeaderBoardScore("LEADERBOARD_ID", score)
func _on_leaderboard_score_submitted(leaderboard_id: String):
	print(leaderboard_id + " Successful submit")
	pass

func _on_leaderboard_score_submitting_failed(leaderboard_id: String):
	print(leaderboard_id + " Faile submit")
	pass

# Callbacks: play_games_services.saveSnapshot("SNAPSHOT_NAME", to_json(data_to_save), "DESCRIPTION")
func _on_game_saved_success():
	pass
	
func _on_game_saved_fail():
	pass

# If user clicked on add new snapshot button on the screen with all saved snapshots, below callback will be triggered:
# Callbacks: play_games_services.showSavedGames(saved_games_screen_title, allow_add_button, allow_delete_button, max_saved_games_snapshots)
func _on_create_new_snapshot(name):
#	var game_data_to_save: Dictionary = {
#		"name": "John", 
#		"age": 22,
#		"height": 1.82,
#		"is_gamer": true
#	}
#	play_games_services.save_snapshot(name, to_json(game_data_to_save), "DESCRIPTION")
	$DVDsolder/Tebenge.cloudSavePressYes(name)
	pass

# Callbacks: play_games_services.loadSnapshot("SNAPSHOT_NAME")
func _on_game_load_success(data):
	var game_data: Dictionary = parse_json(data)
	
	$DVDsolder/Tebenge.receive_PlayService_DownloadSave(data, true)
	pass
	
func _on_game_load_fail():
	$DVDsolder/Tebenge.receive_PlayService_DownloadSave("",false)
	pass

func _on_Tebenge_PlayService_JustCheck(menuId:int = 0) -> void:
	if play_games_services != null:
		match(menuId):
			0:
				print("attempt check leaderboards")
				play_games_services.showAllLeaderBoards()
				pass
			1:
				print("attempt check achievements")
				play_games_services.showAchievements()
				pass
			_:
				pass
		
	else:
		print("Cannot check leaderboard or achievement! no play service available!")
	pass # Replace with function body.


func _on_Tebenge_PlayService_UploadSave(nameSnapshot:String, dataOf:String, descOf:String) -> void:
	if play_games_services != null:
		play_games_services.saveSnapshot(nameSnapshot,dataOf,descOf)
		pass
	pass # Replace with function body.

func _on_Tebenge_PlayService_UploadScore(leaderID, howMany) -> void:
	if play_games_services != null:
		play_games_services.submitLeaderBoardScore(leaderID,howMany)
		pass
	pass # Replace with function body.

func _on_Tebenge_AdRewarded_Terminate() -> void:
	pass # Replace with function body.


func _on_Tebenge_PlayService_ChangeLogin(into) -> void:
	if play_games_services != null:
		if into:
			play_games_services.signIn()
			pass
		else:
			play_games_services.signOut()
			pass
	pass # Replace with function body.


func _on_Tebenge_PlayService_RevealAchievement(achievedId) -> void:
	if play_games_services != null:
		play_games_services.revealAchievement(achievedId)
		pass
	pass # Replace with function body.


func _on_Tebenge_PlayService_SetStepAchievement(achievedId, stepsTo) -> void:
	if play_games_services != null:
		play_games_services.setAchievementSteps(achievedId,stepsTo)
		pass
	pass # Replace with function body.


func _on_Tebenge_PlayService_UnlockAchievement(achievedId) -> void:
	if play_games_services != null:
		play_games_services.unlockAchievement(achievedId)
		pass
	pass # Replace with function body.


func _on_Tebenge_PlayService_IncrementAchievement(achievedId, stepNum) -> void:
	if play_games_services != null:
		play_games_services.incrementAchievement(achievedId,stepNum)
		pass
	pass # Replace with function body.


func _on_Tebenge_PlayService_DownloadSave(nameSnapshot) -> void:
	if play_games_services != null:
		play_games_services.loadSnapshot(nameSnapshot)
		pass
	pass # Replace with function body.

func insertCoin():
	creditInserted += 1
	print("Insert Coin! now you have " + String(creditInserted))
	$BuiltInSystemer/InternalSpeaker.stream = insertCoinSound
	$BuiltInSystemer/InternalSpeaker.play()
	$DVDsolder/Tebenge._receiveInsertCoin(creditInserted)
	pass

func useCoin():
	# check if enough
	print("You need " + String(requiresCredit) + " " + "Coins" if requiresCredit > 1 else "Coin")
	if creditInserted > requiresCredit:
		creditInserted -= requiresCredit
		$DVDsolder/Tebenge._receiveCoinEligibilityResult(true, creditInserted)
		print("Coin is enough! Great luck! Now you have " + String(creditInserted))
		pass
	else:
		$DVDsolder/Tebenge._receiveCoinEligibilityResult(false, creditInserted)
		print("Coin is not enough! Exchange coin! You still have " + String(creditInserted))
		pass
	
	if creditInserted < 0:
		creditInserted = 0
	pass


func _on_Tebenge_PlayService_CheckSaves(saved_games_screen_title, allow_add_button, allow_delete_button, max_saved_games_snapshots) -> void:
	if play_games_services != null:
		play_games_services.showSavedGames(saved_games_screen_title, allow_add_button, allow_delete_button, max_saved_games_snapshots)
		pass
	pass # Replace with function body.


func _on_Tebenge_UseCoinCheck_Exec() -> void:
	useCoin()
	pass # Replace with function body.
