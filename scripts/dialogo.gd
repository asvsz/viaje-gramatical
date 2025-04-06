extends Control
class_name Dialogo

var _step: float = 0.05
var _id: int = 0
var data: Dictionary = {}
var _is_typing: bool = false
var _waiting_for_choice: bool = false
var _awaiting_input: bool = false

@export_category("Objects")
@export var _name: Label
@export var _dialog: RichTextLabel
@export var _faceset: TextureRect
@export var _choices: VBoxContainer
@export var _audio_player: AudioStreamPlayer
@export var _replay_button: Button
@export var _faceset_container: ColorRect
@export var _text_input: TextEdit
@export var _response_input: String = ""

func _ready() -> void:
	_faceset_container = $ColorRect/HBoxContainer/ColorRect
	_replay_button = $ColorRect/HBoxContainer/VBoxContainer/Button
	_choices = $ColorRect/HBoxContainer/VBoxContainer/VBoxContainer
	_audio_player = $ColorRect/HBoxContainer/VBoxContainer/AudioStreamPlayer
	_text_input = $ColorRect/HBoxContainer/VBoxContainer/TextEdit

	_choices.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices.add_theme_constant_override("separation", 10)

	# Verifica se a conexão já existe antes de conectar
	if not _replay_button.pressed.is_connected(_on_button_pressed):
		_replay_button.pressed.connect(_on_button_pressed)

	_initialize_dialog()

func _process(_delta: float) -> void:
	if _is_typing:
		_step = 0.01 if Input.is_action_pressed("ui_accept") else 0.05
		return

	if _text_input.visible:
		if Input.is_action_just_pressed("ui_accept"):
			_response_input = _text_input.text
			_text_input.visible = false

			var dialog_data = data[_id]
			var is_correct = false

			if dialog_data.has("expected_answer"):
				var user_answer = _response_input.strip_edges().to_lower()
				var correct_answer = dialog_data["expected_answer"].strip_edges().to_lower()
				is_correct = (user_answer == correct_answer)
				await _show_feedback(is_correct)

			return

	if _waiting_for_choice or _is_typing or not _awaiting_input:
		return

	if Input.is_action_just_pressed("ui_accept"):
		_id += 1
		if _id == data.size():
			queue_free()
			return
		_initialize_dialog()

func _initialize_dialog() -> void:
	if not data.has(_id):
		queue_free()
		return

	var dialog_data = data[_id]
	_name.text = dialog_data.get("title", "")
	
	# Centraliza o texto da pergunta
	_dialog.bbcode_enabled = true
	_dialog.text = "[center]" + dialog_data.get("dialog", "") + "[/center]"
	_dialog.visible_characters = 0
	_is_typing = true
	_waiting_for_choice = false
	_awaiting_input = false
	_replay_button.visible = false
	_choices.visible = false

	if dialog_data.has("faceset") and dialog_data["faceset"] != null:
		_faceset.texture = load(dialog_data["faceset"])
		_faceset_container.show()
	else:
		_faceset_container.hide()

	if dialog_data.has("audio"):
		var audio_stream = load(dialog_data["audio"])
		_audio_player.stream = audio_stream
		_audio_player.play()
		_replay_button.visible = true
		await _audio_player.finished

	if dialog_data.has("text_input"):
		_text_input.visible = true
		_text_input.text = ""
		_text_input.grab_focus()
	else:
		_text_input.visible = false

	while _dialog.visible_ratio < 1.0:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1

	_is_typing = false

	if dialog_data.has("choices"):
		_show_choices(dialog_data["choices"])
	elif not dialog_data.has("text_input"):
		_awaiting_input = true

func _show_choices(choices_data: Array) -> void:
	_choices.visible = true
	_waiting_for_choice = true

	_choices.alignment = BoxContainer.ALIGNMENT_CENTER
	_choices.add_theme_constant_override("separation", 10)

	for i in range(_choices.get_child_count()):
		var btn = _choices.get_child(i)
		if i < choices_data.size():
			btn.text = choices_data[i]["text"]
			btn.show()
			btn.disabled = false
			btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

			# Desconecta conexões anteriores para evitar duplicação
			if btn.pressed.is_connected(_on_choice_button_pressed):
				btn.pressed.disconnect(_on_choice_button_pressed)

			var is_correct = choices_data[i].get("correct", false)
			btn.pressed.connect(_on_choice_button_pressed.bind(is_correct))
		else:
			btn.hide()

func _on_choice_button_pressed(is_correct: bool) -> void:
	_choices.visible = false
	_waiting_for_choice = false
	await _show_feedback(is_correct)

func _show_feedback(is_correct: bool) -> void:
	_dialog.bbcode_enabled = true
	_dialog.text = "[center][color=green]¡Bien! ¡Sigamos adelante![/color][/center]" if is_correct else "[center][color=red]Qué lástima. Sigamos adelante[/color][/center]"
	_dialog.visible_characters = 0
	_is_typing = true

	while _dialog.visible_ratio < 1.0:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1

	_is_typing = false
	await get_tree().create_timer(1.5).timeout

	_id += 1
	if _id == data.size():
		queue_free()
		return

	_initialize_dialog()

	var next_dialog_data = data.get(_id, {})
	if not next_dialog_data.has("choices") and not next_dialog_data.has("text_input"):
		_awaiting_input = true

func _on_button_pressed() -> void:
	if _audio_player.stream:
		_audio_player.play()
