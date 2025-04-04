extends Node2D
class_name Level

const _DIALOGO: PackedScene = preload("res://scenes/dialogo.tscn")

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://download.jpeg",
		"dialog": "Olá, sejam bem-vindos!",
		"title": "Paladino"
	},
	1: {
		"faceset": "res://download.jpeg",
		"dialog": "Estamos prestes a começar nossa jornada.",
		"title": "Paladino"
	},
	2: {
		"faceset": "res://download.jpeg",
		"dialog": "Tenham coragem e fé!",
		"title": "Paladino"
	},
	3: {
		"faceset": "res://download.jpeg",
		"dialog": "O caminho será difícil...",
		"title": "Paladino"
	},
	4: {
		"faceset": "res://download.jpeg",
		"dialog": "Mas não estaremos sozinhos.",
		"title": "Paladino"
	}
}

@export_category("Objects")
@export var _hud: CanvasLayer = null

var _dialog_opened := false

func _process(_delta: float) -> void:
	if not _dialog_opened and Input.is_action_just_pressed("ui_select"):
		var _new_dialog: Dialogo = _DIALOGO.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)
		_dialog_opened = true
