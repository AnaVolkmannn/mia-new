extends Label

var dragging := false
var of := Vector2.ZERO
var initial_position := Vector2.ZERO

@export var snap := 10
@export var text_value: String = ""   # 🔥 valor que o Drop vai ler

func _ready() -> void:
	initial_position = position

func set_text_value(value: String) -> void:
	text_value = value
	text = value
	reset_label()

func reset_label():
	dragging = false
	of = Vector2.ZERO
	position = initial_position

func _process(_delta: float) -> void:
	if dragging:
		var new_pos = get_global_mouse_position() - of
		position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	dragging = false
