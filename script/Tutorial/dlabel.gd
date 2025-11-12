extends Label

var dragging := false
var drag_offset := Vector2.ZERO

@export var number:int  = 0
var of = Vector2(0,0)
var snap = 10

func _ready() -> void:
	$".".text = str(number)
	$Area2D.name = str(number)
	
func _process(delta: float) -> void:
	if dragging:
		var newPos = get_global_mouse_position() - of
		position = Vector2(snapped(newPos.x,snap),snapped(newPos.y,snap))
		

func _on_button_button_up() -> void:
	dragging = false
	pass # Replace with function body.


func _on_button_button_down() -> void:
	dragging = true;
	of = get_global_mouse_position() - global_position
	pass # Replace with function body.
