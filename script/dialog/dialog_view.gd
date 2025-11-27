extends Control
class_name DialogView

signal option_selected(goes_value)
signal dialog_closed
signal dialog_opened

@onready var title_label: RichTextLabel = $MarginContainer/Background/VBoxContainer/Title
@onready var text_label: RichTextLabel = $MarginContainer/Background/VBoxContainer/Text
@onready var options_box: VBoxContainer = $MarginContainer/Background/VBoxContainer/Options

var is_open := false

func _ready() -> void:
	hide() # começa invisível

func show_dialog(title: String, text: String, options: Array = []) -> void:
	title_label.text = title
	text_label.text = text
	_load_options(options)
	show()
	is_open = true
	emit_signal("dialog_opened")

func close_dialog() -> void:
	hide()
	title_label.clear()
	text_label.clear()
	_clear_options()
	is_open = false
	emit_signal("dialog_closed")

func _load_options(options: Array) -> void:
	_clear_options()
	
	if options.is_empty():
		options.append({ "Placeholder": "OK", "Goes": null })

	for opt in options:
		var btn := Button.new()
		btn.text = opt.get("Placeholder", "...")
		btn.focus_mode = Control.FOCUS_NONE
		btn.custom_minimum_size = Vector2(120, 32)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.connect("pressed", Callable(self, "_on_option_pressed").bind(opt.get("Goes", null)))
		options_box.add_child(btn)

func _clear_options() -> void:
	for child in options_box.get_children():
		child.queue_free()

func _on_option_pressed(goes_value) -> void:
	emit_signal("option_selected", goes_value)
	close_dialog()
