extends CharacterBody2D

const SPEED = 300.0

@onready var anim = $AnimatedSprite2D  # referência ao nó de animação

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Aplica o movimento
	velocity = direction * SPEED
	move_and_slide()

	# Atualiza a animação com base na direção
	if direction == Vector2.ZERO:
		anim.stop()  # parado
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("right")
			else:
				anim.play("left")
		else:
			if direction.y > 0:
				anim.play("front")
			else:
				anim.play("back")
