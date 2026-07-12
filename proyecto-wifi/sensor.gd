extends MeshInstance3D

var material: StandardMaterial3D
var router_node: Node3D
var intensidad_actual: float = 0.0

func _ready() -> void:
	add_to_group("grupo_sensores")
	material = StandardMaterial3D.new()
	material_override = material

func _process(_delta: float) -> void:
	if router_node == null:
		var routers = get_tree().get_nodes_in_group("grupo_router")
		if routers.size() > 0:
			router_node = routers[0]
		return 

	var distancia = global_position.distance_to(router_node.global_position)
	
	# Simulación en dBm más realista para WiFi
	# El router oscila entre 50 y 300, lo mapeamos a un valor base de emisión (aprox -35 a -15 dBm)
	var base_dbm = -35.0 + (router_node.potencia_emision / 15.0)
	
	# Atenuación logarítmica por distancia
	var distancia_efectiva = max(distancia, 1.0)
	var perdida_distancia = 25.0 * (log(distancia_efectiva) / log(10.0))
	
	var perdida_obstaculos = 0.0
	
	# --- LANZAMIENTO DEL RAYO ---
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, router_node.global_position)
	var resultado = space_state.intersect_ray(query)
	
	# Verificamos si el rayo chocó con una pared
	if resultado:
		var objeto_chocado = resultado.collider
		
		# Identificamos de qué está hecha la pared usando los grupos
		if objeto_chocado.is_in_group("metal"):
			perdida_obstaculos = 40.0 # Pierde 40 dBm
		elif objeto_chocado.is_in_group("concreto"):
			perdida_obstaculos = 25.0 # Pierde 25 dBm
		elif objeto_chocado.is_in_group("madera"):
			perdida_obstaculos = 5.0  # Pierde 5 dBm
			
	# Señal final en dBm
	var senal_dbm = base_dbm - perdida_distancia - perdida_obstaculos
	
	# Normalizamos de -90 dBm (Rojo, 0.0) a -40 dBm (Verde, 1.0)
	intensidad_actual = clamp((senal_dbm - (-90.0)) / 50.0, 0.0, 1.0)
	var intensidad_normalizada = intensidad_actual
	
	var nuevo_color = Color.RED
	if intensidad_normalizada > 0.66:
		var peso = (intensidad_normalizada - 0.66) / 0.34
		nuevo_color = Color.YELLOW.lerp(Color.GREEN, peso)
	elif intensidad_normalizada > 0.33:
		var peso = (intensidad_normalizada - 0.33) / 0.33
		nuevo_color = Color.ORANGE.lerp(Color.YELLOW, peso)
	else:
		var peso = intensidad_normalizada / 0.33
		nuevo_color = Color.RED.lerp(Color.ORANGE, peso)
		
	material.albedo_color = nuevo_color
