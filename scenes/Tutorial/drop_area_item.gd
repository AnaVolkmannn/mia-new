extends Panel  # ou Control, depende do node

@export var ExpectedText: String = ""
@export var isRight: bool = false
@export var isWrong: bool = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not parent.has_property("text_value"):
		print("⚠️ Objeto arrastado não tem text_value:", parent)
		return

	var value: String = parent.text_value
	isRight = (value == ExpectedText)
	isWrong = (value != ExpectedText)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if not parent.has_property("text_value"):
		return

	isRight = false
	isWrong = false
