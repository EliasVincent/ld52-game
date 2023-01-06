extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var MOUSE_SENSITIVITY = 0.5
@export var RIGHT_STICK_SENSITIVITY = 1.0

@onready var camera = $Camera3D

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

# func input is called every time *any* input happens
func _input(event):
	# MOUSE INPUT
	if event is InputEventMouseMotion:
		# get rotation degrees of the Player
		# relative means how much the mouse has moved along x axis,
		# multiplying that by our sensitivity and applying that to the rotation of the player
		# as a result this will turn the player left and right
		rotation_degrees.y -= MOUSE_SENSITIVITY * event.relative.x
		# now the same thing for the camera
		camera.rotation_degrees.x -= MOUSE_SENSITIVITY * event.relative.y
		# clamp restricts the rotation to -/+90 degrees on top and bottom
		# otherwise the movement would be weird
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
