extends StaticBody2D

export(bool) var destroysAd:bool = false
export(int) var howManyNeededToKillAd:int = 10
export(PackedScene) var theHuertParticle:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/AdHuertParticle2D.tscn")
export(PackedScene) var theMurderedParticle:PackedScene = load("res://GameDVDCardtridge/Tebenge/SpareParts/AdHuertParticle2D.tscn")
var currentAdHit:int = 0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal murderTheAd()
func huertAd():
	if destroysAd:
		if currentAdHit < 10:
			var instanceHuert = theHuertParticle.instance()
			instanceHuert.set_position(Vector2(1920/2,0))
			get_parent().add_child(instanceHuert)
			$DootHit.play()
			currentAdHit += 1
			pass
		else:
			var instanceMurder = theMurderedParticle.instance()
			instanceMurder.set_position(Vector2(1920/2,0))
			get_parent().add_child(instanceMurder)
			$AdMurdered.play()
			emit_signal("murderTheAd")
			currentAdHit = 0
			pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
