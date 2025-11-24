extends CharacterBody2D

# --- Variabili di Configurazione ---
const SPEED = 350.0

# --- Funzione Principale per la Fisica ---
func _physics_process(delta):
	# 1. Ottieni l'Input del Giocatore
	var input_direction = Vector2.ZERO
	
	# Usiamo i nomi di input specificati (move_left, move_right, move_up, move_down)
	input_direction.x = Input.get_axis("move_left", "move_right")
	input_direction.y = Input.get_axis("move_up", "move_down") # Nota: Godot è Z-up/Y-down per default
	
	# 2. Normalizza la Direzione
	var direction = input_direction.normalized()

	# 3. Applica la Velocità
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		# Nessun input: frena gradualmente il personaggio
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# 4. Muovi il Personaggio
	move_and_slide()
