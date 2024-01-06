extends Node
# This is hastily made up Hexagon Engine Core just to run the Tebenge GameDVDCardtridge.

const ITEM_SKU = ['just_donate','remove_interstitial','remove_ad', 'remove-ad0', 'remove-ad-recur0']
const SUBS_SKU = ['remove_ad', 'remove-ad0', 'remove-ad-recur0']
const debugMode:bool = true
enum PurchaseState {
	UNSPECIFIED,
	PURCHASED,
	PENDING,
}

onready var insertCoinSound:AudioStream = load("res://GameDVDCardtridge/Tebenge/Assets/audio/sounds/deleh.wav")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var admobStrings:PoolStringArray
var play_games_services:Object
var shangTsung # Google Play IAP # payment
var is_play_games_signed_in:bool = false
var is_play_games_available:bool = false
var __secret_GoogleCloud_Oauth_Client_ID:String = ""
var creditInserted:int = 0
var ___yourSoulsBelongsToShangTsungInsteadOfGoogle:bool = false # you subscribed to remove_ad
var ___interstitialDestroyed:bool = false # you bought remove interstitial
var ___testShangTsungMight = null # test_item_purchase_token
onready var ___tebengeItself = $DVDsolder/Tebenge

onready var requiresCredit:int = 1
onready var adInited:bool = false

func _debugAlert(message:String = 'Hello', title:String = 'Alert'):
	if debugMode:
		OS.alert(message,title)
	pass

func _init() -> void:
	print("Initen")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Welcome to Tebenge")
	yield(get_tree().create_timer(5),"timeout")
	print("Ready")
	
	# (No, actually first) ~~and finally~~, this pecking Shang Tsung soul stealer / Google IAP
	_readBilling()
	# if the billing works & user payment active, then ___yourSoulsBelongsToShangTsungInsteadOfGoogle is true 
	
	___tebengeItself.loadedHexagonEngine = false
	var tryGoogleCloud:bool = _readGoogleCloud()
#	_readAdmobio()
#	_testAdbmobio()
	if tryGoogleCloud:
		print("Load Google Play Service")
		_readGooglePlay()
		
	else:
		printerr("Google Cloud failed to load! Check firmware software! Contact technician & Reflash if corrupted.")
#		___tebengeItself._releaseDelay()
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
#		___tebengeItself._releaseDelay()
	else:
		print("No Play Service available. Mevem")
	pass

func _readAdmobio():
	# use https://godotengine.org/qa/57130/how-to-import-and-read-text
	if not adInited:
		if ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
			$BuiltInSystemer/AdMob.banner_id = ""
			$BuiltInSystemer/AdMob.interstitial_id = ""
			$BuiltInSystemer/AdMob.rewarded_id = ""
			print('YOUR SOUL IS MINE')
		else:
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
		
		_debugAlert('You have subscription!' if ___yourSoulsBelongsToShangTsungInsteadOfGoogle else 'No subscription')
	adInited = true
	pass

func _testAdbmobio():
	if not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
		$BuiltInSystemer/AdMob.load_banner()
	pass

func _updateAdmobioStatus():
	if adInited:
		if ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
			$BuiltInSystemer/AdMob.banner_id = ""
			$BuiltInSystemer/AdMob.interstitial_id = ""
			$BuiltInSystemer/AdMob.rewarded_id = ""
			$BuiltInSystemer/AdMob.hide_banner()
			print('YOUR SOUL IS MINE')
			pass
		else:
			
			pass
	else:
		_readAdmobio()
	pass

