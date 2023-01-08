extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.5
@export var RIGHT_STICK_SENSITIVITY = 1.0

@onready var camera = $Camera3D
@onready var parentNode = get_tree().get_nodes_in_group("LEVEL")[0]
@onready var spray_particles = %SprayParticles
@onready var harvestTimer = $HarvestTimer
@onready var spray_time = $SprayTime
@onready var spray_cooldown = $SprayCooldown
@onready var spray_1_sound = %Spray1Sound
@onready var animation_player = $AnimationPlayer
@onready var player_hurt = %PlayerHurt
@onready var harvesting_sound = %HarvestingSound
@onready var harvest_success = %HarvestSuccess
@onready var deposit_sound = %DepositSound



var canDeposit: bool = false
var canHarvest: bool = false
var canAttack: bool = true
var canSpray: bool = true
var isSpraying: bool = false

var boxToHarvest

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var rsX: float
var rsY: float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# right analog stick movement
	#var rsV = Input.get_vector("right_stick_left", "right_stick_right", "right_stick_up", "right_stick_down")
	#rotation_degrees.y -= RIGHT_STICK_SENSITIVITY * rsV[0]
	#camera.rotation_degrees.x -= RIGHT_STICK_SENSITIVITY * rsV[1]
	
	move_and_slide()

func _process(delta):
	if Globals.playerHp <= 0:
		die()

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENSITIVITY * event.relative.x
		camera.rotation_degrees.x -= MOUSE_SENSITIVITY * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if Input.is_action_just_pressed("action") and canDeposit:
		depositCrops()
	if Input.is_action_just_pressed("action") and canHarvest and boxToHarvest.canBeHarvested == true:
		canHarvest = false
		parentNode.harvestingEnabled()
		parentNode.harvestTooltipDisabled()
		beginHarvest(boxToHarvest)
	
	if Input.is_action_just_pressed("shoot") and canSpray and Globals.sprayAmmo > 0:
		canSpray = false
		isSpraying = true
		Globals.sprayAmmo -= 1
		spray()

func depositCrops() -> void:
	Globals.totalCrops += Globals.cropsHeld
	Globals.cropsHeld = 0
	deposit_sound.play()

func beginHarvest(boxToHarvest) -> void:
	boxToHarvest.harvestAnim()
	harvesting_sound.play()
	harvestTimer.start()

func harvest(boxToHarvest) -> void:
	boxToHarvest.setToHarvested()
	parentNode.harvestingDisabled()
	harvest_success.play()
	Globals.cropsHeld += 1

func hurt(DAMAGE, Vector3):
	#print("PLAYER GOT HURT", DAMAGE)
	player_hurt.play()
	Globals.playerHp -= 1

func die():
	animation_player.play("DIE")

func goGameOver():
	print("YOU ARE DEAD")
	GlobalSounds.player_die.play()
	get_tree().change_scene_to_file("res://ui/game_over.tscn")

func spray():
	print("spraying")
	spray_time.start()
	spray_particles.emitting = false
	spray_particles.emitting = true
	spray_1_sound.play()

func _on_event_hitbox_area_entered(area):
	if area.is_in_group("HARVESTBOX"):
		parentNode.toggleDepositTooltip()
		canDeposit = true
	if area.is_in_group("CROPSOIL"):
		canHarvest = true
		boxToHarvest = area.get_parent()
		parentNode.harvestTooltipEnabled()


func _on_event_hitbox_area_exited(area):
	if area.is_in_group("HARVESTBOX"):
		parentNode.toggleDepositTooltip()
		canDeposit = false
	if area.is_in_group("CROPSOIL"):
		canHarvest = false
		harvestTimer.stop()
		boxToHarvest = area.get_parent()
		parentNode.harvestTooltipDisabled()
		parentNode.harvestingDisabled()


func _on_harvest_timer_timeout():
	print("harvest timeout")
	harvest(boxToHarvest)


func _on_spray_time_timeout():
	isSpraying = false
	spray_cooldown.start()


func _on_spray_cooldown_timeout():
	canSpray = true


func _on_spray_hit_box_body_entered(body):
	pass


func _on_spray_hit_box_body_exited(body):
	pass # Replace with function body.
