extends Node

class_name Tebenge
const savePath:String = "user://Simpan/Tebenge/Simpan.json"
const saveDir:String = "Simpan/Tebenge/"
const updateCheckDownloadMeURL:String = "https://raw.githubusercontent.com/Perkedel/Tebenge/main/version.downloadMe"
const downloadLatestVersionURL:String = "https://play.google.com/store/apps/details?id=com.Perkedel.tebenge"
const githubIssueURL:String = "https://github.com/Perkedel/Tebenge/issues"
const hiScoreArcadeId:String = "CgkIhru1tYoQEAIQAQ"
const hiScoreEndlessId:String = "CgkIhru1tYoQEAIQAw"
const startMeAchievement:String = "CgkIhru1tYoQEAIQAg"
const finishMeAchievement:String = "CgkIhru1tYoQEAIQBg"
const adMurderedAchievement:String = "CgkIhru1tYoQEAIQBA"
const leetSpeakAchievement:String = "CgkIhru1tYoQEAIQBQ"
const sixNineNiceAchievement:String = "CgkIhru1tYoQEAIQDQ"
const yesContinueAchievement:String = "CgkIhru1tYoQEAIQBw"
const noIGiveUpAchievement:String = "CgkIhru1tYoQEAIQCQ"
const abandonAchievment:String = "CgkIhru1tYoQEAIQCA"
const firstDuarAchievment:String = "CgkIhru1tYoQEAIQCg"
const fortyOfThemAchievment:String = "CgkIhru1tYoQEAIQDA"
const eikSerkatAmDeddAchievement:String = "CgkIhru1tYoQEAIQCw"
const tooLateContinueZeroAchievement:String = "CgkIhru1tYoQEAIQDw"
const wentPaidAchievement:String = "CgkIhru1tYoQEAIQEA"
const VERSION:String = "2024.02.0"
var loadSays:PoolStringArray = ['-', '\\', '|', '/']

var _saveTemplate:Dictionary = {
	kludgeHiScore = {
		arcade = 0,
		endless = 0,
	},
	saveState = {
		arcade = {},
		endless = {},
	},
	beenAlreadyHere = false
}

signal ChangeDVD_Exec()
signal Shutdown_Exec()
signal saveOK()
signal saveFailed()
signal UseCoinCheck_Exec()
signal AdInterstitial_Exec()
signal AdInterstitial_Reshow()
signal AdInterstitial_Terminate()
signal AdRewarded_Exec()
signal AdRewarded_Reshow()
signal AdRewarded_Terminate()
signal AdBanner_Exec()
signal AdBanner_Reshow()
signal AdBanner_Terminate()
signal PlayService_JustCheck(menuId)
signal PlayService_ChangeLogin(into)
signal PlayService_UploadSave(nameSnapshot,dataOf,descOf)
signal PlayService_DownloadSave(nameSnapshot)
signal PlayService_CheckSaves(saved_games_screen_title, allow_add_button, allow_delete_button, max_saved_games_snapshots)
signal PlayService_UploadScore(leaderID,howMany)
signal PlayService_RetrieveScore(leaderID,timeSpanOf,collectionOf)
signal PlayService_UnlockAchievement(achievedId)
signal PlayService_RevealAchievement(achievedId)
signal PlayService_IncrementAchievement(achievedId,stepNum)
signal PlayService_SetStepAchievement(achievedId,stepsTo)
signal PlayBilling_Subscribe(toWhat)
signal PlayBilling_Buy(what)
signal PlayBilling_Query(what) # Query the purchases
signal PlayBilling_SKU(what) # Query the SKU
signal PlayBilling_Consume(what)
signal PlayBilling_Update() # update what purchased
export(TebengePlayField.gameModes) var gameMode = TebengePlayField.gameModes.Arcade
export(float) var arcadeTimeLimit = 120
export(AudioStream) var pauseSound = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/PauseOpen.wav")
export(AudioStream) var unpauseSound = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/PauseClose.wav")
onready var loadedHexagonEngine:bool = true
onready var disableAdsMenus = [$CanvasLayer/UIField/GameplayLagrange/DisableAdsOD, $CanvasLayer/UIField/MenuLagrange/DisableAdsOD]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var saveDictionary:Dictionary = {
	
}
var __tempDownloadedSave:String = ""
var wantsToContinue:bool = false
var youveGotNewHiScore:bool = false
var kludgeHiScoreArcade:int = 0 # Highest number of kill
var kludgeHiScoreEndless:int = 0
var _anyKludgeHiScoreRightNow:int = 0
var _pointRightNow:int = 0 setget set_point_right_now
var _multiPointRightNow:PoolIntArray = [0,0,0,0]
var _multiTicketRightNow:PoolIntArray = [0,0,0,0]
var ticket:int = 0 # how many ticket rewarded. in Casino, it is chip $1
var beenAlreadyHere:bool = false
var confirmActionIdFor:String = ""
var appStarted:bool = false
var theUploadSaveForCloudCheck:bool = false
var manuallyUploadSaveSoBeNoisy:bool= false
var commercialMode:bool = false
var updateVerLog:PoolStringArray = ["2022","-idk"]
var manualUpdateCheck:bool = false
var adDisableBeingChecked:bool = false
var checkingBought:bool = false
var checkingSKUs:bool = false

func _releaseDelay():
	if !appStarted:
		_loadSave()
			
		$CanvasLayer/UIField.theOOBEhasBeenDone()
		appStarted = true
		emit_signal("PlayService_UnlockAchievement",startMeAchievement)
	pass

func _checkUpdate(manually:bool = false):
	# Pls don't blame me, it was Kade's idea!
	# https://github.com/KadeDev/Kade-Engine/blob/stable/version.downloadMe
	manualUpdateCheck = manually
	var error = $HTTPRequest.request(updateCheckDownloadMeURL)
	if error != OK:
		printerr("Unable to connect properly! WERROR " + String(error))
#		push_error("Unable to connect properly! WERROR " + String(error))
		_acceptDialog("Unable to connect properly! WERROR " + String(error) + "\nCould not check update right now! warm and bad.\nYour version is v" + VERSION + "\n\nDid you ran out of kuota? or maybe just the latest version source down at the moment, idk..")
		manualUpdateCheck = false
	pass

static func vibrate(device:int = 0, duration:float = 500, weak_magnitude:float = 1, strong_magnitude:float = 1):
	Input.vibrate_handheld(duration)
	if device in Input.get_connected_joypads():
		Input.start_joy_vibration(device,weak_magnitude,strong_magnitude,duration/1000)
	pass

static func stop_vibrate(device:int = 0):
	Input.vibrate_handheld(0)
	if device in Input.get_connected_joypads():
		Input.stop_joy_vibration(device)

