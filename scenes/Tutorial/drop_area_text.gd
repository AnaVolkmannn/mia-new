extends Label

@export var ExpectedText: String = ""
@export var isRight: bool = false
@export var isWrong: bool = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent := area.get_parent()

	# O item arrastado deve ser um Label
	if not (parent is Label):
		print("⚠️ O objeto arrastado não é Label:", parent)
		return

	var value: String = parent.text

	print("👉 ENTER value =", value, " | esperado =", ExpectedText)

	isRight = (value == ExpectedText)
	isWrong = (value != ExpectedText)


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent := area.get_parent()

	if not (parent is Label):
		return

	var value: String = parent.text

	print("👈 EXIT value =", value, " | esperado =", ExpectedText)

	if value == ExpectedText:
		isRight = false
	else:
		isWrong = false
