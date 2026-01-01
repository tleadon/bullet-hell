extends CharacterBody2D
class_name Enemy

@export_group("Movement")
@export var MAX_SPEED: float
@export var ACCELERATION: float
@export var DRAG: float
@export var STOP_DIS: float

@export_group("Non-Movement Stats")
@export var shoot_rate: float 
@export var bullet_damage: float 
@export var shoot_range: float
@export var max_hp: int
var curr_hp: int


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var avoidance_ray: RayCast2D = $AvoidanceRay
@onready var sprite: Sprite2D = $Sprite
@onready var muzzle: Node2D = $Muzzle
@onready var enemy_bullet_pool = $EnemyBulletPool

var player_dir: Vector2
var player_dist: float
var last_shoot_time: float

func _ready() -> void:
	curr_hp = max_hp

func _process(_delta: float) -> void:
	player_dir = global_position.direction_to(player.global_position)
	sprite.flip_h = player_dir.x < 0
	player_dist = global_position.distance_to(player.global_position)
	
func _physics_process(_delta: float) -> void:
	var move_dir = player_dir
	var local_avoidance_dir = local_avoidance()
	
	if local_avoidance_dir.length() > 0:
		move_dir = local_avoidance_dir
	
	if velocity.length() < MAX_SPEED and player_dist > STOP_DIS:
		velocity += move_dir * ACCELERATION
	else:
		velocity *= DRAG
	move_and_slide()
	
	try_shoot()

func local_avoidance() -> Vector2:
	avoidance_ray.target_position = to_local(player.global_position).normalized()
	avoidance_ray.target_position *= 80
	
	if not avoidance_ray.is_colliding():
		return Vector2.ZERO
		
	var obstacle = avoidance_ray.get_collider()
	
	if obstacle == player:
		return Vector2.ZERO
		
	var obstacle_point = avoidance_ray.get_collision_point()
	var obstacle_dir = global_position.direction_to(obstacle_point)
	
	return Vector2(-obstacle_dir.y,obstacle_dir.x)
		
	
func try_shoot():
	if shoot_range > player_dist:
		if Time.get_unix_time_from_system() - last_shoot_time > shoot_rate:
			shoot()

func shoot():
	last_shoot_time = Time.get_unix_time_from_system()
	var bullet: Bullet = enemy_bullet_pool.spawn()
	bullet.owner_group = self.get_groups()[0]
	bullet.global_position = muzzle.global_position
	bullet.move_dir = muzzle.global_position.direction_to(player.global_position)

func damage_flash():
	sprite.modulate = Color.BLACK
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE

func take_damage(damage: int) -> void:
	curr_hp -= damage
	damage_flash()
	if curr_hp <= 0:
		GlobalSignals.OnEnemyDie.emit(self)
		visible = false

func _on_visibility_changed() -> void:
	if visible:
		set_process(true)
		set_physics_process(true)
		curr_hp = max_hp
	else:
		set_process(false)
		set_physics_process(false)
		global_position = Vector2(0,99999)
