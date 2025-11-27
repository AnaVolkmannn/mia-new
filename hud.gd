extends CanvasLayer

const SAVE_PATH := "user://player_data.json"

func _ready() -> void:
	_update_scroll_label()


func _process(delta: float) -> void:
	# Caso queira atualizar em tempo real, pode deixar ativo:
	# _update_scroll_label()
	pass


func _update_scroll_label() -> void:
	var data = _load_player_data()

	var found_count = 0
	var total_count = 0

	if data.has("scrolls"):
		if data["scrolls"].has("found"):
			found_count = len(data["scrolls"]["found"])
		if data["scrolls"].has("total"):
			total_count = data["scrolls"]["total"]

	# Atualiza o texto da Label
	$Control/HBoxContainer/MarginContainer/Label.text = "Pergaminhos: %d / %d" % [found_count, total_count]


func _load_player_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {
			"tutorial_done": false,
			"scrolls": {"found": [], "total": 0}
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
			"scrolls": {"found": [], "total": 0}
		}
