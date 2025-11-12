extends Control

const SAVE_PATH := "user://player_data.json"

func _ready() -> void:
	var data = _load_player_data()

	if data.has("tutorial_done") and data["tutorial_done"]:
		_change_scene_to_main()
	else:
		print("Jogador ainda não completou o tutorial")

func _on_play_pressed() -> void:
	var data = _load_player_data()

	if data.has("tutorial_done") and data["tutorial_done"]:
		_change_scene_to_main()
	else:
		get_tree().change_scene_to_file("res://scenes/Tutorial/tutorial.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _change_scene_to_main() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

# -------------------------
# Funções auxiliares
# -------------------------
func _load_player_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.parse_string(content)
	if typeof(json) == TYPE_DICTIONARY:
		return json
	else:
		return {}

func _save_player_data(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