func _readBilling():
	# https://docs.godotengine.org/en/3.6/tutorials/platform/android/android_in_app_purchases.html
	# https://github.com/godotengine/godot-google-play-billing
	# https://developer.android.com/google/play/billing/integrate?hl=id#process
	# https://youtu.be/5W7xsGWPfdU?si=sDosiJDu2coTaCsW
	# https://github.com/himaghnam/Himaghnam/blob/master/IAP.gd
	# https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
	if Engine.has_singleton("GodotGooglePlayBilling"):
		shangTsung = Engine.get_singleton("GodotGooglePlayBilling")

		# These are all signals supported by the API
		# You can drop some of these based on your needs
		shangTsung.connect("billing_resume",self,"_on_GP_IAP_billing_resume")
		shangTsung.connect("connected", self, "_on_GP_IAP_connected") # No params
		shangTsung.connect("disconnected", self, "_on_GP_IAP_disconnected") # No params
		shangTsung.connect("connect_error", self, "_on_GP_IAP_connect_error") # Response ID (int), Debug message (string)
		shangTsung.connect("purchases_updated", self, "_on_GP_IAP_purchases_updated") # Purchases (Dictionary[])
		shangTsung.connect("purchase_error", self, "_on_GP_IAP_purchase_error") # Response ID (int), Debug message (string)
		shangTsung.connect("sku_details_query_completed", self, "_on_GP_IAP_sku_details_query_completed") # SKUs (Dictionary[])
		shangTsung.connect("sku_details_query_error", self, "_on_GP_IAP_sku_details_query_error") # Response ID (int), Debug message (string), Queried SKUs (string[])
		shangTsung.connect("purchase_acknowledged", self, "_on_GP_IAP_purchase_acknowledged") # Purchase token (string)
		shangTsung.connect("purchase_acknowledgement_error", self, "_on_GP_IAP_purchase_acknowledgement_error") # Response ID (int), Debug message (string), Purchase token (string)
		shangTsung.connect("purchase_consumed", self, "_on_GP_IAP_purchase_consumed") # Purchase token (string)
		shangTsung.connect("purchase_consumption_error", self, "_on_GP_IAP_purchase_consumption_error") # Response ID (int), Debug message (string), Purchase token (string)
		shangTsung.connect("query_purchases_response",self,"_on_GP_IAP_query_purchases_response") # Purchases (Dictionary[])

		shangTsung.startConnection()
		
		# Then check if customer gave their soul to Shang Tsung
		# billing check Subscription Remove Ad
		# HOW AM I SUPPOSED TO DO THAT?! WHICH SIGNAL CALLBACK?!?!?
#		print('IT HAS BEGUN')
	else:
		_debugAlert('Android IAP support is not enabled. Make sure you have enabled \'Custom Build\' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work','Shang Tsung Blocked')
		print("Android IAP support is not enabled. Make sure you have enabled 'Custom Build' and the GodotGooglePlayBilling plugin in your Android export settings! IAP will not work. SHANG_TSUNG_BLOCKED")
	pass

func _checkAcknowledge():
	pass

var listQueryBoughtItem:Dictionary
var listQueryBoughtSubs:Dictionary
func _queryPurchases(whichAre:String = 'subs'):
	if !shangTsung:
		___tebengeItself._acceptDialog('Missing Billing! Querying: ' + whichAre,'404 Google Play Billing Not found!')
		___tebengeItself.adDisableResponse(___yourSoulsBelongsToShangTsungInsteadOfGoogle)
		return
	else:
#		_debugAlert('QUERY CHECKING ' + whichAre,'Please wait') # DEBUG
		pass
#	_debugAlert('Will check ' + whichAre, 'before') # DEBUG
	var query_subs = shangTsung.queryPurchases(whichAre)
#	_debugAlert('Had check ' + whichAre + '\n'+String(query_subs), 'after') # DEBUG
#	match(whichAre):
#		'inapp':
#			listQueryBoughtItem = query_subs
#			_debugAlert(String(listQueryBoughtItem))
#		'subs':
#			listQueryBoughtSubs = query_subs
#			_debugAlert(String(listQueryBoughtSubs))
#		_:
#			pass
#	print(query_subs)
#	_debugAlert('QUERY:\n'+String(query_subs),'Query Billing') # DEBUG
#
#	if query_subs.status == OK:
#		for purchase in query_subs.purchases:
#			match purchase.sku:
#				"remove_ad":
#					if !purchase.is_acknowledged:
#						___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
#						print('YOUR SOUL IS MINE')
#						shangTsung.acknowledgePurchase(purchase.purchase_token)
#					print('IT HAS BEGUN')
#					continue
#					pass
#				"just_donate":
#					_debugAlert('Just donate found','Boughte')
#					if !purchase.is_acknowledged:
#						shangTsung.consumePurchase(purchase.purchase_token)
#						continue
##					if purchase.purchase_state == PurchaseState.PURCHASED:
##						shangTsung.consumePurchase(purchase.purchase_token)
##						pass
#					shangTsung.consumePurchase(purchase.purchase_token)
#
#					continue
#					pass
#				"remove_interstitial":
#					___interstitialDestroyed = true
#					pass
#				_:
#					pass
#			if !purchase.is_acknowledged:
##				___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
##				print('YOUR SOUL IS MINE')
#				shangTsung.acknowledgePurchase(purchase.purchase_token)
#				pass
#			pass
#		___tebengeItself.adDisableResponse(___yourSoulsBelongsToShangTsungInsteadOfGoogle)
#		pass
#	else:
#		_debugAlert('WERROR QUERYING\n'+String(query_subs.status)+'\n\n'+String(query_subs),'Query Werror') # DEBUG
#		pass
	pass

