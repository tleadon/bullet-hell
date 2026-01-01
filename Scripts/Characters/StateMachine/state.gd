extends Node
class_name State

signal Transitioned(state: State, new_state_name: String)

var state_machine: StateMachine 

@export_group("Movement")
@export var MAX_SPEED: float = 100
@export var ACCELERATION: float = 0.2
@export var BRAKING: float = 0.15

var is_running: bool = false
var target_speed: float
var current_smoothing: float
var target_vel: Vector3
var direction: String

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_update(_delta: float) -> void:
	animate()

func physics_update(_delta: float) -> void:
	pass

func wants_jump():
	pass
		
func move(_delta: float):
	if state_machine.player.move_input:
		state_machine.player.facing_direction = state_machine.player.move_input
		state_machine.player.velocity = state_machine.player.velocity.lerp(
			state_machine.player.move_input * MAX_SPEED, 
			BRAKING
			)
	else:
		state_machine.player.velocity = state_machine.player.velocity.lerp(
			Vector2.ZERO, 
			BRAKING
			)
	state_machine.player.move_and_slide()

func animate():
	var anim_name: String = name.to_lower()
	state_machine.player.anim.flip_h = state_machine.player.get_global_mouse_position().x > state_machine.player.position.x
	if state_machine.player.anim.flip_h and (
		state_machine.player.muzzle.position.x < 0
	):
		state_machine.player.muzzle.position.x = state_machine.player.muzzle.position.x * -1
	elif not state_machine.player.anim.flip_h and (
		state_machine.player.muzzle.position.x > 0
	):
		state_machine.player.muzzle.position.x = state_machine.player.muzzle.position.x * -1
	state_machine.player.anim.play(anim_name)

func find_direction() -> String:
	
	return direction
