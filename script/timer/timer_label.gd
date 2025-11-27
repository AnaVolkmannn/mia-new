extends Label

@onready var timer: Timer = $Timer
@export var timeout = false

const SAVE_PATH := "user://player_data.json"

var timer_duration := 0.0

func _ready() -> void:
	var difficulty = _get_difficulty()
	match difficulty:
		"easy":
			timer_duration = 90.0
		"medium":
			timer_duration = 60.0
		"hard":
			timer_duration = 30.0
		_:
			timer_duration = 40.0

	timer.wait_time = timer_duration
	timer.start()
	print("⏳ Timer iniciado com base na dificuldade:", difficulty, "-", timer_duration, "segundos")

func _process(_delta: float) -> void:
	text = str(round(timer.time_left))

func _get_difficulty() -> String:
	if not FileAccess.file_exists(SAVE_PATH):
		print("File não acessada")
		return "medium"
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var data = JSON.parse_string(content)
	print(data)

	return data.get("difficulty", "medium")

func restart() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	timeout = true;