func _getHTTPResult(purpose:int = 0, result: int = 0, response_code: int=0, headers: PoolStringArray =[], body: PoolByteArray = [])->void:
	if result == HTTPRequest.RESULT_SUCCESS:
		match(purpose):
			0:
				# Update check
				var daStringe = body.get_string_from_utf8()
				updateVerLog = daStringe.split(";",true,1)
				var granularVerLog:PoolStringArray = updateVerLog[0].split(".",true,3) # This one was my idea.
				# splited the version says so
				var granularVersion:PoolStringArray = VERSION.split(".",true,3)
				var datedStatus:int = 0
				# -1 out of date
				# 0 latest
				# 1 cutting edge
				var granularVersionNum:PoolIntArray
				for thei in granularVersion:
					# Right now this instance
					granularVersionNum.push_back(thei)
					pass
				var granularVerLogNum:PoolIntArray # nope, PoolIntArray you see, is 32-bit int. we want 64-bit!
				for thei in granularVerLog:
					# Latest from repo
					granularVerLogNum.push_back(thei)
					pass
				print("Latest: " + String(granularVerLogNum))
				print("Right here: "+  String(granularVersionNum))
				# check Year, Month, Patch.
				if granularVerLogNum[0] > granularVersionNum[0]:
					# Year out of date
					datedStatus = -1
					print('Year out of date')
					pass
				elif granularVerLogNum[0] < granularVersionNum[0]:
					# Year beyond date
					datedStatus = 1
					print('Year beyond date')
					pass
				else:
					# Year latest
					print('Year latest')
					if granularVerLogNum[1] > granularVersionNum[1]:
						# Month out of date
						datedStatus = -1
						print('Month out of date')
						print('latest month = ' + String(granularVerLogNum[1]))
						print('latest month = ' + String(granularVerLogNum[1]))
						pass
					elif granularVerLogNum[1] < granularVersionNum[1]:
						# Month beyond date
						datedStatus = 1
						print('Month beyond date')
						pass
					else:
						# Month latest
						print('Month latest')
						if granularVerLogNum[2] > granularVersionNum[2]:
							# Patch out of date
							datedStatus = -1
							print('Patch out of date')
							pass
						elif granularVerLogNum[2] < granularVersionNum[2]:
							# Patch beyond date
							datedStatus = 1
							print('Patch beyond date')
							pass
						else:
							# Patch latest
							datedStatus = 0
							print('Latest version')
							pass
						pass
					pass
				
#				if updateVerLog[0] != VERSION:
				if datedStatus < 0:
					confirmActionIdFor = "NewVersion"
					_confirmationDialog("A New version has been detected! sorta?\nYour version is v" + VERSION + "\nLatest version is v" + updateVerLog[0] + "\nwith Changelogs (from that latest, not here):\n"+ updateVerLog[1] +"\n\nThere must be an update here\n as this version of the firmware you are running (v" + VERSION + ") \nis different than what we've checked on the source code repo which is (v" + updateVerLog[0] + ").\n\nPress "+ $CanvasLayer/ConfirmationDialog.get_ok_say() +" to open up Google Play or app repository you had installed this software from.\n\n","NewVersion", "New Firware Update!")
					# "Ignore if you are testing cutting edge (nightly, beta, alpha, special) branch."
					pass
				elif datedStatus > 0:
					confirmActionIdFor = "BeyondVersion"
					_confirmationDialog("You are using cutting edge version!\nYour version is v" + VERSION + "\nLatest version is v" + updateVerLog[0] + "\nwith Changelogs (from that latest, not here):\n"+ updateVerLog[1] +"\n\nYour firmware (v" + VERSION + ") \nis beyond than what we've checked on the source code repo which is (v" + updateVerLog[0] + ").\n\nPress "+ $CanvasLayer/ConfirmationDialog.get_ok_say() +" to open up GitHub issue, & please report any issues you find.\n\nUnlike competitors, we are leading technology company that does not create litigation lawsuits\njust because customers leaked unfinished & unreleased firmware software.\nAs long that the leak does not affect reputation in bad way, we are always fine with such leaks.\nBeware though, you will find alot of bugs! So if you found one,\nit'd be helpful to report those at\n"+githubIssueURL+" .\nThank you!","BeyondVersion", "Leaked firmware software")
				else:
					if manualUpdateCheck:
						_acceptDialog("Your software firmware looks like up to date.\nYour version is v" + VERSION + "\nLatest version is v" + updateVerLog[0] + "\nwith Changelogs:\n"+ updateVerLog[1] +"\n\nReport issues at "+githubIssueURL+"")
						manualUpdateCheck = false
				pass
			_:
				pass
	else:
		printerr("HTTP Werror " + String(result) + " While purpose " + String(purpose))
		if manualUpdateCheck:
			_acceptDialog("HTTP Werror " + String(result) + " While purpose " + String(purpose),"Unable to open page")
			pass
	manualUpdateCheck = false
	pass

func _checkStartup():
	print("checking startup")
	_checkUpdate()
#	yield(get_tree().create_timer(5),"timeout")
	if Engine.has_singleton("GodotPlayGamesServices"):
		print("check startup found Google Play")
		pass
	else:
		_releaseDelay()
	pass

func _loadSave():
	#load JSON
	var thing:File = File.new()
#	thing.open(savePath,_File.WRITE_READ)
	if thing.file_exists(savePath):
		#file exist
		thing.open(savePath,File.READ)
		saveDictionary = parse_json(thing.get_as_text())
		thing.close()
		# inject data
		if "kludgeHiScore" in saveDictionary:
			kludgeHiScoreArcade = saveDictionary["kludgeHiScore"]["arcade"]
			kludgeHiScoreEndless = saveDictionary["kludgeHiScore"]["endless"]
			
		else:
			saveDictionary["kludgeHiScore"] = _saveTemplate["kludgeHiScore"]
			kludgeHiScoreArcade = 0
			kludgeHiScoreEndless = 0
		if "beenAlreadyHere" in saveDictionary:
			beenAlreadyHere = saveDictionary["beenAlreadyHere"]
		else:
			saveDictionary["beenAlreadyHere"] = _saveTemplate["beenAlreadyHere"]
			beenAlreadyHere = false
#		$CanvasLayer/UIField.theOOBEhasBeenDone()
#		$CanvasLayer/UIField.checkGetStuck()
		pass
	else:
		#file not exist
		saveDictionary = _saveTemplate
#		_saveSave()
#		_offerDownloadSaveFromGooglePlay()
		_checkIfCloudBackupExist()
		pass
	# then inject data to here
	
#	_interpretHiScore()
	pass

func _checkIfCloudBackupExist():
	# download! if the cloud backup exist then offer overwrite
	if Engine.has_singleton("GodotPlayGamesServices"):
		emit_signal("PlayService_DownloadSave","Tebenge")
	else:
		print("Google Play not exist")
		$CanvasLayer/UIField.checkGetStuck()
		_saveSave()
	pass

func _offerDownloadSaveFromGooglePlay(saveThatGot:String = ""):
	if saveThatGot.begins_with("{") && saveThatGot.ends_with("}"):
