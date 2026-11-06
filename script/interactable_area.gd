extends Area2D

signal interacted

@export var active: bool = true

func _ready() -> void:
	set_process_unhandled_input(false)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	$DebugLabel.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and active == true:
		interacted.emit()

func _on_area_entered(area: Area2D) -> void:
	$DebugLabel.text = "[E] para Interagir"
	set_process_unhandled_input(true)


func _on_area_exited(area:Area2D) -> void:
	$DebugLabel.text = ""
	set_process_unhandled_input(false)
