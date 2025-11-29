extends Label

@export var Number: int = 0
@export var isRight: bool = false
@export var isWrong: bool = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()
	print(parent.get("number"))
	if not parent.has_method("get"): # segurança extra
		return

	var value = parent.get("number")

	if typeof(value) != TYPE_INT:
		print("⚠️ Pai não possui Number válido:", parent)
		return

	print("👉 ENTER value =", value, " | esperado =", Number)

	isRight = (value == Number)
	isWrong = (value != Number)
	
	print(isRight)


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent := area.get_parent()

	if not parent.has_method("get"):
		return

	var value = parent.get("number")

	if typeof(value) != TYPE_INT:
		return

	print("👈 EXIT value =", value, " | esperado =", Number)

	if value == Number:
		isRight = false
	else:
		isWrong = false