#		if typeof(saveThatGot) == TYPE_NIL || typeof(parse_json(saveThatGot)) || saveThatGot.begins_with("0:") || typeof(saveThatGot) != TYPE_STRING:
#			_acceptDialog("It appears that you don't have valid save backup on your Google Play Games / GMail. If this is the 1st time you're here, this is completely normal.\n\nWelcome! have fun.\n\nYour cloud save backup looks like:\n"+String(saveThatGot)+"","Save Backup Nil / invalid!")
#			return
		# ask whether to  overwrite save thing
		_confirmationDialog("It appears that you have save backup on your Google Play Games / GMail. Would you like to overwrite your save with that one?\n(Using Smart Overwrite that keeps only the highest score between Cloud vs. Local)\n\nYou Have cloud save as follows:\n"+JSONBeautifier.beautify_json(saveThatGot)+"", "OverwriteSaveNow","Save Backup found!")
	else:
		_acceptDialog("It appears that you don't have valid save backup on your Google Play Games / GMail. If this is the 1st time you're here, this is completely normal.\n\nWelcome! have fun.\n\nYour cloud save backup looks like:\n"+String(saveThatGot)+"","Save Backup Nil / invalid!")
		pass
	pass

func justFetchCloudSave():
	pass

func smartlySyncHighscores(step:int = 0,LeaderboardId:String="",scoreJSON:String = ""):
	# Nope, this looks like retrieve all players highscore in this game.
	match(step):
		0:
			# begin asking Arcade score!
			pass
		1:
			# receive Arcade score
			pass
		2:
			# begin asking Endless score
			pass
		3:
			# receive Endless score
			pass
		_:
			pass
	pass

func smartlyUploadSaveToCloud(step:int = 0, beNoisy:bool = false):
	
	if Engine.has_singleton("GodotPlayGamesServices"):
		pass
	else:
		print("Google Play Service missing, cannot upload save to cloud!")
		return
	
	match (step):
		0:
#			manuallyUploadSaveSoBeNoisy = beNoisy
			# You need to sync the save first!
			saveDictionary["kludgeHiScore"]["arcade"] = kludgeHiScoreArcade
			saveDictionary["kludgeHiScore"]["endless"] = kludgeHiScoreEndless
			saveDictionary["beenAlreadyHere"] = beenAlreadyHere
			
			theUploadSaveForCloudCheck = true
			# First, check the cloud save data. only keep highest score
			emit_signal("PlayService_DownloadSave","Tebenge")
#			_acceptDialog("Please wait while checking save & upload","Uploading save")
		1:
			if typeof(__tempDownloadedSave) != TYPE_STRING:
				if manuallyUploadSaveSoBeNoisy:
					_acceptDialog("This compare save is not string! stupidly overwriting instead..\n"+String(__tempDownloadedSave),"Werror")
					push_error("This compare save is not string! stupidly overwriting instead..\n"+String(__tempDownloadedSave))
				emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary), "Tebenge Save")
				manuallyUploadSaveSoBeNoisy = false
				theUploadSaveForCloudCheck = false
				return
			if typeof(__tempDownloadedSave) == TYPE_NIL || typeof(parse_json(__tempDownloadedSave)) == TYPE_NIL || __tempDownloadedSave.begins_with("0:"):
				if manuallyUploadSaveSoBeNoisy:
					# This one (Nil) is the one that says if Null.
					_acceptDialog("This compare save is Nil! stupidly overwriting instead..\n"+String(__tempDownloadedSave),"Werror")
					push_error("This compare save is Nil! stupidly overwriting instead..\n"+String(__tempDownloadedSave))
				emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary), "Tebenge Save")
				manuallyUploadSaveSoBeNoisy = false
				theUploadSaveForCloudCheck = false
				return
			if !(__tempDownloadedSave.begins_with("{") && __tempDownloadedSave.ends_with("}")):
				if manuallyUploadSaveSoBeNoisy:
					# This one (Nil) is the one that says if Null.
					_acceptDialog("This compare save format is invalid! stupidly overwriting instead..\n"+String(__tempDownloadedSave),"Werror")
					push_error("This compare save format is invalid! stupidly overwriting instead..\n"+String(__tempDownloadedSave))
				emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary), "Tebenge Save")
				manuallyUploadSaveSoBeNoisy = false
				theUploadSaveForCloudCheck = false
				return
			# Then start comparing save
			var compareSave:Dictionary = parse_json(__tempDownloadedSave)
			print("Compare & Upload\n"+JSONBeautifier.beautify_json(to_json(compareSave)))
			# if the cloud is lesser than local, overwrite cloud with local
			if compareSave["kludgeHiScore"]["arcade"] < saveDictionary["kludgeHiScore"]["arcade"]:
				compareSave["kludgeHiScore"]["arcade"] = saveDictionary["kludgeHiScore"]["arcade"]
			if compareSave["kludgeHiScore"]["endless"] < saveDictionary["kludgeHiScore"]["endless"]:
				compareSave["kludgeHiScore"]["endless"] = saveDictionary["kludgeHiScore"]["endless"]
				pass
			compareSave["beenAlreadyHere"] = true
			
			print("\ntime to upload\n"+JSONBeautifier.beautify_json(to_json(compareSave)))
			emit_signal("PlayService_UploadSave","Tebenge",to_json(compareSave), "Tebenge Save")
			
			# return back everything
			if manuallyUploadSaveSoBeNoisy:
				_acceptDialog("Upload save complete! your cloud save should looks like:\n"+JSONBeautifier.beautify_json(to_json(compareSave))+"\n\n")
			manuallyUploadSaveSoBeNoisy = false
			theUploadSaveForCloudCheck = false
			pass
		_:
			pass
	
#	emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary),"Tebenge Save")
	# return back everything
#	theUploadSaveForCloudCheck = false
	pass

func smartlyOverwriteSaveFromCloud(theJSON:String):
	print("Do smart overwrite save from cloud")
	if saveDictionary.empty():
		# The save is gone.
		overwriteSaveFromCloud(theJSON,true)
		pass
	else:
		var compareDictionary:Dictionary = parse_json(theJSON)
		if compareDictionary.empty():
			# The save is gone.
			overwriteSaveFromCloud(theJSON,true)
			_acceptDialog("Save overwrite empty!")
			return
		saveDictionary["beenAlreadyHere"] = true
		if compareDictionary["kludgeHiScore"]["arcade"] > saveDictionary["kludgeHiScore"]["arcade"]:
			saveDictionary["kludgeHiScore"]["arcade"] = compareDictionary["kludgeHiScore"]["arcade"]
			kludgeHiScoreArcade = compareDictionary["kludgeHiScore"]["arcade"]
			pass
		if  compareDictionary["kludgeHiScore"]["endless"] > saveDictionary["kludgeHiScore"]["endless"]:
			saveDictionary["kludgeHiScore"]["endless"] = compareDictionary["kludgeHiScore"]["endless"]
			kludgeHiScoreEndless = compareDictionary["kludgeHiScore"]["endless"]
		beenAlreadyHere = saveDictionary["beenAlreadyHere"]
		_acceptDialog("Save smart overwrite Complete! Your local save is now looks like:\n"+JSONBeautifier.beautify_json(to_json(saveDictionary))+"\n\n","Save smart overwrite done!")
		_saveSave()
		pass
	pass

func overwriteSaveFromCloud(theJSON:String, beStupid:bool = false):
	if beStupid:
		saveDictionary = parse_json(theJSON)
		saveDictionary["beenAlreadyHere"] = true
	#	_saveSave()
		# inject data
		kludgeHiScoreArcade = saveDictionary["kludgeHiScore"]["arcade"]
		kludgeHiScoreEndless = saveDictionary["kludgeHiScore"]["endless"]
		beenAlreadyHere = saveDictionary["beenAlreadyHere"]
		_saveSave()
	pass

