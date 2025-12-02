extends Sprite2D

@export var text: String = ""
@export var typing_speed: float = 0.04 # tempo entre letras
var current_text := ""
var char_index := 0
var timer := 0.0

func _ready() -> void:
	$Label.text = ""
	current_text = text

func _process(delta: float) -> void:
	if char_index >= current_text.length():
		$AnimatedSprite2D.stop()
		return

	timer += delta
	if timer >= typing_speed:
		timer = 0.0
		$Label.text += current_text[char_index]
		char_index += 1
