extends BaseOD


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var play_games_services:Object
var is_play_games_signed_in:bool = false
var is_play_games_available:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")
		pass
	else:
		$LogOutInButton.text = "No Google Play"
		pass
	
#	_postCheckGooglePlay()
	pass # Replace with function body.

func _postCheckGooglePlay():
	if play_games_services != null:
		#is_play_games_available = play_game_services.isGooglePlayServicesAvailable()
		is_play_games_signed_in = play_games_services.isSignedIn()
		
		# yess! the button that change functionality as the pointing label text changes whoahow!!!
		if is_play_games_signed_in:
			$LogOutInButton.text = "Logout"
			pass
		else:
			$LogOutInButton.text = "Login"
			pass
	else:
		print("No Play Service available. Yaah")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_VISIBILITY_CHANGED:
		if visible:
			_postCheckGooglePlay()
			pass
		pass
	pass