func _querySKUs(ofWhat):
	print('query sku of '+ofWhat)
	if shangTsung:
		shangTsung.querySkuDetails(ITEM_SKU,ofWhat)
	pass

func _processPurchases(purchases):
	
	if purchases.status == OK:
#		listQueryBoughtItem = purchases
		_debugAlert('Your Purchases:\n'+JSONBeautifier.beautify_json(to_json(purchases)),'Result')
		for purchase in purchases.purchases:
#			_process_purchase(purchase)
			listQueryBoughtItem[purchase.sku] = purchase
			match purchase.sku:
				"remove_ad":
					if !purchase.is_acknowledged:
						___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
						print('YOUR SOUL IS MINE')
						shangTsung.acknowledgePurchase(purchase.purchase_token)
					___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
					print('IT HAS BEGUN')
					_updateAdmobioStatus()
					___tebengeItself.adDisableResponse(___yourSoulsBelongsToShangTsungInsteadOfGoogle)
					continue
					pass
				"just_donate":
#					_debugAlert('Just donate found','Boughte')
					if !purchase.is_acknowledged:
						shangTsung.consumePurchase(purchase.purchase_token)
						continue
#					if purchase.purchase_state == PurchaseState.PURCHASED:
#						shangTsung.consumePurchase(purchase.purchase_token)
#						pass
					shangTsung.consumePurchase(purchase.purchase_token)

					continue
					pass
				"remove_interstitial":
					___interstitialDestroyed = true
					pass
				_:
					pass
			if !purchase.is_acknowledged:
#				___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
#				print('YOUR SOUL IS MINE')
				shangTsung.acknowledgePurchase(purchase.purchase_token)
				pass
			pass
#		_debugAlert('Your Purchases:\n'+String(JSONBeautifier.beautify_json(listQueryBoughtItem)),'Result')
#		___tebengeItself.adDisableResponse(___yourSoulsBelongsToShangTsungInsteadOfGoogle)
	else:
		_debugAlert("queryPurchases failed, response code: "+String(purchases.response_code)+"\ndebug message:\n"+purchases.debug_message,'WERROR FAILE QUERY')
		print("queryPurchases failed, response code: ",
				purchases.response_code,
				" debug message: ", purchases.debug_message)
	
	if purchases.size() > 0:
		___testShangTsungMight = purchases[purchases.size() - 1].purchase_token
	
	_updateAdmobioStatus()
	___tebengeItself.askedWhatPurchases(String(purchases), purchases.purchases)
	pass

func _shangTsungErrorHorroscope(code:int = 0):
	var itseems:String = ''
	# https://developer.android.com/google/play/billing/errors?hl=id
	# https://developer.android.com/reference/com/android/billingclient/api/BillingClient.BillingResponseCode
	match code:
		OK:
			# 0
			itseems = 'OK'
			pass
		-3:
			#timeout
			itseems = 'Timeout! Your signal low?'
		-2:
			itseems = 'Feature Unsupported! API tried to trigger unsupported feature??'
		-1:
			itseems = 'Disconnected! Your internet died OR did you sparsdated / pirated?'
		0:
			pass
		1:
			#canceled
			itseems = 'User canceled! You canceled purchase?'
		2:
			itseems = 'Internet faile! You ran out of quota?'
			pass
		3:
			itseems = 'Your card rejected?'
		4:
			itseems = 'Item Unavailable! Sorry, I think we don\' have this in shelf atm?'
		5:
			itseems = 'Dev Error! I think we made mistake? Idk which one, Google can\'t tell us either! '
			pass
		6:
			itseems = 'Fatal error idk! Google doesn\'t even know!'
			pass
		7:
			itseems = 'Item already owned! You already have this item! Maybe try to consume it first OR stop subscribing a while?'
		8:
			itseems = 'Item not owned yet! You have not bought this yet?'
		9:
			itseems = ''
		_:
			pass
	return itseems

