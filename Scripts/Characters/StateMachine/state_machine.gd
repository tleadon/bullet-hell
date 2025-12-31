extends Node
class_name StateMachine

@export var initial_state: State
var current_state: State
var states: Dictionary[String, State] = {}
@onready var player: PlayerController = $".."

func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name.to_lower()] = child
			child.Transitioned.connect(change_state)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.process_update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
		
func change_state(state: State, new_state_name: String):
	print(state.name, "->", new_state_name)
	if state != current_state:
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if new_state == current_state:
		push_error("new state can't equal current state bozo")
	assert(new_state, "State not found: " + new_state_name)
	
	if current_state:
		current_state.exit()
		
	new_state.enter()
	current_state = new_state
	
