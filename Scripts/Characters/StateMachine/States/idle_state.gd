extends State
class_name IdleState

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if state_machine.player.move_input:
		Transitioned.emit(self, "walk")

	move(delta)
