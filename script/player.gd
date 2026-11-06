extends CharacterBody2D

@export var speed: float = 200

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * speed
	move_and_slide()


func _on_interactable_area_interacted() -> void:
	$PointLight2D.visible = not $PointLight2D.visible
