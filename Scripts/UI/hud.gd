class_name HUD
extends CanvasLayer


@export_category("Oxygen UI")
@export var oxygen_bar: ProgressBar
@export var oxygen_label: Label

@export_category("Health UI")
@export var health_bar: ProgressBar
@export var health_label: Label

@export_category("Oxygen Colors")
@export var high_oxygen_color: Color = Color.GREEN
@export var medium_oxygen_color: Color = Color.YELLOW
@export var low_oxygen_color: Color = Color.RED

@export_category("Health Colors")
@export var high_health_color: Color = Color.GREEN
@export var medium_health_color: Color = Color.YELLOW
@export var low_health_color: Color = Color.RED


var oxygen_fill_style: StyleBoxFlat
var health_fill_style: StyleBoxFlat


func _ready() -> void:
	_validate_ui_nodes()

	oxygen_fill_style = _setup_progress_bar_style(
		oxygen_bar
	)

	health_fill_style = _setup_progress_bar_style(
		health_bar
	)

	if oxygen_bar != null:
		_update_oxygen_color(
			_get_value_ratio(
				oxygen_bar.value,
				oxygen_bar.max_value
			)
		)

	if health_bar != null:
		_update_health_color(
			_get_value_ratio(
				health_bar.value,
				health_bar.max_value
			)
		)

func _validate_ui_nodes() -> void:
	if oxygen_bar == null:
		push_error(
			"HUD: Oxygen Bar has not been assigned."
		)

	if oxygen_label == null:
		push_warning(
			"HUD: Oxygen Label has not been assigned."
		)

	if health_bar == null:
		push_error(
			"HUD: Health Bar has not been assigned."
		)

	if health_label == null:
		push_warning(
			"HUD: Health Label has not been assigned."
		)


func _setup_progress_bar_style(
	progress_bar: ProgressBar
) -> StyleBoxFlat:
	if progress_bar == null:
		return null

	var fill_style: StyleBoxFlat
	var existing_style := progress_bar.get_theme_stylebox(
		"fill"
	)

	if existing_style is StyleBoxFlat:
		fill_style = (
			existing_style.duplicate()
			as StyleBoxFlat
		)
	else:
		fill_style = StyleBoxFlat.new()

	progress_bar.add_theme_stylebox_override(
		"fill",
		fill_style
	)

	return fill_style


func update_oxygen(
	current_oxygen: float,
	maximum_oxygen: float
) -> void:
	if oxygen_bar == null:
		return

	oxygen_bar.min_value = 0.0
	oxygen_bar.max_value = maximum_oxygen
	oxygen_bar.value = current_oxygen

	var oxygen_ratio := _get_value_ratio(
		current_oxygen,
		maximum_oxygen
	)

	_update_oxygen_color(oxygen_ratio)


func update_health(
	current_health: float,
	maximum_health: float
) -> void:
	if health_bar == null:
		return

	health_bar.min_value = 0.0
	health_bar.max_value = maximum_health
	health_bar.value = current_health

	var health_ratio := _get_value_ratio(
		current_health,
		maximum_health
	)

	_update_health_color(health_ratio)


func _get_value_ratio(
	current_value: float,
	maximum_value: float
) -> float:
	if maximum_value <= 0.0:
		return 0.0

	return clampf(
		current_value / maximum_value,
		0.0,
		1.0
	)


func _update_oxygen_color(
	oxygen_ratio: float
) -> void:
	if oxygen_fill_style == null:
		return

	if oxygen_ratio > 2.0 / 3.0:
		oxygen_fill_style.bg_color = (
			high_oxygen_color
		)
	elif oxygen_ratio > 1.0 / 3.0:
		oxygen_fill_style.bg_color = (
			medium_oxygen_color
		)
	else:
		oxygen_fill_style.bg_color = (
			low_oxygen_color
		)


func _update_health_color(
	health_ratio: float
) -> void:
	if health_fill_style == null:
		return

	if health_ratio > 2.0 / 3.0:
		health_fill_style.bg_color = (
			high_health_color
		)
	elif health_ratio > 1.0 / 3.0:
		health_fill_style.bg_color = (
			medium_health_color
		)
	else:
		health_fill_style.bg_color = (
			low_health_color
		)


func show_oxygen_depleted() -> void:
	if oxygen_label != null:
		oxygen_label.text = "OXYGEN DEPLETED"

	if oxygen_fill_style != null:
		oxygen_fill_style.bg_color = (
			low_oxygen_color
		)


func show_health_depleted() -> void:
	if health_label != null:
		health_label.text = "HEALTH DEPLETED"

	if health_fill_style != null:
		health_fill_style.bg_color = (
			low_health_color
		)
