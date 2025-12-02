extends Area2D

@export var dialog_view_path: NodePath
@export var text: String = ""

var triggered := false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if triggered:
		return
	if body.name == "mia": # ou verifique por um grupo, tipo body.is_in_group("player")
		var dialog_view = get_node(dialog_view_path)
		dialog_view.open_dialog(text)
		triggered = true
