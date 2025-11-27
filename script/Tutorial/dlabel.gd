extends Label

var dragging := false
var of := Vector2.ZERO

@export var snap := 10
@export var number: int = 0
func _ready() -> void:
	# garante que esteja sincronizado com o número inicial
	pass
func set_values(value: int) -> void:
	print("🧩 set_values(", value, ") em ", name)
	number = value
	text = _to_roman(value)
	# renomeia o Area2D filho se existir
	if has_node("Area2D"):
		$Area2D.name = str(value)
	else:
		# aviso no output caso o nó não exista
		push_warning("⚠️ Nó 'Area2D' não encontrado em " + str(name))

func _to_roman(value: int) -> String:
	var romans = {
		1: "I", 2: "II", 3: "III", 4: "IV",
		5: "V", 6: "VI", 7: "VII", 8: "VIII", 9: "IX",
		10: "X", 11: "XI", 12: "XII", 13: "XIII", 14: "XIV",
		15: "XV", 16: "XVI", 17: "XVII", 18: "XVIII", 19: "XIX", 20: "XX"
	}
	return romans.get(value, str(value))

func _process(_delta: float) -> void:
	if dragging:
		var new_pos = get_global_mouse_position() - of
		position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))

func _on_button_button_down() -> void:
	dragging = true
	of = get_global_mouse_position() - global_position

func _on_button_button_up() -> void:
	dragging = false
