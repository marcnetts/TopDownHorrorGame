class_name PhysicalItem
extends Node2D

@export var item: Item
@onready var item_sprite: TextureRect = $ItemSprite

func _ready() -> void:
	item_sprite.texture = item.sprite

func _on_interacted() -> void:
	var message: Array = []
	EventBus.item_collected.emit(item, message)
	var is_accepted: bool = message[0]
	if is_accepted:
		queue_free()
