extends StaticBody3D

@onready var dispense_area = $DispenseArea

@export var AmmoToDispense: int = 5

var canDispense: bool = true


func _ready():
	pass

func _process(delta):
	pass


func _on_dispense_area_body_entered(body):
	if body.is_in_group("PLAYER") and canDispense:
		canDispense = false
		Globals.sprayAmmo += AmmoToDispense
		print("RELOADED", Globals.sprayAmmo)


func _on_dispenser_cooldown_timeout():
	canDispense = true
