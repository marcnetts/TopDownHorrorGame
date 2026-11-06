extends Node

signal item_collected(item: Item, message: Array)
signal item_used(item: Item)
signal item_spawned(item: Item, position: Vector2)
signal inventory_requested(node: Node)
