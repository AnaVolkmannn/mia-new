extends Control

# --- NODES ---
@onready var pergunta_label: Label = $Pergunta/Label
@onready var drop_area := $HBoxContainer/droparea/DropArea   # drop_text.gd
@onready var timer := $timer_label
@onready var lifebar := $LifeBar

@onready var option_labels := [
	$Dlabel,
	$Dlabel2,
	$Dlabel3
]

var can_fail := true
var correct_streak := 0   # ⭐ AGORA TEM STREAK
const SAVE_PATH := "user://player_data.json"

# --- LISTA DE PERGUNTAS ---
var trivia_questions = [
	{
		"question": "Quem foi o primeiro imperador de Roma?",
		"correct": "Augusto",
		"wrong": ["Nero", "Calígula"]
	},
	{
		"question": "Qual era a língua oficial do Império Romano?",
		"correct": "Latim",
		"wrong": ["Grego", "Aramaico"]
	},
	{
		"question": "Qual construção famosa foi usada para batalhas de gladiadores?",
		"correct": "Coliseu",
		"wrong": ["Panteão", "Circo Máximo"]
	},
	{
		"question": "Que rio corta a cidade de Roma?",
		"correct": "Tibre",
		"wrong": ["Danúbio", "Pó"]
	}
]


func _ready() -> void:
	randomize()
	_generate_new_question()


# ===================================================
# 🧠 GERA NOVA PERGUNTA
# ===================================================
func _generate_new_question() -> void:
	var item = trivia_questions[randi() % trivia_questions.size()]

	pergunta_label.text = item["question"]

	var options = [item["correct"]]
	options.append_array(item["wrong"])
	options.shuffle()

	for i in range(3):
		option_labels[i].set_text_value(options[i])

	drop_area.ExpectedText = item["correct"]
	drop_area.isRight = false
	drop_area.isWrong = false

	print("🧠 Pergunta:", item["question"])
	print("➡️ Opções:", options)


# ===================================================
# 🎯 CHECA SE A RESPOSTA ESTÁ CERTA (3 ACERTOS PARA VENCER)
# ===================================================
func _process(_delta: float) -> void:
	if timer.timeout:
		print("💀 Tempo acabou, retornando ao hub")
		get_tree().change_scene_to_file("res://scenes/main.tscn")


	# -----------------------------------------------
	# ⭐ ACERTOU!
	# -----------------------------------------------
	if drop_area.isRight:
		drop_area.isRight = false   # limpar estado
		drop_area.isWrong = false

		correct_streak += 1
		print("✅ Acerto:", correct_streak, "/ 3")

		# Finaliza minigame
		if correct_streak >= 3:
			print("🏆 Trivia concluída com 3 acertos!")
			_save_progress()
			get_tree().change_scene_to_file("res://scenes/main.tscn")
			return

		# Próxima pergunta
		await get_tree().create_timer(0.8).timeout
		_generate_new_question()


	# -----------------------------------------------
	# ❌ ERROU!
	# -----------------------------------------------
	elif drop_area.isWrong and can_fail:
		can_fail = false

		drop_area.isRight = false
		drop_area.isWrong = false

		lifebar.set_chances(lifebar.current_chances - 1)
		print("❌ Resposta errada! Chances:", lifebar.current_chances)

		correct_streak = 0  # ⭐ PERDE STREAK

		if lifebar.current_chances <= 0:
			print("💀 Sem vidas! Reiniciando perguntas")
			await get_tree().create_timer(1.5).timeout

			lifebar.set_chances(lifebar.max_chances)
			timer.restart()
			_generate_new_question()
		else:
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

	if "scroll_3" not in data["scrolls"]["found"]:
		data["scrolls"]["found"].append("scroll_3")

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

	print("📜 Progresso salvo.")
