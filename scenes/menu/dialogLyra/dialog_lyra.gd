extends Sprite2D
class_name SimpleTypingDialog

signal dialog_opened
signal dialog_closed

@export var text: String = ""
@export var typing_speed: float = 0.04
@export var auto_close_time: float = 0.0  # 0 = não fecha sozinho

var current_text := ""
var char_index := 0
var timer := 0.0
var auto_timer := 0.0
var is_open := false
var is_closing := false


func _ready() -> void:
	hide()
	$Label.text = ""


# ============================================================
# 📌 ABRIR DIÁLOGO
# ============================================================
func open_dialog(new_text: String = "") -> void:
	if new_text != "":
		text = new_text

	is_open = true
	is_closing = false
	auto_timer = 0.0

	show()
	emit_signal("dialog_opened")

	# reset da digitação
	$Label.text = ""
	current_text = text
	char_index = 0
	timer = 0.0

	# animações
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play()

	$AnimationPlayer.play("pop")


# ============================================================
# 📌 FECHAR DIÁLOGO (COM ANIMAÇÃO)
# ============================================================
func close_dialog() -> void:
	if is_closing:
		return
	is_closing = true

	$AnimationPlayer.play("push")
	await $AnimationPlayer.animation_finished  # AGORA FUNCIONA

	hide()
	is_open = false
	is_closing = false
	emit_signal("dialog_closed")

	# para typing
	$Label.text = ""
	char_index = 9999


# ============================================================
# 🔤 EFEITO DE TYPING
# ============================================================
func _process(delta: float) -> void:
	if not is_open or is_closing:
		return

	# typing effect
	if char_index < current_text.length():
		timer += delta
		if timer >= typing_speed:
			timer = 0.0
			$Label.text += current_text[char_index]
			char_index += 1

		# parar animação quando terminar de digitar
		if char_index >= current_text.length() and $AnimatedSprite2D:
			$AnimatedSprite2D.stop()

	# auto close (se configurado)
	if auto_close_time > 0:
		auto_timer += delta
		if auto_timer >= auto_close_time:
			close_dialog()


# ============================================================
# 🟦 Botão de Fechar
# ============================================================
func _on_close_button_pressed() -> void:
	if is_closing:
		return
	close_dialog()