func theCloudSaveIndeedExist(theJSON:String, working:bool = false):
	if working:
		__tempDownloadedSave = theJSON
		
#		if __tempDownloadedSave.begins_with("{") and __tempDownloadedSave.ends_with("}"):

		if theUploadSaveForCloudCheck:
			smartlyUploadSaveToCloud(1)
			pass
		else:
			if __tempDownloadedSave.begins_with("0:") or typeof(__tempDownloadedSave) == TYPE_NIL:
				_acceptDialog("Save is null! Looks like:\n"+__tempDownloadedSave+"")
				return
			_offerDownloadSaveFromGooglePlay(__tempDownloadedSave)
		
#		else:
#			_acceptDialog("The checked save is invalid format! it looks like:\n"+__tempDownloadedSave+"\nIf this is your first time here, this is normal. Welcome!","Werror")
#			pass
	else:
		_acceptDialog("Sorry, Download / Upload backup failed. Try again at setting","Werror")
		_saveSave()
#		$CanvasLayer/UIField.theOOBEhasBeenDone()
#		$CanvasLayer/UIField.checkGetStuck()
		pass
	pass

func _checkDir():
	# https://godotengine.org/qa/6285/how-to-write-to-user-directory-in-android
	var dir = Directory.new()
	dir.open("user://")
	if !dir.dir_exists( saveDir ) :
		print( saveDir + " doesn't exist." )
		dir.make_dir_recursive( saveDir )
	else:
		print( saveDir+ " exists." )
	
	# well turns out, you must have the directory where the file going to be saved at exist first.
	pass

func _saveSave():
	print("saveNow")
	# fill dictionary first!
	saveDictionary["kludgeHiScore"]["arcade"] = kludgeHiScoreArcade
	saveDictionary["kludgeHiScore"]["endless"] = kludgeHiScoreEndless
	saveDictionary["beenAlreadyHere"] = beenAlreadyHere
	
	_checkDir()
	
	var thing:File = File.new()
	thing.open(savePath,File.WRITE)
	
	# beautify JSON then store string!
	var ingredient:String = JSONBeautifier.beautify_json(to_json(saveDictionary))
	thing.store_string(ingredient)
	if beenAlreadyHere:
#		emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary),"Tebenge Save")
		smartlyUploadSaveToCloud(0)
	
	thing.close()
#	_interpretHiScore()
	emit_signal('saveOK')
	pass

func _uploadOverwriteSave(confirmed:bool = false):
	if Engine.has_singleton("GodotPlayGamesServices"):
		if($PlayField.gameplayStarted):
	#		OS.alert("Cannot upload save during Gameplay.", "Werror 400! Forbidden!")
			_acceptDialog("Cannot upload save during Gameplay.", "Werror 400! Forbidden!")
			manuallyUploadSaveSoBeNoisy = false
			pass
		else:
			# yes you can
			if confirmed:
	#			emit_signal("PlayService_UploadSave","Tebenge",saveDictionary,"Tebenge Save")
				_confirmedDialogTo("PlayService_UploadOverwriteSave")
				pass
			else:
				#ask
				_confirmationDialog("Are you sure to upload game save to Google Play Game Cloud Save?\n WARNING: This will overwrite your cloud save!\n(Using Smart Overwrite that only keeps highest score between Cloud vs. Local)", "PlayService_UploadOverwriteSave")
				pass
			pass
	else:
		_acceptDialog("Google Play Service is missing! Cannot upload to cloud.", "Werror 404! Not found!")
		theUploadSaveForCloudCheck = false
		pass
	pass

func _downloadOverwriteSave(confirmed:bool = false):
	if Engine.has_singleton("GodotPlayGamesServices"):
		if($PlayField.gameplayStarted):
	#		OS.alert("Cannot download save during Gameplay.", "Werror 400! Forbidden!")
			_acceptDialog("Cannot download save during Gameplay.", "Werror 400! Forbidden!")
			pass
		else:
			# yes you can
			if confirmed:
				_confirmedDialogTo("PlayService_DownloadOverwriteSave")
				pass
			else:
				#ask
				_confirmationDialog("Are you sure to download game save from Google Play Game Cloud Save?\n WARNING: This will overwrite your local save!\n(Using Smart Overwrite that only keeps highest score between Cloud vs. Local)", "PlayService_DownloadOverwriteSave")
				pass
			pass
	else:
		_acceptDialog("Google Play Service is missing! Cannot download from cloud.", "Werror 404! Not found!")
	pass

func _checkAllSaves():
	print("Try check save")
	emit_signal("PlayService_CheckSaves","Tebenge", true, true, 0)
	pass

func cloudSavePressAdd(name:String):
	_uploadOverwriteSave(false)
	pass

func _init() -> void:
#	_loadSave()
#	if !Engine.has_singleton("TebengeGlobals"):
#		# add singleton only exist for Editor plugin
#		pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
#	_interpretHiScore()
	
	_checkStartup()
	pass # Replace with function body.

func _enter_tree():
	
	pass

func _checkAdDisableSubscription():
	checkingBought = true
	adDisableBeingChecked = true
	emit_signal("PlayBilling_Query",'subs')
	pass

func _checkJustDonate():
	checkingBought = true
	emit_signal("PlayBilling_Query",'inapp')
	pass

func adDisableResponse(subbed:bool=false,price:String='???'):
	for theraig in disableAdsMenus:
		if theraig is DisableAdsOD:
			theraig.congratulationAdDisabled(subbed)
			
			pass
		pass
	if adDisableBeingChecked:
		
		_acceptDialog("Thank you for subscribing! Keep up!!" if subbed else "Your subscription is inactive!\nYou can renew with 'Buy 1 Month' buttons below.", 'Ad Disabler Status')
		pass
	adDisableBeingChecked = false
	pass

func adDisablePriceResponse(howMuch:String,subbed:bool=false):
	for theraig in disableAdsMenus:
		if theraig is DisableAdsOD:
			theraig.adPriceInfo(
				{
					price=howMuch,
					subbed=subbed,
				}
			)
			pass
		pass
	pass

func listSKUs(items:Array):
	$CanvasLayer/TebengeSKUListDialog.readSKULists(items)
	pass

func listPurchases(items:Array):
	$CanvasLayer/TebengeSKUListDialog.readPurchasedLists(items)
	pass

func _checkWhatDidWeBuy():
	checkingBought = true
	emit_signal("PlayBilling_Update")
	pass

func askedWhatPurchases(rawSay:String = '???', data:Array = []):
	if checkingBought:
#		_acceptDialog('Your Bought info:\n'+rawSay, 'Purchased items')
		listPurchases(data)
		pass
	checkingBought = false
	pass

func askedWhatSKUs(rawSay:String = '???', data:Array = []):
	if checkingSKUs:
		listSKUs(data)
		pass
	checkingSKUs = false

func _buySubscription():
	emit_signal("PlayBilling_Subscribe",'remove_ad')
	pass

