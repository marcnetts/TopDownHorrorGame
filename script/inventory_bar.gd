class_name Inventory
extends Control

@export var inventory_content: Array[Item]
@export var active_slot: int = 0
@onready var item_list: HBoxContainer = $InventoryPanel/ItemList
@export var player: CharacterBody2D

var max_slots: int = 5

func _ready() -> void:
	inventory_content.resize(max_slots)
	print(inventory_content)
	EventBus.item_collected.connect(add_item)
	EventBus.inventory_requested.connect(_on_inventory_requested)
	refresh_inventory_bar()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("item_next"):
		active_slot += 1
		active_slot = wrapi(active_slot, 0, max_slots)
		refresh_inventory_bar()
	if event.is_action_pressed("item_previous"):
		active_slot -= 1
		active_slot = wrapi(active_slot, 0, max_slots)
		refresh_inventory_bar()
	if event.is_action_pressed("item_consume"):
		use_item()

func _on_inventory_requested(node: Node) -> void:
	if node.get('inventory') == null:
		node.inventory = self

func add_item(item: Item, message: Array) -> void:
	message.append(true)
	var last_item: Item = inventory_content[active_slot]
	if not last_item:
		inventory_content[active_slot] = item
	else:
		drop_item(last_item)
	refresh_inventory_bar()

func use_item() -> void:
	if inventory_content[active_slot] == null:
		return
	
	EventBus.item_used.emit(inventory_content[active_slot])
	inventory_content[active_slot] = null
	refresh_inventory_bar()

func drop_item(item: Item) -> void:
	EventBus.item_spawned.emit(item, player.global_position)

func refresh_inventory_bar() -> void:
	for i in item_list.get_child_count():
		item_list.get_child(i).get_node("Selected").visible = (i == active_slot)
	
	# Inventory Icons
	for i in max_slots:
		var item_box = item_list.get_child(i)
		var item_box_icon: TextureRect = item_box.get_node("ItemIcon")
		item_box_icon.texture = inventory_content[i].sprite if inventory_content[i] != null else null
			
