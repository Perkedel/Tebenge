extends RigidBody2D

var active:bool = false
export(float) var speed:float = 50
export(bool) var moves_wildly:bool = false
export(float) var lifespanTimer = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = lifespanTimer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if active:
		linear_velocity
	pass

func positionNow(locate:Vector2):
	position = locate
	pass

func runNow(velocite:Vector2):
#	apply_central_impulse(velocite * speed)
	linear_velocity = velocite * speed
	$Timer.start()
	pass

signal destroying()
func amDestroy():
	emit_signal("destroying")
	queue_free()
	pass

func _on_Timer_timeout():
	amDestroy()
	pass # Replace with function body.


func _on_TebengeBullet_body_entered(body):
	pass # Replace with function body.