func _buyUseless():
	emit_signal("PlayBilling_Buy",'just_donate')
	pass

func _consumeUseless():
	emit_signal("PlayBilling_Consume",'just_donate')
	pass

func _SKUquery(what):
	checkingSKUs = true
	emit_signal("PlayBilling_SKU",what)
	pass

func murderAdNow():
	emit_signal("PlayService_UnlockAchievement",adMurderedAchievement)
	emit_signal("AdBanner_Terminate")
	$CanvasLayer/VirtualBadvertisement.hide()
	$AppearAdAgainTimer.start(-1)
	
	pass

func _mainMenuPls():
	$CanvasLayer/UIField.mainMenuPls()
	pass

func _settingPls(inGame:bool = false):
	print('huuuuuuuuuuuuu')
	$CanvasLayer/UIField.settingPls(inGame)
	pass

func _aboutDialog():
	$CanvasLayer/AboutDialog.popup()
	pass

func _confirmationDialog(message:String, actionId:String = "",title:String = "Are you sure?"):
	confirmActionIdFor = actionId
	$CanvasLayer/ConfirmationDialog.popWithMessage(message,true,title,actionId)
	print("Ask user for " + actionId)

func _acceptDialog(message:String = "", title:String = "Notification"):
	$CanvasLayer/AcceptDialog.popWithMessage(message,true,title)
	pass

func _confirmedDialogTo(doThis:String = "", customAction:String = ""):
	# do this = the ID handed over from dialog.
	confirmActionIdFor = doThis if doThis != "" else confirmActionIdFor
	match(confirmActionIdFor if doThis == "" else doThis):
		"PlayService_DownloadOverwriteSave":
			emit_signal("PlayService_DownloadSave","Tebenge")
			pass
		"PlayService_UploadOverwriteSave":
#			emit_signal("PlayService_UploadSave","Tebenge",to_json(saveDictionary),"Tebenge Save")
			theUploadSaveForCloudCheck = true
			smartlyUploadSaveToCloud(0)
			pass
		"OverwriteSaveNow":
#			overwriteSaveFromCloud(__tempDownloadedSave)
			smartlyOverwriteSaveFromCloud(__tempDownloadedSave)
#			_saveSave()
			pass
		"NewVersion":
			print("Let's open " + downloadLatestVersionURL)
			OS.shell_open(downloadLatestVersionURL)
			pass
		"BeyondVersion":
			print("Let's open " + githubIssueURL)
			OS.shell_open(githubIssueURL)
		_:
			pass
	emit_signal("AdBanner_Reshow")
	pass

func _cancelDialog(forConfirmation:String = ""):
	emit_signal("AdBanner_Reshow")
	confirmActionIdFor = ""
#	$CanvasLayer/UIField.checkGetStuck()
	$GetStuckTimer.stop()
	theUploadSaveForCloudCheck = false
	pass

func _attemptAbortGame():
	if get_tree().paused:
		pass
	else:
		get_tree().paused = true
		pass
	$CanvasLayer/UIField.attemptAbortGame()
	pass

func _confirmedAbortGame(itIs:bool = false):
	if itIs:
		$PlayField.cancelTheGame()
		emit_signal("PlayService_UnlockAchievement",abandonAchievment)
		pass
	else:
		$CanvasLayer/UIField.pauseTheGame(true)
		pass
	_interpretHiScore()
	pass

func _resetAfterGameDone():
	youveGotNewHiScore = false
	_pointRightNow = 0
	set_point_right_now(0)
	_mainMenuPls()
	$PlayField.resetPlayfield()
	#add reset function
	pass

func _intoGameMode():
	$CanvasLayer/UIField.intoGameMode()
	_interpretHiScore()
	pass

func _startTheGame(withMode = TebengePlayField.gameModes.Arcade, coinReady:bool = true):
	if coinReady || !commercialMode:
		print("Start the game with mode %s" % [String(withMode)])
	#	if typeof(withMode) != TebengePlayField.gameModes:
	#		return
		
		_pointRightNow = 0
		set_point_right_now(0)
		gameMode = withMode
	#	$PlayField.chooseGameMode = withMode
		$PlayField.startTheGame(withMode)
		$CanvasLayer/UIField.startTheGame(withMode)
	else:
		emit_signal("UseCoinCheck_Exec") # TODO: commercial arcade mode, only start if credit in the machine enough
		pass
	_interpretHiScore()
	pass

func _pauseTheGame(pauseIt:bool = false):
	$PlayField.pauseTheGame(pauseIt)
	$CanvasLayer/UIField.pauseTheGame(pauseIt)
	pass

func set_point_right_now(howMany:int,toPlayer:int = 0):
#	if $PlayField.gameplayStarted:
	_multiPointRightNow[toPlayer] = howMany
	_pointRightNow = howMany
	# ticket = floor (point / 10)
	ticket = floor(_pointRightNow/10)
	_multiTicketRightNow[toPlayer] = floor(_pointRightNow/10)
	# don't be but hole by not give ticket even gamer paid a dime
	# and lose under 10 points!
	if ticket < 1:
		ticket = 1
	
	if(howMany>0):
		emit_signal("PlayService_UnlockAchievement",firstDuarAchievment)
	
#	emit_signal("PlayService_SetStepAchievement",leetSpeakAchievement,howMany)
#	emit_signal("PlayService_SetStepAchievement",sixNineNiceAchievement,howMany)
	
	match(gameMode):
		TebengePlayField.gameModes.Arcade:
			emit_signal("PlayService_IncrementAchievement",fortyOfThemAchievment,1)
			pass
		TebengePlayField.gameModes.Endless:
			pass
		_:
			pass
	
	$CanvasLayer/UIField.setGameOverTickeySay("Tickets %d" % [ticket])
	_interpretHiScore()
#	print("Point %d" % [howMany])
	pass

func _interpretHiScore():
#	match(gameMode):
	match($PlayField.chooseGameMode):
		TebengePlayField.gameModes.Arcade:
			if _pointRightNow > kludgeHiScoreArcade:
				youveGotNewHiScore = true
				kludgeHiScoreArcade = _pointRightNow
				_anyKludgeHiScoreRightNow = kludgeHiScoreArcade
			else:
#				youveGotNewHiScore = false
				_anyKludgeHiScoreRightNow = kludgeHiScoreArcade
				pass
			pass
		TebengePlayField.gameModes.Endless:
			if _pointRightNow > kludgeHiScoreEndless:
				youveGotNewHiScore = true
				kludgeHiScoreEndless = _pointRightNow
				_anyKludgeHiScoreRightNow = kludgeHiScoreEndless
			else:
#				youveGotNewHiScore = false
				_anyKludgeHiScoreRightNow = kludgeHiScoreEndless
				pass
			pass
		_:
			pass
	
	$CanvasLayer/UIField.gotNewHiScore(youveGotNewHiScore, _anyKludgeHiScoreRightNow, "A" if $PlayField.chooseGameMode == 0 else "E")
	$CanvasLayer/UIField.updateKludgeHiScores(kludgeHiScoreArcade,kludgeHiScoreEndless)
	
	if youveGotNewHiScore:
#		print("New hi score")
		pass
	else:
