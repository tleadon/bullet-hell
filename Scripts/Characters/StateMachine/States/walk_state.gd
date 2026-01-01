extends State
class_name WalkState

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	if not state_machine.player.move_input:
		Transitioned.emit(self, "idle")
	
	move(delta)
