extends StaticBody3D

@onready var dispense_area = $DispenseArea
@onready var dispenser_cooldown = $DispenserCooldown

@export var AmmoToDispense: int = 5

var canDispense: bool = true


func _ready():
	canDispense = true

func _process(delta):
	pass


func _on_dispense_area_body_entered(body):
	if body.is_in_group("PLAYER") and canDispense:
		canDispense = false
		Globals.sprayAmmo += AmmoToDispense
		GlobalSounds.recharge.play()
		dispenser_cooldown.start()
		print("RELOADED", Globals.sprayAmmo)


func _on_dispenser_cooldown_timeout():
	canDispense = true