func _on_GP_IAP_connected():
	# https://github.com/himaghnam/Himaghnam/blob/master/IAP.gd
	if Engine.has_singleton("GodotGooglePlayBilling") and shangTsung:
		print('Connecteh the Microtransactor')
#		shangTsung.querySkuDetails(SUBS_SKU,'remove_ad')
#		shangTsung.querySkuDetails(SUBS_SKU,"subs")
#		shangTsung.querySkuDetails(ITEM_SKU,'inapp')
#		_querySKUs('inapp')
		_querySKUs('subs')
		_queryPurchases('subs')
#		_queryPurchases('inapp')
		
		
#		print('IT HAS BEGUN')
	pass

func _on_GP_IAP_disconnected():
	# connection to Shang Tsung's green minion dropped!
	yield(get_tree().create_timer(10),"timeout")
	if shangTsung:
		shangTsung.startConnection()


func _on_GP_IAP_purchases_updated(purchases):
	print("Purchases updated: %s" % to_json(purchases))
	purchased_inapp = to_buy_item
	# See _on_connected
#	for purchase in purchases:
#		if !purchase.is_acknowledged:
#			print("Purchase " + str(purchase.sku) + " has not been acknowledged. Acknowledging...")
#			shangTsung.acknowledgePurchase(purchase.purchase_token)
#		match purchase.sku:
#			'just_donate':
#				_debugAlert('Consume Just donate','Yum')
#				shangTsung.consumePurchase(purchase.purchase_token)
#				pass
#			'remove_interstitial':
#				___interstitialDestroyed = true
#				pass
#			_:
#				pass
#
#	if purchases.size() > 0:
#		___testShangTsungMight = purchases[purchases.size() - 1].purchase_token
#
#	___tebengeItself.askedWhatPurchases(String(purchases))
	_processPurchases(purchases)
	pass

var purchasable_inapp:Dictionary
var purchasable_subs:Dictionary
var subs:bool = false
func _on_GP_IAP_sku_details_query_completed(sku_details):
	
	for available_sku in sku_details:
		purchasable_inapp[available_sku.sku] = available_sku
		pass
	
	if !subs:
#		for available_sku in sku_details:
#			purchasable_inapp[available_sku.sku] = available_sku
#			"{inapp1:{data},inapp2:{data}}" 
			
		subs = true
#		shangTsung.querySkuDetails(SUBS_SKU,"subs")
	else: #or if subs:
		for available_sku in sku_details:
			if available_sku.sku == "remove_ad":
#				___tebengeItself.adDisablePriceResponse(available_sku.price,___yourSoulsBelongsToShangTsungInsteadOfGoogle)
				pass
#		shangTsung.querySkuDetails(ITEM_SKU,'inapp')
		"Loading.hide()"
	___tebengeItself.adDisablePriceResponse(sku_details['remove_ad'].price,___yourSoulsBelongsToShangTsungInsteadOfGoogle)
	___tebengeItself.listSKUs(sku_details.values)
	_debugAlert(JSONBeautifier.beautify_json(to_json(purchasable_inapp)),'SKU DETAILS') # DEBUG
#	print(sku_details)
	pass

var purchased_inapp:String
var purchased_subs:bool = false
func _on_GP_IAP_purchase_acknowledged(purchase_token):
	print("Purchase acknowledged: %s" % purchase_token)
	if !purchased_subs:
		"open functions of purchased_inapp"
# warning-ignore:standalone_expression
		match purchased_inapp:
			"inapp1":
				pass
			"inapp2":
				pass
			"just_donate":
				___tebengeItself._acceptDialog('Thank you for your donation!', 'Donation Received')
				shangTsung.consumePurchase(purchase_token)
				pass
	else:
		"subscription func"
		purchased_subs = false
	"Global._save_game()"
	
	"or"
	
	match purchased_inapp:
		"inapp1":
			pass
		"inapp2":
			pass
		"free_ads_1":
			___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
			pass
		"remove_ad":
			___tebengeItself._acceptDialog('Ad Disabled\nThank you for your purchase', 'Ad Disabled')
			___yourSoulsBelongsToShangTsungInsteadOfGoogle = true
			pass
	"Global._save_game()"