#		print(" no new hiscore")
		pass
	
	emit_signal("PlayService_SetStepAchievement",leetSpeakAchievement,_anyKludgeHiScoreRightNow)
	emit_signal("PlayService_SetStepAchievement",sixNineNiceAchievement,_anyKludgeHiScoreRightNow)
	
#	_uploadScores(true)
	pass

func _eikSerkat():
	match(gameMode):
		TebengePlayField.gameModes.Arcade:
			
			pass
		TebengePlayField.gameModes.Endless:
			emit_signal("PlayService_UnlockAchievement",eikSerkatAmDeddAchievement)
			pass
		_:
			pass
	
	pass

func _receiveAskedContinue():
	
	$CanvasLayer/UIField.receiveAskedContinue()
	pass

func _receiveContinueTick(itSays:int):
	$CanvasLayer/UIField.receiveContinueTick(itSays) #unused. we use set continue say instead idk.
	setContinueNumber(String(itSays))
	pass

func _continueExpired():
	emit_signal("PlayService_UnlockAchievement",tooLateContinueZeroAchievement)
	pass

func _receiveArcadeTimer(itSays:float):
	$CanvasLayer/UIField.receiveArcadeTimer(itSays)
	pass

func _receiveEndlessTimer(itSays:float):
	$CanvasLayer/UIField.receiveEndlessTimer(itSays)
	pass

func _receiveGameDone(didIt:bool = false):
	beenAlreadyHere = true
	$CanvasLayer/UIField.receiveGameDone(didIt)
	# game has been done!
	if didIt:
		# Game Finish
		match(gameMode):
			TebengePlayField.gameModes.Arcade:
				emit_signal("PlayService_UnlockAchievement",finishMeAchievement)
				pass
			TebengePlayField.gameModes.Endless:
				pass
			_:
				pass
		pass
	else:
		# Game Over
		match(gameMode):
			TebengePlayField.gameModes.Arcade:
				pass
			TebengePlayField.gameModes.Endless:
				pass
			_:
				pass
		pass
	
	# other things too
	# Highscore!
	_interpretHiScore()
#	_uploadScoreRightNow(0 if gameMode == TebengePlayField.gameModes.Arcade else 1 if gameMode == TebengePlayField.gameModes.Endless else -1)
	_uploadScores(true)
	
	# finally, totally save.
	_saveSave()
	pass

func _receiveEikSerkat():
	match(gameMode):
		TebengePlayField.gameModes.Arcade:
			pass
		TebengePlayField.gameModes.Endless:
			emit_signal("PlayService_UnlockAchievement",eikSerkatAmDeddAchievement)
			pass
		_:
			pass
	pass

func _receiveInsertCoin(howManyNow:int = 0):
	emit_signal("PlayService_UnlockAchievement",wentPaidAchievement)
	pass

func _receiveCoinEligibilityResult(enough:bool = false, howManyNow:int = 0):
	if enough:
		_startTheGame(gameMode,true)
		pass
	else:
		pass
	pass

func googlePlayLoggedIn(working:bool = false, userDataJSON:String = "", errorCode:int = 0):
	var dataParse:Dictionary = parse_json(userDataJSON)
	if working:
		print("Sign in Google Play works! Welcome " + dataParse["displayName"])
#		$CanvasLayer/UIField.checkGetStuck()
#		_releaseDelay()
		pass
	else:
		printerr("Sign in Google Play does not work! WERROR " + String(errorCode))
		_acceptDialog("Sign in Google Play does not work! WERROR " + String(errorCode))
		pass
	
	if !appStarted:
		_releaseDelay()
		pass
	pass

func _justCheckGooglePlay(menuID:int = 0):
	emit_signal("PlayService_JustCheck", menuID)
	pass

func _openGooglePlayOd(inGame:bool = false):
	$CanvasLayer/UIField.openGooglePlayOd(inGame)
	pass

func _openDisableAdsOd(inGame:bool = false):
	$CanvasLayer/UIField.openDisableAdsOd(inGame)
	pass

func _openGoogleSectionOd(inGame:bool = false):
	$CanvasLayer/UIField.openGoogleSectionOd(inGame)
	pass
	
func _openInfoSectionOd(inGame:bool = false):
	$CanvasLayer/UIField.openInfoSectionOd(inGame)
	pass

func _changeLoginGooglePlay(into:bool = true):
	if Engine.has_singleton("GodotPlayGamesServices"):
		if($PlayField.gameplayStarted):
	#		OS.alert("Cannot Change Login status during Gameplay.", "Werror 400! Forbidden!")
			_acceptDialog("Cannot Change Login status during Gameplay.", "Werror 400! Forbidden!")
			pass
		else:
			if into:
				# login
				pass
			else:
				# logout
				pass
			emit_signal("PlayService_ChangeLogin",into)
	else:
		_acceptDialog("Google Play Service is missing! Cannot login.\nEither your platform does not support Google Play Service, or intentionally compiled without the Google Play enabled.\nPlease consult with the manufacturer if you have any question.", "Werror 404! Not found!")
		pass
	pass

func _uploadScores(forced:bool = false):
	if $PlayField.gameplayStarted && !forced:
#		OS.alert("Cannot Upload Score during Gameplay.", "Werror 400! Forbidden!")
		_acceptDialog("Cannot Upload Score during Gameplay.", "Werror 400! Forbidden!")
		pass
	else:
		emit_signal("PlayService_UploadScore",hiScoreArcadeId,kludgeHiScoreArcade)
		emit_signal("PlayService_UploadScore",hiScoreEndlessId,kludgeHiScoreEndless)

func _uploadScoreRightNow(whichOneGoesTo:int):
	match(whichOneGoesTo):
		0:
			emit_signal("PlayService_UploadScore",hiScoreArcadeId,_pointRightNow)
			pass
		1:
			emit_signal("PlayService_UploadScore",hiScoreEndlessId,_pointRightNow)
			pass
		_:
			pass
	pass

func _appearAdVideoTron(rewarded:bool = false):
	#Philosophically, you are not allowed to integrate appear ad in functions!
	#You may integrate this containing function inside another functions though.
#	emit_signal("AdRewarded_Exec" if rewarded else "AdInterstitial_Exec")
	emit_signal("AdRewarded_Reshow" if rewarded else "AdInterstitial_Reshow")
	pass

func _iWantToContinue(wantIt:bool = true):
	wantsToContinue = true
	if wantIt:
		# play ad if there is one.
		if OS.get_name() == "Android":
			if Engine.has_singleton("GodotAdMob"):
				# random chance this would spawn either regular interstitial or rewarded unskipable
				var chance:float = rand_range(0,100)
				_appearAdVideoTron(false if chance > 50.0 else true)
			else:
				print("Admob Java singleton not found! that's okay. We hate ads too. just.. financial issues")
				_frigginCheckContinue(wantIt)
		else:
			print("Not android. no ad support. no money. it's okay, you can just go")
			_frigginCheckContinue(wantIt)
	else:
		print("doesn't want to continue")
		_frigginCheckContinue(wantIt)
	pass

