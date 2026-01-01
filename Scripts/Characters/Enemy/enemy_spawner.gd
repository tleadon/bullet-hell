extends Node
class_name EnemySpawner

@export var enemy_pool: NodePool
@export var spawn_points: Array[Node2D]

@export var start_enemy_per_second: float = 0.5
@export var enemies_per_second_increase: float = 0.1

@onready var enemies_per_second: float = start_enemy_per_second
var spawn_rate: float

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
    _on_spawn_timer_timeout()

func _process(delta: float) -> void:
    enemies_per_second += enemies_per_second_increase * delta
    spawn_rate = 1.0 / enemies_per_second

func _on_spawn_timer_timeout() -> void:
    var enemy = enemy_pool.spawn()
    if enemy != null:
        enemy.global_position = spawn_points.pick_random().global_position
        spawn_timer.start(spawn_rate)