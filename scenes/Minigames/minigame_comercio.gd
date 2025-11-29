extends Control

@onready var pedido_label: Label = $Pedido/Label
@onready var prateleira_container: Control = $PrateleiraContainer
@onready var root_container: Control = $"."


# --- DropArea novo ---
@onready var drop_area = $DropArea

@onready var lifebar := $LifeBar
@onready var timer := $timer_label

@export var drag_item_scene: PackedScene


const SAVE_PATH := "user://player_data.json"

# Agora pedidos são DICTIONARY, não lista
var pedidos = [
	{ "Maçã": 4, "Vinho": 2 },
	{ "Azeite": 3, "Pão": 2 },
	{ "Vinho": 1, "Azeite": 4, "Pão": 1 }
]

var itens_mercado = ["Maçã", "Pão", "Vinho", "Azeite"]
var order_index = 0
var correct_streak := 0


func _ready():
	randomize()

	# conectar sinais do DropArea
	drop_area.item_correto.connect(_on_item_correto)
	drop_area.item_errado.connect(_on_item_errado)
	drop_area.pedido_concluido.connect(_on_pedido_concluido)

	_spawn_items()
	_generate_new_order()
	
	timer.timer.timeout.connect(_on_timer_timeout)



# ---------------------------------------------------------
# Instancia todos os itens arrastáveis
# ---------------------------------------------------------
func _spawn_items():
	var size = prateleira_container.get_rect().size
	var global_start = prateleira_container.get_global_position()

	for item_name in itens_mercado:
		for i in range(5):
			var drag = drag_item_scene.instantiate()
			drag.text_value = item_name
			drag.text = item_name
			root_container.add_child(drag)

			drag.global_position = global_start + Vector2(
				randi() % int(size.x - 200),
				randi() % int(size.y - 200)
			)


	
# ---------------------------------------------------------
# Configura novo pedido
# ---------------------------------------------------------
func _generate_new_order():
	if order_index >= pedidos.size():
		print("🎉 Todos pedidos concluídos!")
		pedido_label.text = "Fim!"
		return

	var p = pedidos[order_index]
	drop_area.set_pedido(p)

	var texto := "Pedido:\n"
	for k in p.keys():
		texto += "• %s x%d\n" % [k, p[k]]

	pedido_label.text = texto


# ---------------------------------------------------------
# SIGNALS vindos do DropArea
# ---------------------------------------------------------
func _on_item_correto(nome: String):
	print("✔ Acertou:", nome)

func _on_timer_timeout():
	print("💀 Tempo acabou! Resetando...")

	lifebar.set_chances(lifebar.max_chances)
	_reset_items_and_order()
	timer.restart() # reinicia o timer corretamente
	
func _on_item_errado(nome: String):
	print("❌ Errou:", nome)
	lifebar.set_chances(lifebar.current_chances - 1)
	if lifebar.current_chances <= 0:
		print("💀 Sem vidas! Reiniciando perguntas")
		await get_tree().create_timer(1.5).timeout
		lifebar.set_chances(lifebar.max_chances)
		timer.restart()
		_reset_items_and_order()


func _game_over():
	print("💀 Fim de jogo! Sem vidas ou tempo.")
	pedido_label.text = "GAME OVER"
	get_tree().paused = true


func _game_won():
	print("🎉 Todos os pedidos feitos!")
	pedido_label.text = "Você venceu!"
	_save_progress()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	

func _on_pedido_concluido():
	print("🏆 Pedido concluído!")
	correct_streak += 1
	order_index += 1
	if(correct_streak == 3):
		_game_won()
	_clear_items()
	_spawn_items()
	_generate_new_order()


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

	if "scroll_4" not in data["scrolls"]["found"]:
		data["scrolls"]["found"].append("scroll_4")

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

	print("📜 Progresso salvo.")


func _reset_items_and_order():
	_clear_items()
	_spawn_items()
	_generate_new_order()


func _clear_items():
	for child in root_container.get_children():
		if child is DragItem: # use a classe do seu item arrastável
			child.queue_free()