func _frigginCheckContinue(chosenContinue:bool = true):
	if wantsToContinue:
		# continue game. check if credit inserted is there.
		$PlayField.selectedAContinue(chosenContinue)
		$CanvasLayer/UIField.selectedAContinue(chosenContinue)
		if chosenContinue:
			emit_signal("PlayService_UnlockAchievement",yesContinueAchievement)
			pass
		else:
			emit_signal("PlayService_UnlockAchievement",noIGiveUpAchievement)
			pass
		wantsToContinue = false
	pass

func setContinueNumber(say:String)->void:
	$CanvasLayer/UIField.setContinueNumber(say)

func readUISignalWantsTo(nameToDo:String, ODNameOf:String,lagrangeNameOf:String):
	print("This UI wants to %s from OD %s & Lagrange %s" % [nameToDo, ODNameOf, lagrangeNameOf])
	match(lagrangeNameOf):
		"MenuLagrange":
			match(ODNameOf):
				"MainMenuOD":
					match(nameToDo):
						"Play":
							print("Less go!!")
							_intoGameMode()
							pass
						"Setting":
							print("Settingeh")
							_settingPls()
							pass
						"Exit":
							print("Haah?!")
							pass
						_:
							pass
					pass
				"SettingOD":
					match(nameToDo):
						"Disable Ads":
							# Check Subscription for Disable ad button
#							_checkAdDisableSubscription()
							_openDisableAdsOd(false)
							pass
						"Google Play Games":
#							_justCheckGooglePlay()
							_openGooglePlayOd(false)
							pass
						"Info":
							# DONE: info section
							_openInfoSectionOd()
							pass
						"Google":
							# DONE: Google section
							_openGoogleSectionOd()
							pass
						"Check Update":
							_checkUpdate(true)
							pass
						"About":
							_aboutDialog()
							pass
						"Back":
							_mainMenuPls()
							pass
						_:
							pass
					pass
				"GooglePlayOD":
					match(nameToDo):
						"Leaderboard":
							_justCheckGooglePlay(0)
							pass
						"Achievement":
							_justCheckGooglePlay(1)
							pass
						"Login":
							_changeLoginGooglePlay(true)
							pass
						"Logout":
							_changeLoginGooglePlay(false)
							pass
						"No Google Play":
							pass
						"Check Saves":
							_checkAllSaves()
							pass
						"Upload Save":
							manuallyUploadSaveSoBeNoisy = true
							_uploadOverwriteSave(false)
							pass
						"Download Save":
							_downloadOverwriteSave(false)
							pass
						"Back":
#							_settingPls()
							_openGoogleSectionOd()
							pass
						_:
							pass
					pass
				"DisableAdsOD":
					match(nameToDo):
						"Query Purchases":
							_checkAdDisableSubscription()
							pass
						"Query Items":
							_checkJustDonate()
							pass
						"Buy 1 Month":
							_buySubscription()
							pass
						"Test Buy Useless":
							_buyUseless()
							pass
						"Consume Useless":
							_consumeUseless()
							pass
						"SKU Subs":
							_SKUquery('subs')
							pass
						"SKU Items":
							_SKUquery('inapp')
							pass
						"Back":
#							_settingPls()
							_openGoogleSectionOd()
							pass
						_:
							pass
					pass
				"GoogleSectionOD":
					match(nameToDo):
						"Disable Ads":
							# Check Subscription for Disable ad button
#							_checkAdDisableSubscription()
							_openDisableAdsOd(false)
							pass
						"Google Play Games":
#							_justCheckGooglePlay()
							_openGooglePlayOd(false)
						"Back":
							_settingPls()
							pass
						_:
							pass
				"InfoSectionOD":
					match(nameToDo):
						"Check Update":
							_checkUpdate(true)
							pass
						"About":
							_aboutDialog()
							pass
						"Back":
							_settingPls()
							pass
						_:
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
							_mainMenuPls()
							pass
						_:
							pass
					pass
				_:
					pass
			pass
		"GameplayLagrange":
			match(ODNameOf):
				"ModesOD":
					match(nameToDo):
						"Arcade":
							gameMode = TebengePlayField.gameModes.Arcade
							_startTheGame(TebengePlayField.gameModes.Arcade)
							pass
						"Endless":
							gameMode = TebengePlayField.gameModes.Endless
							_startTheGame(TebengePlayField.gameModes.Endless)
							pass
						"Back":
							_mainMenuPls()
							pass
					pass
				"HUDOD":
					match(nameToDo):
						"Pause":
#							_pauseTheGame()
							pauseNow(true)
							pass
						_:
							pass
					pass
				"PauseOD":
					match(nameToDo):
						"Resume":
							pauseNow(false)
							pass
						"Setting":
							_settingPls(true)
							pass
						"Quit":
							_attemptAbortGame()
							pass
						_:
							pass
					pass
				"SettingOD":
					match(nameToDo):
						"Disable Ads":
							# Check Subscription for Disable ad button
#							_checkAdDisableSubscription()
							_openDisableAdsOd(true)
							pass
						"Google Play Games":
#							_justCheckGooglePlay()
							_openGooglePlayOd(true)
							pass
						"Info":
							# DONE: info section
							_openInfoSectionOd(true)
							pass
						"Google":
							# DONE: Google section
							_openGoogleSectionOd(true)
							pass
						"Check Update":
							_checkUpdate(true)
							pass
						"About":
							_aboutDialog()
							pass
						"Back":
							_pauseTheGame(true)
							pass
						_:
							pass
					pass
				"GooglePlayOD":
					match(nameToDo):
						"Leaderboard":
							_justCheckGooglePlay(0)
							pass
						"Achievement":
							_justCheckGooglePlay(1)
							pass
						"Login":
							_changeLoginGooglePlay(true)
							pass
						"Logout":
							_changeLoginGooglePlay(false)
							pass
						"No Google Play":
							pass
						"Check Saves":
							_checkAllSaves()
						"Upload Save":
							manuallyUploadSaveSoBeNoisy = true
							_uploadOverwriteSave(false)
							pass
						"Download Save":
							_downloadOverwriteSave(false)
							pass
						"Back":
#							_settingPls(true)
							_openGoogleSectionOd(true)
							pass
						_:
							pass
					pass
				"DisableAdsOD":
					match(nameToDo):
						"Query Purchases":
							_checkAdDisableSubscription()
							pass
						"Query Items":
							_checkJustDonate()
							pass
						"Buy 1 Month":
							_buySubscription()
							pass
						"Test Buy Useless":
							_buyUseless()
							pass
						"Consume Useless":
							_consumeUseless()
							pass
						"SKU Subs":
							_SKUquery('subs')
							pass
						"SKU Items":
							_SKUquery('inapp')
							pass
						"Back":
#							_settingPls(true)
							_openGoogleSectionOd(true)
							pass
						_:
							pass
				"GoogleSectionOD":
					match(nameToDo):
						"Disable Ads":
							# Check Subscription for Disable ad button
#							_checkAdDisableSubscription()
							_openDisableAdsOd(true)
							pass
						"Google Play Games":