#	_queryPurchases('subs')
	_updateAdmobioStatus()
	pass

func _on_GP_IAP_purchase_error(response:int = 0, message:String = ''):
	# itseems
	___tebengeItself._acceptDialog('WERROR '+String(response)+'\n'+message+'\n\n'+_shangTsungErrorHorroscope(response),'Purchase Error')
	pass

func _on_GP_IAP_purchase_consumed(token):
	___tebengeItself._acceptDialog('Consuming '+ String(token), 'Consume')
	pass

func _on_GP_IAP_purchase_consumption_error(response:int = 0, message:String = ''):
	___tebengeItself._acceptDialog('WERROR CONSUME '+String(response)+'\n'+message,'Consume Error')
	pass

func _on_GP_IAP_query_purchases_response(purchases):
	# purchases.status == OK
	_processPurchases(purchases)
	pass

var to_buy_item:String
func commencePurchase(whichIs:String = '', sellSoul:bool = false):
	purchased_subs = true
	to_buy_item = whichIs
	if shangTsung:
		___tebengeItself._acceptDialog('You should see the purchase options\nBuying: ' + to_buy_item, 'Buying now')
		shangTsung.purchase(to_buy_item)
		print('HAVE A SOUL TO SPARE, YOUNG BEING? | buying ' + to_buy_item)
	else:
		___tebengeItself._acceptDialog('Wait, where\'s Shang Tsung??\nBuying: ' + to_buy_item, '404 Google Play Billing Not found!')
		pass
	pass

func checkPurchase(whichIs:String = '', sellSoul:bool = false):
	commencePurchase(whichIs, sellSoul)
	pass

func consumePurchase(whichIs:String = ''):
	if shangTsung:
		var token = listQueryBoughtItem[whichIs].purchase_token
		_debugAlert('Consuming ' + whichIs+'\nToken = ' + token, ' COnsumption')
		shangTsung.consumePurhcase(token)
		pass
	else:
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Tebenge_InsertCoin"):
		insertCoin()
		pass
	pass

func _on_AdMob_banner_loaded():
	___tebengeItself.receive_AdBanner_success()
	pass # Replace with function body.


func _on_AdMob_interstitial_closed():
	___tebengeItself.receive_AdInterstitial_closed()
	pass # Replace with function body.


func _on_AdMob_interstitial_failed_to_load(error_code):
	___tebengeItself.receive_AdInterstitial_failed()
	pass # Replace with function body.


func _on_AdMob_interstitial_loaded():
	___tebengeItself.receive_AdInterstitial_success()
	pass # Replace with function body.

func _on_AdMob_banner_failed_to_load(error_code):
	pass # Replace with function body.


var iWantToQuit:bool = false
func _on_Tebenge_ChangeDVD_Exec():
	pass # Replace with function body.

func _readyToQuitNow():
	if iWantToQuit:
		___tebengeItself.queue_free()
		
		if OS.get_name() == "iOS" || OS.get_name() == "HTML5":
			$BuiltInSystemer/AcceptDialog.window_title = "Notification"
			$BuiltInSystemer/AcceptDialog.dialog_text = "It is now safe to close this app. \n(iOS does not support auto-quit per interface guidelines)\n(HTML5 does not support auto-quit / close tab)"
			$BuiltInSystemer/AcceptDialog.popup_centered()
			pass
		
		get_tree().quit()
	pass

func _on_Tebenge_Shutdown_Exec():
	#TODO: resave all high scores!
	iWantToQuit = true
	___tebengeItself._saveSave()
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Exec() -> void:
	if adInited and not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
		$BuiltInSystemer/AdMob.load_interstitial()
	pass # Replace with function body.

func _on_Tebenge_AdRewarded_Exec() -> void:
	if adInited and not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
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
	if adInited:
		$BuiltInSystemer/AdMob.hide_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Reshow() -> void:
	if adInited and not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
		$BuiltInSystemer/AdMob.show_banner()
	pass # Replace with function body.


func _on_Tebenge_AdBanner_Exec() -> void:
	if adInited:
		pass
	pass # Replace with function body.


