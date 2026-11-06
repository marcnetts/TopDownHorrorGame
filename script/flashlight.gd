class_name Flashlight
extends PointLight2D

enum InputController {MOUSE, JOYSTICK}

@export_range(0, 1, 0.0001) var battery: float = 0.2
@export var lit: bool = false:
	set(value):
		lit = value
		_on_switch()
@export var light_direction: Vector2 = Vector2.RIGHT
@export var controller_style: InputController = InputController.MOUSE
@onready var battery_bar: ProgressBar = %BatteryBar

func _ready() -> void:
	_on_switch()
	update_battery_hud()
	EventBus.item_used.connect(_on_item_used)

func _physics_process(delta: float) -> void:
	update_direction()
	if lit:
		battery -= delta * 0.4
		#battery -= delta * 0.004
		battery = clampf(battery, 0, 1)
		if battery == 0.0:
			lit = false
		update_battery_hud()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_torch"):
		if battery > 0.0:
			lit = not lit
	if event is InputEventJoypadMotion:
		controller_style = InputController.JOYSTICK
	else: controller_style = InputController.MOUSE

func _on_switch() -> void:
	if lit:
		show()
	else:
		if battery > 0.0:
			hide()
		else:
			discharge()

func _on_item_used(item: Item) -> void:
	if item.name == 'battery':
		charge(0.25)

func update_direction() -> void:
	match controller_style:
		InputController.MOUSE:
			var target: Vector2 = get_global_mouse_position()
			light_direction = global_position.direction_to(target)
			rotation = light_direction.angle()
		InputController.JOYSTICK:
			light_direction = Input.get_vector("look_left","look_right","look_up","look_down").normalized()
			if light_direction.length() > 0.1:
				rotation = light_direction.angle()

func update_battery_hud() -> void:
	battery_bar.ratio = battery
	

func discharge() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "energy", 0.0, 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(hide)
	tween.tween_callback(func(): energy = 2.0)

func charge(ammount: float) -> void:
	battery += ammount
	update_battery_hud()
