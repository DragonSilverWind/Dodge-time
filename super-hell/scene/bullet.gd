extends CharacterBody2D

# Dichiarazione del segnale: inviato quando il proiettile colpisce il giocatore
signal player_hit

# Variabili di Configurazione
const SPEED = 400.0
var direction = Vector2.ZERO 

# Riferimento al giocatore (impostato dal generatore)
var target_player = null

# --- Funzioni Iniziali ---

func _ready():
	# Assicurati di avere un nodo Timer chiamato 'LifetimeTimer' come figlio
	if has_node("Destroy"):
		$Destroy.timeout.connect(on_lifetime_timer_timeout)
		$Destroy.start(10.0) # 10 secondi di durata
	else:
		# Se manca il Timer, il proiettile si distruggerà immediatamente
		print("ATTENZIONE: Il nodo Timer 'Destroy' non è stato trovato!")
		queue_free()

# --- Logica di Movimento e Collisione (Fisica) ---

func _physics_process(delta):
	velocity = direction * SPEED
	
	# Muove il proiettile e controlla le collisioni
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		# 1. Controlla se l'oggetto colpito è il Player
		# Utilizziamo il nome del nodo che hai specificato ("Player")
		if collider and collider.name == "Player": 
			player_hit.emit() # Game Over!
			queue_free() 
			return
		
		# 2. RIMBALZO (se colpisce una parete o altro oggetto)
		direction = direction.bounce(collision.get_normal())
		# Sposta il proiettile per prevenire incastro
		global_position += direction * collision.get_remainder().length()
		
# --- Logica del Timer ---

func on_lifetime_timer_timeout():
	# Distrugge il proiettile quando il timer scade
	queue_free()

# --- Funzione per Impostare la Direzione Iniziale ---

func initialize_bullet(player_node):
	target_player = player_node
	
	if target_player:
		# Calcola il vettore di direzione dal proiettile alla posizione del giocatore
		direction = (target_player.global_position - global_position).normalized()