func _on_Tebenge_AdRewarded_Reshow() -> void:
	if not ___interstitialDestroyed:
		if adInited and not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
			$BuiltInSystemer/AdMob.show_rewarded_video()
	else:
		_on_AdMob_rewarded('pts',1)
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Reshow() -> void:
	if not ___interstitialDestroyed:
		if adInited and not ___yourSoulsBelongsToShangTsungInsteadOfGoogle:
			$BuiltInSystemer/AdMob.show_interstitial()
		pass
	pass # Replace with function body.


func _on_Tebenge_AdInterstitial_Terminate() -> void:
	if adInited:
#		$BuiltInSystemer/AdMob
		pass
	pass # Replace with function body.


func _on_AdMob_rewarded(currency, ammount) -> void:
	___tebengeItself.receive_AdRewarded_success()
	pass # Replace with function body.


func _on_AdMob_rewarded_video_closed() -> void:
	pass # Replace with function body.


func _on_AdMob_rewarded_video_failed_to_load(error_code) -> void:
	___tebengeItself.receive_AdRewarded_failed()
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
	___tebengeItself.googlePlayLoggedIn(true,userProfile_json,0)
	pass
  
func _on_sign_in_failed(error_code: int) -> void:
	printerr("WERROR login Google Play Faile " + String(error_code))
	___tebengeItself.googlePlayLoggedIn(false,"",error_code)
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

# Span can be: TIME_SPAN_DAILY, TIME_SPAN_WEEKLY, or TIME_SPAN_ALL_TIME
# LeaderboardCollection can be:  COLLECTION_PUBLIC or COLLECTION_FRIENDS
# Callbacks: play_games_services.retrieveLeaderboardScore("LEADERBOARD_ID", "ALL_TIME", "ALL")
func _on_leaderboard_score_retrieved(leaderboardId : String, playerScore : String):
	var score_dictionary: Dictionary = parse_json(playerScore)
	# Using below keys you can retrieve data about a player’s in-game activity
#	score_dictionary["score"] # Player high score
#	score_dictionary["rank"] # Player rank
	pass

func _on_leaderboard_score_retrieve_failed(leaderboardId : String):
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
	___tebengeItself.cloudSavePressYes(name)
	pass

# Callbacks: play_games_services.loadSnapshot("SNAPSHOT_NAME")
func _on_game_load_success(data):
	var game_data:Dictionary
#	if data != null && typeof(data.result) == TYPE_STRING:
#		game_data= parse_json(data)
#	else:
#		game_data = {}
	
	___tebengeItself.receive_PlayService_DownloadSave(data, true)
	pass
	
func _on_game_load_fail():
	___tebengeItself.receive_PlayService_DownloadSave("",false)
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
	___tebengeItself._receiveInsertCoin(creditInserted)
	pass

func useCoin():
	# check if enough
	print("You need " + String(requiresCredit) + " " + "Coins" if requiresCredit > 1 else "Coin")
	if creditInserted > requiresCredit:
		creditInserted -= requiresCredit
		___tebengeItself._receiveCoinEligibilityResult(true, creditInserted)
		print("Coin is enough! Great luck! Now you have " + String(creditInserted))
		pass
	else:
		___tebengeItself._receiveCoinEligibilityResult(false, creditInserted)
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


func _on_Tebenge_PlayBilling_Buy(what) -> void:
	commencePurchase(what)
	pass # Replace with function body.


func _on_Tebenge_PlayBilling_Subscribe(toWhat) -> void:
#	checkPurchase(toWhat)
	commencePurchase(toWhat)
	pass # Replace with function body.


func _on_Tebenge_PlayBilling_Query(what) -> void:
	_queryPurchases(what)
	pass # Replace with function body.


func _on_Tebenge_PlayBilling_Consume(what) -> void:
	consumePurchase(what)
	pass # Replace with function body.


func _on_Tebenge_PlayBilling_Update() -> void:
	pass # Replace with function body.


func _on_Tebenge_PlayBilling_SKU(what) -> void:
	_querySKUs(what)
	pass # Replace with function body.


func _on_Tebenge_saveOK() -> void:
	if iWantToQuit:
		_readyToQuitNow()
	pass # Replace with function body.


func _on_Tebenge_saveFailed() -> void:
	pass # Replace with function body.
