extends Camera2D

@onready var target = $"../Player"
@export var follow_rate: float = 2.0

func _process(delta: float) -> void:
	global_position = lerp(global_position, target.global_position, follow_rate * delta)
