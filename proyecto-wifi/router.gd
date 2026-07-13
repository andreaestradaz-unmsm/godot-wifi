extends Node3D

var potencia_emision: float = 0.0
func _ready() -> void:
	# Registramos este nodo en el grupo para que los sensores lo encuentren fácil
	add_to_group("grupo_router")
	
	# Crear Modelo 3D del Router
	var mat_router = StandardMaterial3D.new()
	mat_router.albedo_color = Color(0.05, 0.05, 0.05) # Plástico oscuro
	
	var caja = CSGBox3D.new()
	caja.size = Vector3(0.4, 0.08, 0.25)
	caja.position = Vector3(0, 0.81, -0.2) # Sobre la mesa (Y=0.81), ligeramente atrás
	caja.material = mat_router
	add_child(caja)
	
	var antena1 = CSGCylinder3D.new()
	antena1.radius = 0.015
	antena1.height = 0.25
	antena1.position = Vector3(-0.15, 0.12, -0.1)
	antena1.rotation = Vector3(-0.3, 0, 0.3)
	antena1.material = mat_router
	caja.add_child(antena1)
	
	var antena2 = CSGCylinder3D.new()
	antena2.radius = 0.015
	antena2.height = 0.25
	antena2.position = Vector3(0.15, 0.12, -0.1)
	antena2.rotation = Vector3(-0.3, 0, -0.3)
	antena2.material = mat_router
	caja.add_child(antena2)

var last_spawn_time = 0.0
var particle_scene = preload("res://wifi_particle.tscn")

func _process(_delta: float) -> void:
	# Oscilación de la señal (más lenta)
	var tiempo = Time.get_ticks_msec() / 1000.0
	potencia_emision = 175.0 + (sin(tiempo * 1.0) * 125.0)
	
	# Spawn particles every 0.15 seconds
	if tiempo - last_spawn_time > 0.15:
		last_spawn_time = tiempo
		var base_dbm = -35.0 + (potencia_emision / 15.0)
		
		var sensors = get_tree().get_nodes_in_group("grupo_sensores")
		# Agrupamos los sensores en cuadrículas o simplemente disparamos a un subconjunto para no saturar
		for s in sensors:
			# Solo disparamos a un 25% de los sensores aleatoriamente en cada tick para no sobrecargar
			if randf() > 0.25: continue
			var target_pos = s.global_position
			# Pequeño margen de error para que haya dispersión
			target_pos += Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
			var dir = Vector3(target_pos.x - global_position.x, 0, target_pos.z - global_position.z).normalized()
			
			var p = particle_scene.instantiate()
			get_parent().add_child(p)
			p.global_position = global_position + Vector3(0, 0.1, 0)
			p.direction = dir
			p.base_dbm = base_dbm
			
		# Spawn particle towards player always
		var player = get_node_or_null("../Player")
		if player:
			var p_pos = player.global_position
			var dir = Vector3(p_pos.x - global_position.x, 0, p_pos.z - global_position.z).normalized()
			var p = particle_scene.instantiate()
			get_parent().add_child(p)
			p.global_position = global_position + Vector3(0, 0.1, 0)
			p.direction = dir
			p.base_dbm = base_dbm
			
			# Make it visually distinct (slightly bigger)
			if p.has_node("MeshInstance3D"):
				p.get_node("MeshInstance3D").scale = Vector3(1.5, 1.5, 1.5)