#							_justCheckGooglePlay()
							_openGooglePlayOd(true)
						"Back":
							_settingPls(true)
							pass
						_:
							pass
				"InfoSectionOD":
					match(nameToDo):
						"Check Update":
							_checkUpdate(true)
							pass
						"About":
							_aboutDialog()
							pass
						"Back":
							_settingPls(true)
							pass
						_:
							pass
				"AbortDialogOD":
					match(nameToDo):
						"Yes":
							_confirmedAbortGame(true)
							pass
						"No":
							_confirmedAbortGame(false)
							pass
						_:
							pass
					pass
				"ContinueOD":
					match(nameToDo):
						"YES":
							# continue game (arcade only)
							_iWantToContinue(true)
							pass
						"NO":
							_iWantToContinue(false)
							# game over
							pass
						_:
							pass
					pass
				"GameOverOD":
					match(nameToDo):
						"Back":
							_resetAfterGameDone()
							_appearAdVideoTron(false)
							pass
						_:
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
	_saveSave()
#	yield(self,"completed")
	if changeDVD:
		emit_signal("ChangeDVD_Exec")
	else:
		emit_signal("Shutdown_Exec")
	for thang in Input.get_connected_joypads():
		stop_vibrate(thang)
	pass

func pauseNow(isIt:bool = false):
#	pause_mode = isIt
#	get_tree().paused = isIt
	if isIt:
		$InternalSpeaker.stream = pauseSound
		pass
	else:
		$InternalSpeaker.stream = unpauseSound
		pass
	$InternalSpeaker.play()
	_pauseTheGame(isIt)

func _on_UIField_uiWantsTo(nameOf:String, fromOD:String, fromLagrange:String):
	readUISignalWantsTo(nameOf, fromOD,fromLagrange)
	pass # Replace with function body.

func _on_PlayField_game_over() -> void:
	_receiveGameDone(false)
	print("Game Over nooooo")
	pass # Replace with function body.


func _on_UIField_wantsToPlay() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToQuit() -> void:
	pass # Replace with function body.


func _on_UIField_wantsToShutdown() -> void:
	pass # Replace with function body.

func receive_AdInterstitial_success() -> void:
#	_frigginCheckContinue(true)
	pass

func receive_AdInterstitial_closed() -> void:
	_frigginCheckContinue(true)
	pass

func receive_AdInterstitial_failed() -> void:
	print("Interstitial fail")
	_frigginCheckContinue(true)
	pass

func receive_AdRewarded_success() -> void:
	_frigginCheckContinue(true)
	pass

func receive_AdRewarded_failed() -> void:
	# dont be buthole
	print("Rewarded fail")
	_frigginCheckContinue(true)
	pass

func receive_AdBanner_success() -> void:
	
	pass

func receive_AdBanner_failed() -> void:
	# DO NOT LIMIT ANYTHING JUST BECAUSE THIS BANNER FAIL TO LOAD!!!
	pass

func receive_PlayService_DownloadSave(data:String, working:bool = false):
	if working:
#		overwriteSaveFromCloud(data)
		pass
	else:
#		_saveSave()
		pass
	theCloudSaveIndeedExist(data,working)
	pass

func receive_PlayService_DownloadScore(leaderBoardId:String, ScoreJSON:String):
	pass

func _on_PlayField_askedContinue() -> void:
	_receiveAskedContinue()
	pass # Replace with function body.


func _on_PlayField_continueCountdownTicked(remaining:int) -> void:
	# remaining Int
	_receiveContinueTick(remaining)
	pass # Replace with function body.

func _on_PlayField_pointItIsNow(howMany:int,thatsForPlayer:int = 0) -> void:
#	_pointRightNow = howMany
	set_point_right_now(howMany,thatsForPlayer)
#	_multiPointRightNow[thatsForPlayer] = howMany
	pass # Replace with function body.

func _on_PlayField_continuousArcadeTimer(timeSecond:float) -> void:
#	_receiveArcadeTimer(timeSecond)
	pass # Replace with function body.

func _on_PlayField_game_finish() -> void:
	_receiveGameDone(true)
	print("game finish yeyeyeyyeey")
	pass # Replace with function body.


func _on_PlayField_tickedArcadeTimer(timeSecond:float) -> void:
#	print("Time left %d" % [timeSecond])
	_receiveArcadeTimer(timeSecond)
	pass # Replace with function body.


func _on_PlayField_continuousEndlessTimer(timeSecond) -> void:
#	_receiveEndlessTimer(timeSecond)
	pass # Replace with function body.


func _on_PlayField_tickedEndlessTimer(timeSecond) -> void:
	_receiveEndlessTimer(timeSecond)
	pass # Replace with function body.


func _on_PlayField_murderTheAd() -> void:
	murderAdNow()
	pass # Replace with function body.


func _on_AppearAdAgainTimer_timeout() -> void:
	emit_signal("AdBanner_Reshow")
	$CanvasLayer/VirtualBadvertisement.show()
	pass # Replace with function body.


func _on_PlayField_eikSerkat() -> void:
	_eikSerkat()
	pass # Replace with function body.

func _on_ConfirmationDialog_confirmed() -> void:
#	_confirmedDialogTo()
	pass # Replace with function body.

func _on_ConfirmationDialog_popup_hide() -> void:
#	_cancelDialog()
	pass # Replace with function body.


func _on_AcceptDialog_confirmed() -> void:
	emit_signal("AdBanner_Reshow")
	pass # Replace with function body.


func _on_AcceptDialog_popup_hide() -> void:
	emit_signal("AdBanner_Reshow")
	pass # Replace with function body.


func _on_ConfirmationDialog_about_to_show() -> void:
	emit_signal("AdBanner_Terminate")
	pass # Replace with function body.


func _on_AboutDialog_about_to_show() -> void:
	emit_signal("AdBanner_Terminate")
	pass # Replace with function body.


func _on_AboutDialog_popup_hide() -> void:
	emit_signal("AdBanner_Reshow")
	pass # Replace with function body.


func _on_PlayField_continueExpired() -> void:
	_continueExpired()
	pass # Replace with function body.


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
#	_getHTTPResult(0,result,response_code,headers,body)
	pass # Replace with function body.


func _on_ConfirmationDialog_popup_canceled(confirmFor:String) -> void:
	_cancelDialog(confirmFor)
	pass # Replace with function body.

func _on_ConfirmationDialog_popup_confirmed(confirmFor:String) -> void:
	print("OKEH " + confirmFor)
	_confirmedDialogTo(confirmFor)
	pass # Replace with function body.


func _on_ConfirmationDialog_popup_customAction(confirmFor:String, actionFor:String) -> void:
	_confirmedDialogTo(confirmFor,actionFor)
	pass # Replace with function body.



func _on_HTTPRequest_request_doned(purpose, result, response_code, headers, body) -> void:
	_getHTTPResult(purpose,result,response_code,headers,body)
	pass # Replace with function body.


func _on_PlayField_forcedPressContinue(whichIs:bool) -> void:
	_iWantToContinue(whichIs)
	pass # Replace with function body.


func _on_GetStuckTimer_timeout() -> void:
	$CanvasLayer/UIField.checkGetStuck()
	pass # Replace with function body.


func _on_UIField_outOfWelcome() -> void:
	$GetStuckTimer.stop()
	pass # Replace with function body.
