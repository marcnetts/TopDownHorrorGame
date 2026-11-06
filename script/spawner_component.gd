class_name SpawnerComponent
extends Node

const PHYSICAL_ITEM = preload("uid://ce1x4f2m8akuc")

func _ready() -> void:
	EventBus.item_spawned.connect(_on_item_spawned)
	
func _on_item_spawned(item: Item, spawn_position: Vector2) -> void:
	var physical_item: PhysicalItem = PHYSICAL_ITEM.instantiate()
	physical_item.item = item
	physical_item.global_position = spawn_position
	add_sibling(physical_item)
	
