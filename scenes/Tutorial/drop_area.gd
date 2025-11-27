extends Label
@export var number = 0
@export var isRight = false
@export var isWrong = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	# Verifica se o objeto arrastável tem o valor correto
	print("entered: ", area.name)
	if area.name.to_int() == number:
		isRight = true
	if area.name.to_int() != number:
		isWrong = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	print("exited: ", area.name)
	if area.name.to_int() == number:
		isRight = false
	if area.name.to_int() != number:
		isWrong = false
	pass # Replace with function body.
