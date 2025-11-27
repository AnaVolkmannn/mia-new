extends Control

@onready var numero_label: Label = $HBoxContainer/numero/Label
@onready var operador_label: Label = $HBoxContainer/operador/Label
@onready var resultado_label: Label = $HBoxContainer/resultado/Label
@onready var drop_area := $HBoxContainer/droparea/DropArea1
@onready var timer := $timer_label
@onready var lifebar := $LifeBar

var current_equation = {}
var can_fail := true

const SAVE_PATH := "user://player_data.json"

func _ready() -> void:
	randomize()
	_generate_new_equation()


# ===================================================
# 🧮 GERA NOVA EQUAÇÃO
# ===================================================
func _generate_new_equation() -> void:
	var operators = ["+", "-", "×"]
	var op = operators[randi() % operators.size()]
	var a = randi_range(1, 9)
	var b = randi_range(1, 9)

	var result: int
	match op:
		"+":
			result = a + b
		"-":
			result = a - b
		"×":
			result = a * b

	current_equation = {"a": a, "b": b, "op": op, "res": result}

	numero_label.text = _to_roman(a)
	operador_label.text = op
	resultado_label.text = _to_roman(result)

	var options = _generate_random_options(b)
	print("🎲 Opções:", options)

	drop_area.number = b
	drop_area.isRight = false
	drop_area.isWrong = false

	var labels = [$Dlabel1, $Dlabel5, $Dlabel10]
	for i in range(labels.size()):
		labels[i].set_values(options[i])

	print("🧮 Nova equação:", a, op, b, "=", result)

# ===================================================
# 🎲 GERA 3 OPÇÕES (UMA CERTA E DUAS ERRADAS)
# ===================================================
func _generate_random_options(correct_value: int) -> Array:
	var opts: Array = [correct_value]
	while opts.size() < 3:
		var rand = randi_range(1, 9)
		if rand not in opts:
			opts.append(rand)
	opts.shuffle()
	return opts

# ===================================================
# 🔢 CONVERTE PARA ROMANO
# ===================================================
func _to_roman(value: int) -> String:
	if value <= 0:
		return "N"
	if value > 3999:
		return str(value)
	var numerals = [
		["M", 1000], ["CM", 900], ["D", 500], ["CD", 400],
		["C", 100], ["XC", 90], ["L", 50], ["XL", 40],
		["X", 10], ["IX", 9], ["V", 5], ["IV", 4], ["I", 1],
	]
	var result := ""
	var remaining = value
	for pair in numerals:
		while remaining >= pair[1]:
			result += pair[0]
			remaining -= pair[1]
	return result

# ===================================================
# 🎯 CHECA SE A RESPOSTA ESTÁ CERTA
# ===================================================
func _process(_delta: float) -> void:
	if timer.timeout:
		print("💀 tempo acabou! tentando novamente")
		get_tree().change_scene_to_file("res://scenes/main.tscn")

	if drop_area.isRight:
		print("✅ Mini-game concluído!")
		_save_progress()
		get_tree().change_scene_to_file("res://scenes/main.tscn")

	elif drop_area.isWrong and can_fail:
		can_fail = false
		lifebar.set_chances( lifebar.current_chances - 1)
		print("❌ Resposta errada! Chances restantes:", lifebar.current_chances)

		if lifebar.current_chances <= 0:
			print("💀 Sem chances! tentando novamente")
			await get_tree().create_timer(1.5).timeout
			lifebar.set_chances(lifebar.max_chances)
			timer.restart()
			_generate_new_equation()
		else:
			print("🔄 Tentando novamente...")
			await get_tree().create_timer(1.0).timeout

		can_fail = true

# ===================================================
# 💾 SALVA PROGRESSO
# ===================================================
func _save_progress() -> void:
	var data = {}
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()

	if typeof(data) != TYPE_DICTIONARY:
		data = {}

	if not data.has("scrolls"):
		data["scrolls"] = {"found": [], "total": 0}

	data["minigame_done"] = true
	if "scroll_2" not in data["scrolls"]["found"]:
		data["scrolls"]["found"].append("scroll_2")

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("📜 Progresso salvo.")
