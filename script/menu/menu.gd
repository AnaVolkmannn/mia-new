extends Control

const SAVE_PATH := "user://player_data.json"

@onready var difficulty_selector: OptionButton = $VBoxContainer/DifficultyOption

func _ready() -> void:
	var data = _load_player_data()

	# Cria opções no seletor
	difficulty_selector.clear()
	difficulty_selector.add_item("Fácil", 0)
	difficulty_selector.add_item("Médio", 1)
	difficulty_selector.add_item("Difícil", 2)

	# Define dificuldade atual
	var current_difficulty = data.get("difficulty", "medium")
	match current_difficulty:
		"easy":
			difficulty_selector.select(0)
		"medium":
			difficulty_selector.select(1)
		"hard":
			difficulty_selector.select(2)

func _on_play_pressed() -> void:
	var data = _load_player_data()

	if data.has("tutorial_done") and data["tutorial_done"]:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/Tutorial/tutorial.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_2_pressed() -> void:
	_reset_progress()
	get_tree().change_scene_to_file("res://scenes/Tutorial/tutorial.tscn")

func _on_difficulty_option_item_selected(index: int) -> void:
	var difficulties = ["easy", "medium", "hard"]
	var selected = difficulties[index]

	var data = _load_player_data()
	data["difficulty"] = selected
	_save_player_data(data)
	print("🎚️ Dificuldade definida como:", selected)

# -------------------------
# Funções auxiliares
# -------------------------
func _load_player_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {
			"tutorial_done": false,
			"scrolls": {"found": [], "total": 0},
			"difficulty": "medium"
		}

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.parse_string(content)
	if typeof(json) == TYPE_DICTIONARY:
		return json
	else:
		return {
			"tutorial_done": false,
			"scrolls": {"found": [], "total": 0},
			"difficulty": "medium"
		}

func _save_player_data(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func _reset_progress() -> void:
	var data = {
		"tutorial_done": false,
		"scrolls": {"found": [], "total": 0},
		"difficulty": "medium"
	}
	_save_player_data(data)
	print("🔄 Progresso completamente reiniciado!")
