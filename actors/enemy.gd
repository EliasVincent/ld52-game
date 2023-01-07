extends CharacterBody3D

@export var MOVE_SPEED = 100.0
@export var ROTATION_SPEED = 50.0
@export var DAMAGE = 1.0
@export var ATTACK_RATE = 0.5
@export var ATTACK_RANGE = 2.0

@onready var attackTimer = $AttackTimer
@onready var chaseTimer = $ChaseTimer
@onready var player : CharacterBody3D
@onready var nav: NavigationAgent3D
@onready var collision = $CollisionShape3D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

enum STATES {IDLE, CHASE, ATTACK, DEAD}
var curr_state = STATES.IDLE

var can_attack = true
var frozen = false
var isInArea = false
var playerBody: CharacterBody3D
var playerInAreaAndLOS = false
var inSpray = false

var path: NodePath
var path_node = 0

signal attack

func _ready():
	player = get_tree().get_nodes_in_group("PLAYER")[0]
	nav = get_parent()
	init()

func init():
	attackTimer.wait_time = ATTACK_RATE
	attackTimer.one_shot = true
#	healthBar.update(healthManager.current_health, healthManager.max_health)
#	healthManager.connect("dead", self, "set_state_dead")

	set_state_idle()


func _physics_process(delta):
	if frozen:
		return
	match curr_state:
		STATES.IDLE:
			process_state_idle(delta)
		STATES.CHASE:
			process_state_chase(delta)
		STATES.ATTACK:
			process_state_attack(delta, playerBody)
		STATES.DEAD:
			process_state_dead(delta)
	
	if inSpray:
		if player.isSpraying == true:
			hurt()

# SET states
func set_state_idle():
	curr_state = STATES.IDLE
func set_state_chase():
	print("set CHASE")
	curr_state = STATES.CHASE
func set_state_attack():
	print("set ATTACK")
	curr_state = STATES.ATTACK
func set_state_dead():
	curr_state = STATES.DEAD
	frozen = true
	collision.disabled = true
	queue_free()
# PROCESS states
func process_state_idle(delta):
	if playerInAreaAndLOS:
		set_state_chase()
func process_state_chase(delta):
	if isInArea and can_attack:
		if playerBody != null:
			set_state_attack()
	
	nav.target_location = player.global_position
	var target = nav.get_next_location()
	#var v = (target - player.global_position).normalized()
	#nav.set_velocity(v)
	var goal_pos = target
	var dir = goal_pos - global_transform.origin
	dir.y = 0
	velocity = dir
	
	
	var angle = atan2(dir.x, dir.z)
	var angle_diff = angle - rotation.y
	if angle_diff > PI:
		angle_diff -= 2*PI
	if angle_diff < -PI:
		angle_diff += 2*PI
	rotation.y += angle_diff * delta * ROTATION_SPEED
	#self.global_position = target
	move_and_slide()
func process_state_chase_old(delta):
	# set attack
	if isInArea and can_attack:
		if playerBody != null:
			set_state_attack()
	# move towards player
	#var target_pos = player.global_transform.origin
	#path = nav.get_simple_path(global_transform.origin, target_pos)
	var target_pos = player
	path = nav.get_path_to(target_pos)
	pass
	var goal_pos = target_pos

	#if path.size() > 1:
		#goal_pos = path[1]
	#goal_pos = path.vector
	
	var dir = goal_pos - global_transform.origin
	dir.y = 0 # IMPORTANT IGNORE Y JUMP DOES NOT WORK
	# rotate towards target
	var angle = atan2(dir.x, dir.z)
	var angle_diff = angle - rotation.y
	if angle_diff > PI:
		angle_diff -= 2*PI
	if angle_diff < -PI:
		angle_diff += 2*PI
	rotation.y += angle_diff * delta * ROTATION_SPEED
	# move towards target
	#move_and_slide(dir.normalized() * delta * MOVE_SPEED, Vector3.UP)
	move_and_slide()

func process_state_attack(delta, playerBody: CharacterBody3D):
		can_attack = false
		attackTimer.start()
		playerBody.hurt(DAMAGE, Vector3())
		set_state_idle()
func process_state_dead(delta):
	pass


func hurt():
	#hurt_sound_1.play(0.0)
	#healthManager.hurt(damage, dir)
	animationPlayer.play("DIE")




func _on_attack_timer_timeout():
	can_attack = true


func _on_s_damage_area_body_entered(body):
	isInArea = true
	if body.is_in_group("player"):
		playerBody = body
		if can_attack:
			set_state_attack()

func _on_s_damage_area_body_exited(body):
	isInArea = false



func _on_los_area_body_entered(body):
	if body == player:
		playerInAreaAndLOS = true
		set_state_chase()


func _on_los_area_body_exited(body):
	if body == player:
		playerInAreaAndLOS = false
		set_state_idle()



func _on_hurt_hitbox_area_entered(area):
	print(area)
	if area.is_in_group("SPRAY"):
		print("in spray")
		inSpray = true


func _on_hurt_hitbox_area_exited(area):
	if area.is_in_group("SPRAY"):
		inSpray = false
