extends Node2D
class_name Level

const _DIALOGO: PackedScene = preload("res://scenes/dialogo.tscn")

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "¡Hola, viajero! ¡Bienvenido a Viaje Gramatical, una aventura interactiva por los increíbles países de habla hispana! ¿Estás listo?",
		"choices": [
			{"text": "¡Estoy listo para empezar!", "correct": true}
		]
	},
	1: {
		"faceset": "res://tileset/assistente.jpeg",
		"title": "Asistente de aeropuerto",
		"dialog": "¡Buenos días! ¿Puedo ver su pasaporte y su billete, por favor?"
	},
	2: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "¡Claro! Aquí tiene. ¿A qué hora es el embarque?"
	},
	3: {
		"faceset": "res://tileset/assistente.jpeg",
		"title": "Asistente de aeropuerto",
		"dialog": "El embarque comienza a las 10:30 en la puerta número 12. ¿Tiene equipaje para facturar?"
	},
	4: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "Sí, tengo una maleta grande."
	},
	5: {
		"faceset": "res://tileset/assistente.jpeg",
		"title": "Asistente de aeropuerto",
		"dialog": "Perfecto. Por favor, colóquela en la cinta. Muy bien, su maleta va directamente a Madrid."
	},
	6: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "Gracias. ¿Cuánto tiempo dura el vuelo?"
	},
	7: {
		"faceset": "res://tileset/assistente.jpeg",
		"title": "Asistente de aeropuerto",
		"dialog": "Aproximadamente dos horas y media. ¿Es su primera vez en España?"
	},
	8: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "No, ya he estado en Barcelona, pero nunca en Madrid. Estoy muy emocionado."
	},
	9: {
		"faceset": "res://tileset/assistente.jpeg",
		"title": "Asistente de aeropuerto",
		"dialog": "¡Seguro que le va a encantar! Que tenga un buen viaje."
	},
	10: {
		"faceset": "res://download.jpeg",
		"title": "Paladino",
		"dialog": "¡Gracias! Que tenga un buen día."
	},
	11: {
		"title": "Q1",
		"dialog": "¿Qué documento pide el/la agente en el mostrador de check-in?",
		"choices": [
			{"text": "A) ¡El pasaporte y el billete!", "correct": true},
			{"text": "B) El número de habitación", "correct": false},
			{"text": "C) La tarjeta de crédito", "correct": false}
		]
	},
	12: {
		"title": "Q2",
		"dialog": "¿Cómo se dice 'bagagem despachada' en español?",
		"choices": [
			{"text": "A) Equipaje de mano", "correct": false},
			{"text": "B) Maleta", "correct": false},
			{"text": "C) Equipaje facturado", "correct": true}
		]
	},
	13: {
		"title": "Q3",
		"dialog": "¿Cómo se dice 'assento' en español?",
		"choices": [
			{"text": "A) Asiento", "correct": true},
			{"text": "B) Silla", "correct": false},
			{"text": "C) Banco", "correct": false}
		]
	},
	14: {
		"title": "Q4",
		"dialog": "¿Qué es una 'reserva'?",
		"choices": [
			{"text": "A) Una comida", "correct": false},
			{"text": "B) Un cuarto ya solicitado con anticipación", "correct": true},
			{"text": "C) Un billete de avión", "correct": false}
		]
	},
	15: {
		"title": "Q5",
		"dialog": "¿Qué significa 'recepción'?",
		"choices": [
			{"text": "A) La entrada del hotel donde se atiende a los huéspedes", "correct": true},
			{"text": "B) Un restaurante", "correct": false},
			{"text": "C) Una maleta", "correct": false}
		]
	},
	16: {
		"title": "Q6",
		"dialog": "¿Qué es 'la cuenta'?",
		"choices": [
			{"text": "A) El menú", "correct": false},
			{"text": "B) El recibo del pago", "correct": true},
			{"text": "C) El postre", "correct": false}
		]
	},
	17: {
		"title": "Q7",
		"dialog": "¿Cómo se llama la persona que sirve la comida en el restaurante?",
		"choices": [
			{"text": "A) Turista", "correct": false},
			{"text": "B) Camarero / Mesero", "correct": true},
			{"text": "C) Recepcionista", "correct": false}
		]
	},
	18: {
		"title": "Q8",
		"dialog": "¿Qué significa 'agua con gas'?",
		"choices": [
			{"text": "A) Jugo de frutas", "correct": false},
			{"text": "B) Agua con burbujas", "correct": true},
			{"text": "C) Agua caliente", "correct": false}
		]
	},
	19: {
		"faceset": "res://tileset/bagagem.jpg",
		"dialog": "¿Cuál es el nombre de este ítem?",
		"title": "Q9",
		"text_input": "",
		"expected_answer": "Equipaje"
	},
	20: {
	"title": "Q10",
	"question": "¿Qué tipo de documento se describe en el audio?",
	"choices": [
		{"text": "A) Una reserva de hotel", "correct": false},
		{"text": "B) Un mapa turístico", "correct": false},
		{"text": "C) Un itinerario de viaje (con fechas y actividades)", "correct": true}
	],
	"audio": "res://tileset/Audio itinerário.wav",
	"audio_button_settings": {
		"visible": true,
		"text": "Escuchar Audio",
		"hint": "(Opcional: escuche para confirmar su respuesta)"
	}
}
}
@export_category("Objects")
@export var _hud: CanvasLayer = null

var _dialog_opened := false

func _process(_delta: float) -> void:
	if not _dialog_opened:
		var _new_dialog: Dialogo = _DIALOGO.instantiate()
		_new_dialog.data = _dialog_data
		_hud.add_child(_new_dialog)
		_dialog_opened = true
