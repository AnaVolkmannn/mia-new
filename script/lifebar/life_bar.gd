extends HBoxContainer

var max_chances: int = 2
var current_chances: int = 2
const SAVE_PATH := "user://player_data.json"

func _ready() -> void:
	var data = _load_player_data()
	var difficulty = data.get("difficulty", "medio")
	print(difficulty)
	match difficulty:
		"easy":
			max_chances = 5
		"medium":
			max_chances = 3
		"hard":
			max_chances = 1
		_:
			max_chances = 2

	current_chances = max_chances
	_update_hearts()

# ===================================================
# 🔁 Atualiza visibilidade dos corações existentes
# ===================================================
func _update_hearts() -> void:
	var hearts = get_children()
	for i in range(hearts.size()):
		# Mostra apenas os corações que ainda “sobram”
		hearts[i].visible = i < current_chances

# ===================================================
# ❤️ Altera número de chances e atualiza
# ===================================================
func set_chances(new_value: int) -> void:
	current_chances = clamp(new_value, 0, max_chances)
	_update_hearts()

func decrease(amount: int = 1) -> void:
	set_chances(current_chances - amount)

# ===================================================
# 📁 Lê dificuldade do save
# ===================================================
func _load_player_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {"difficulty": "medio"}
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.parse_string(content)
	if typeof(json) == TYPE_DICTIONARY:
		return json
	return {"difficulty": "medio"}
