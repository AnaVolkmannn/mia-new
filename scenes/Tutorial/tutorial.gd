extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $HBoxContainer/Normal/DropArea1.isRight and $HBoxContainer/Normal/DropArea10.isRight and $HBoxContainer/Normal/DropArea5.isRight :
		print("tudo certo")
		get_tree().change_scene_to_file("res://main.tscn")
