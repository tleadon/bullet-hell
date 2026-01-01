extends Area2D
class_name Bullet

@export var speed: float = 200.0
@export var owner_group: String
@onready var destroy_timer: Timer = $DestroyTimer

var move_dir: Vector2

func _physics_process(delta: float) -> void:
	translate(move_dir * speed * delta)
	rotation = move_dir.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(owner_group):
		return
	
	if body.has_method("take_damage"):
		body.take_damage()
		print("ouch!")
		visible = false
	

func _on_destroy_timer_timeout() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible and destroy_timer:
		destroy_timer.start()
