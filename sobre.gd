extends Control

@export var rich_text_label: RichTextLabel

var _step: float = 0.05
var _is_typing: bool = false
var _text_started: bool = false

func _ready() -> void:
	rich_text_label.bbcode_enabled = true
	rich_text_label.text = ""  # vazio até começar

func _process(_delta: float) -> void:
	if _is_typing and Input.is_action_pressed("ui_accept"):
		_step = 0.01
	else:
		_step = 0.05

	# Dispara a digitação ao apertar espaço/Enter
	if Input.is_action_just_pressed("ui_accept") and not _text_started:
		_text_started = true
		_type_text("Este é o texto que será digitado.") # <-- altere aqui para o texto desejado

func _type_text(text: String) -> void:
	rich_text_label.text = text
	rich_text_label.visible_characters = 0
	_is_typing = true
	await _start_typing()

func _start_typing() -> void:
	while rich_text_label.visible_ratio < 1.0:
		await get_tree().create_timer(_step).timeout
		rich_text_label.visible_characters += 1
	_is_typing = false
