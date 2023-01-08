extends Node3D

@export var enemyToSpawn: PackedScene
@export var minEnemies: int = 1
@export var maxEnemies: int = 3

@onready var nav: NavigationAgent3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnEnemy():
	var enemy = enemyToSpawn.instantiate()
	get_parent().add_child(enemy)
	enemy.player = get_tree().get_nodes_in_group("PLAYER")[0]
	enemy.nav = get_parent()
	enemy.global_position = self.global_position

func _on_timer_timeout():
	spawnEnemy()
