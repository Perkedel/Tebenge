extends BaseOD

func _notification(what: int) -> void:
	if visible:
		match(what):
			NOTIFICATION_FOCUS_EXIT:
				pass
			NOTIFICATION_WM_FOCUS_IN:
				pass
			NOTIFICATION_WM_FOCUS_OUT:
				$PauseButton.pressed = true
				pass
			_:
				pass
		
		pass
	pass
