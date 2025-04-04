extends Control

@onready var label = $VBoxContainer/RichTextLabel
@onready var options_container = $VBoxContainer/OptionsContainer
@onready var audio_correct = $AudioStreamPlayerCorrect
@onready var audio_wrong = $AudioStreamPlayerWrong

var current_question = 0
var questions = [
	{
		"text": "Qual é a capital da França?",
		"options": ["Paris", "Londres", "Roma"],
		"correct": "Paris"
	},
	{
		"text": "Qual é a cor do céu durante um dia ensolarado?",
		"options": ["Azul", "Vermelho", "Verde"],
		"correct": "Azul"
	}
]

func _ready():
	show_question()

func show_question():
	# Limpa opções anteriores
	for child in options_container.get_children():
		child.queue_free()

	# Define o texto do diálogo
	label.text = "[center]" + questions[current_question]["text"] + "[/center]"

	# Cria os botões de resposta
	for option in questions[current_question]["options"]:
		var button = Button.new()
		button.text = option
		button.pressed.connect(_on_option_selected.bind(button, option))
		options_container.add_child(button)

func _on_option_selected(button, selected_option):
	if selected_option == questions[current_question]["correct"]:
		audio_correct.play()  # Toca som de acerto
		button.modulate = Color(0, 1, 0)  # Cor verde para indicar acerto
		await get_tree().create_timer(1.0).timeout  # Aguarda 1 segundo
		next_question()  # Avança para a próxima pergunta
	else:
		audio_wrong.play()  # Toca som de erro
		button.modulate = Color(1, 0, 0)  # Cor vermelha para indicar erro

func next_question():
	current_question += 1
	if current_question < questions.size():
		show_question()
	else:
		label.text = "[center]Parabéns! Você concluiu o diálogo.[/center]"
		for child in options_container.get_children():
			child.queue_free()
