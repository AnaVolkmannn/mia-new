extends Control

# Labels de números romanos arrastáveis
@onready var labels = [
	$Dlabel1,
	$Dlabel5,
	$Dlabel10
]

# Áreas de drop correspondentes
@onready var drop_labels = [
	$HBoxContainer/Normal/DropArea1,
	$HBoxContainer/Normal/DropArea5,
	$HBoxContainer/Normal/DropArea10
]

@onready var normal_labels = [
	$HBoxContainer/romanos/Label,
	$HBoxContainer/romanos/Label2,
	$HBoxContainer/romanos/Label3
]

func _ready() -> void:
	randomize()
	_generate_random_numbers()

# ===================================================
# 🔢 GERA NÚMEROS ROMANOS ALEATÓRIOS
# ===================================================
func _generate_random_numbers() -> void:
	var generated = []
	while generated.size() < 3:
		var n = randi_range(1, 20)
		if n not in generated:
			generated.append(n)

	print("🎲 Números gerados:", generated)

	# Define os valores nas labels e drop areas
	for i in range(3):
		var num = generated[i]
		labels[i].set_values(num)
		normal_labels[i].text = str(num)
		drop_labels[i].Number = num
		drop_labels[i].isRight = false
	while generated.size() < 3:
		var n = randi_range(1, 20)
		if n not in generated:
			generated.append(n)

	generated.sort() # garante que a ordem corresponda aos labels fixos

# ===================================================
# ⚙️ LOOP DE CHECAGEM
# ===================================================
func _process(_delta: float) -> void:
	if drop_labels[0].isRight and drop_labels[1].isRight and drop_labels[2].isRight:
		print("✅ Tudo certo, tutorial concluído!")
		_save_progress()
		get_tree().change_scene_to_file("res://scenes/main.tscn")

# ===================================================
# 💾 SALVA PROGRESSO DO TUTORIAL
# ===================================================
func _save_progress() -> void:
	var save_path = "user://player_data.json"
	var data = {}

	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()

	if typeof(data) != TYPE_DICTIONARY:
		data = {}
	if not data.has("scrolls"):
		data["scrolls"] = {"found": [], "total": 0}

	data["tutorial_done"] = true

	if "scroll_1" not in data["scrolls"]["found"]:
		data["scrolls"]["found"].append("scroll_1")
		data["scrolls"]["total"] = 4
		print("📜 Jogador recebeu o primeiro pergaminho!")

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

# ===================================================
# 🔢 CONVERSOR DINÂMICO PARA ROMANO
# ===================================================
func _to_roman(value: int) -> String:
	if value <= 0:
		return "N" # (nulla)
	if value > 3999:
		return str(value)

	var numerals = [
		["M", 1000],
		["CM", 900],
		["D", 500],
		["CD", 400],
		["C", 100],
		["XC", 90],
		["L", 50],
		["XL", 40],
		["X", 10],
		["IX", 9],
		["V", 5],
		["IV", 4],
		["I", 1],
	]

	var result := ""
	var remaining = value

	for pair in numerals:
		var roman_char = pair[0]
		var arabic_value = pair[1]

		while remaining >= arabic_value:
			result += roman_char
			remaining -= arabic_value

	return result
