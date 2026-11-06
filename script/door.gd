@icon("res://addons/at-icons/node2d/door.svg")
class_name Door
extends Node2D

@export var locked: bool = true
@export var key: Item

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var inventory: Inventory

func _on_interacted() -> void:
	if locked == false:
		open()
	else:
		EventBus.inventory_requested.emit(self)
		if key in inventory.inventory_content:
			open()
		else:
			barred()

func open() -> void:
	locked = false
	animation_player.play("open")

func barred() -> void:
	animation_player.play("locked")
