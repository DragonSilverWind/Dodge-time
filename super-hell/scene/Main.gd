extends Node2D

const BulletScene = preload("res://scene/bullet.tscn") # ASSICURATI che il percorso sia CORRETTO (.tscn)

# Riferimenti ai nodi della scena
@onready var player = $Player
@onready var spawn_timer = $SpawnTimer

var game_active = true

func _ready():
	# Inizializza il generatore di numeri casuali
	randomize()
	
	# Connette il Timer per lo spawn automatico
	spawn_timer.timeout.connect(spawn_bullet)
	spawn_timer.start()

# --- Logica di Spawn ---

func spawn_bullet():
	if not game_active:
		return
		
	var new_bullet = BulletScene.instantiate()
	add_child(new_bullet)
	
	# UTILIZZA LA NUOVA FUNZIONE PER LO SPAWN INTERNO
	new_bullet.global_position = get_random_spawn_position()
	
	# CRUCIALE: Connette il segnale di Game Over del proiettile alla funzione game_over
	new_bullet.player_hit.connect(game_over)
	
	# Inizializza la direzione (verso il Player)
	new_bullet.initialize_bullet(player)

# --- Logica di Game Over ---

func game_over():
	if not game_active:
		return
		
	game_active = false
	print("!!! GAME OVER: Player Hit !!!")
	
	# Azioni Game Over:
	player.set_physics_process(false) # Ferma il movimento del Player
	spawn_timer.stop() # Ferma lo spawn dei proiettili
	
	get_tree().paused = true # Blocca l'intera scena

# --- FUNZIONE UTILITY AGGIORNATA PER LO SPAWN INTERNO ---

func get_random_spawn_position():
	var viewport_size = get_viewport_rect().size
	var random_pos = Vector2.ZERO
	
	# Genera X e Y casuali all'interno dei confini (0 a Viewport Size)
	random_pos.x = randf_range(0, viewport_size.x)
	random_pos.y = randf_range(0, viewport_size.y)
			
	return random_pos
