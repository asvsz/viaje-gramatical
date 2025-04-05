extends Control
class_name Dialogo

var _step: float = 0.5
var _id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null
@export var _choices: VBoxContainer = null
@export var _audio_player: AudioStreamPlayer = null
@export var _replay_button: Button = null

func _ready() -> void:
	_replay_button =  $ColorRect/HBoxContainer/VBoxContainer/Button
	_choices = $ColorRect/HBoxContainer/VBoxContainer/VBoxContainer
	_audio_player = $ColorRect/HBoxContainer/VBoxContainer/AudioStreamPlayer
	_initialize_dialog()


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept") and _dialog.visible_ratio < 1:
		_step = 0.01
		return

	_step = 0.05

	if Input.is_action_just_pressed("ui_accept"):
		# Impede o avanço se estiver mostrando escolhas
		if _choices.visible:
			return

		_id += 1
		if _id == data.size():
			queue_free()
			return
		_initialize_dialog()


func _initialize_dialog() -> void:
	if not data.has(_id):
		print("ID inválido:", _id)
		queue_free()
		return

	var dialog_data = data[_id]
	_name.text = dialog_data["title"]
	_dialog.text = dialog_data["dialog"]
	_faceset.texture = load(dialog_data["faceset"])

	# Toca o áudio, se tiver
	if dialog_data.has("audio"):
		var audio_stream = load(dialog_data["audio"])
		_audio_player.stream = audio_stream
		_audio_player.play()

	_dialog.visible_characters = 0
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1

	if dialog_data.has("choices"):
		_show_choices(dialog_data["choices"])
		
	# Configura áudio
	if dialog_data.has("audio"):
		var audio_stream = load(dialog_data["audio"])
		_audio_player.stream = audio_stream
		_audio_player.play()

		# Habilita botão de replay
		_replay_button.visible = true
		_replay_button.disabled = false
	else:
		_replay_button.visible = false


func _show_choices(choices_data: Array) -> void:
	_choices.visible = true

	for i in range(_choices.get_child_count()):
		var btn = _choices.get_child(i)
		if i < choices_data.size():
			btn.text = choices_data[i]["text"]
			btn.show()
			btn.disabled = false

			# Cria um Callable para o botão
			var callback := Callable(self, "_on_choice_pressed").bind(choices_data[i]["correct"])

			# Remove conexões antigas se existirem
			if btn.is_connected("pressed", callback):
				btn.disconnect("pressed", callback)

			# Conecta com o novo valor
			btn.connect("pressed", callback)
		else:
			btn.hide()

func _on_choice_pressed(is_correct: bool) -> void:
	_choices.visible = false

	if is_correct:
		_dialog.text = "Boa! Resposta correta!"
	else:
		_dialog.text = "Resposta errada. Mas tudo bem, vamos continuar..."

	_dialog.visible_characters = 0
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1

	# Espera 2 segundos antes de continuar a história
	await get_tree().create_timer(2.0).timeout

	# Avança para o próximo trecho
	_id += 1
	if _id == data.size():
		queue_free()
		return

	_initialize_dialog()


func _on_button_pressed() -> void:
	_audio_player.play()
