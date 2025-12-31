extends CharacterBody2D
class_name PlayerController

@export var shoot_rate: float = 0.1
var last_shoot_time: float
@onready var muzzle: Node2D = $Muzzle

var move_input: Vector2
var facing_direction: Vector2
@onready var bullet_pool: NodePool = $PlayerBulletPool

@onready var anim: AnimatedSprite2D = $Sprite

func _physics_process(delta: float) -> void:
	move_input = Input.get_vector("move_left","move_right","move_up","move_down")

	if Input.is_action_pressed("shoot"):
		if Time.get_unix_time_from_system() - last_shoot_time > shoot_rate:
			shoot()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()

func shoot():
	last_shoot_time = Time.get_unix_time_from_system()
	var bullet: Bullet = bullet_pool.spawn()
	bullet.owner_group = self.get_groups()[0]
	bullet.global_position = muzzle.global_position
	var mouse_pos: Vector2 = get_global_mouse_position()
	bullet.move_dir = muzzle.global_position.direction_to(mouse_pos)

func take_damage():
	pass
