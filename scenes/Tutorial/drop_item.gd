extends Control

# Pedido no formato:
# { "Maçã": 4, "Vinho": 2 }
var pedido := {}

# Progresso atual:
# { "Maçã": 0, "Vinho": 0 }
var progresso := {}

signal item_correto(item: String)
signal item_errado(item: String)
signal pedido_concluido()

func set_pedido(novo_pedido: Dictionary) -> void:
	pedido = novo_pedido.duplicate()
	progresso.clear()

	for nome in pedido.keys():
		progresso[nome] = 0

	print("📦 Novo pedido configurado:", pedido)


# -------------------------
#  REGISTRA ITEM ENTREGUE
# -------------------------
func registrar_item(item_nome: String, item_node: Node) -> void:
	if pedido.has(item_nome):

		# Se já entregou tudo → é erro
		if progresso[item_nome] >= pedido[item_nome]:
			print("❌ Entregou MAIS do que o necessário:", item_nome)
			emit_signal("item_errado", item_nome)
			return

		# Aumenta o progresso
		progresso[item_nome] += 1
		emit_signal("item_correto", item_nome)

		# Remove o item corretamente
		item_node.queue_free()

		print("✔ Item correto:", item_nome, "|", progresso[item_nome], "/", pedido[item_nome])

		if _check_conclusao():
			print("🏆 Pedido concluído!!")
			emit_signal("pedido_concluido")

	else:
		emit_signal("item_errado", item_nome)
		print("❌ Item errado:", item_nome)


func _check_conclusao() -> bool:
	for nome in pedido.keys():
		if progresso[nome] < pedido[nome]:
			return false
	return true


# -------------------------
# DETECÇÃO DO ITEM VIA AREA2D
# -------------------------
func _on_area_2d_area_entered(area: Area2D) -> void:
	var item = area.get_parent()

	if item == null :
		print("⚠ Drop recebeu algo inválido:", item)
		return

	registrar_item(item.text_value, item)
