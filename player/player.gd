extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.5
@export var RIGHT_STICK_SENSITIVITY = 1.0

@onready var camera = $Camera3D
@onready var parentNode = get_tree().get_nodes_in_group("LEVEL")[0]

@onready var harvestTimer = $HarvestTimer

var canDeposit: bool = false
var canHarvest: bool = false
var canAttack: bool = true

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


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENSITIVITY * event.relative.x
		camera.rotation_degrees.x -= MOUSE_SENSITIVITY * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if Input.is_action_just_pressed("action") and canDeposit:
		depositCrops()
	if Input.is_action_just_pressed("action") and canHarvest:
		canHarvest = false
		parentNode.harvestingEnabled()
		parentNode.harvestTooltipDisabled()
		beginHarvest(boxToHarvest)

func depositCrops() -> void:
	Globals.totalCrops += Globals.cropsHeld
	Globals.cropsHeld = 0

func beginHarvest(boxToHarvest) -> void:
	boxToHarvest.harvestAnim()
	harvestTimer.start()

func harvest(boxToHarvest) -> void:
	boxToHarvest.setToHarvested()
	parentNode.harvestingDisabled()
	Globals.cropsHeld += 1

func hurt(DAMAGE, Vector3):
	print("PLAYER GOT HURT", DAMAGE)

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
