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
	# El router oscila entre 50 y 300, lo mapeamos a un valor base de emisión (-20 a -5 dBm)
	var base_dbm = -23.0 + (router_node.potencia_emision * 0.06)
	
	# Atenuación logarítmica por distancia
	var distancia_efectiva = max(distancia, 1.0)
	var perdida_distancia = 20.0 * (log(distancia_efectiva) / log(10.0))
	
	var perdida_obstaculos = 0.0
	
	# --- LANZAMIENTO DEL RAYO MÚLTIPLE ---
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 0.5, 0), router_node.global_position + Vector3(0, 0.5, 0))
	var exclude_list = []
	
	for i in range(10): # Límite de obstáculos a atravesar
		query.exclude = exclude_list
		var resultado = space_state.intersect_ray(query)
		
		if not resultado:
			break # Llegó al router libremente
			
		var objeto_chocado = resultado.collider
		var obj_name = objeto_chocado.name
		
		if objeto_chocado.is_in_group("metal") or "Casillero" in obj_name:
			perdida_obstaculos += 30.0 # Pierde 30 dBm
		elif objeto_chocado.is_in_group("concreto") or "Muro" in obj_name or "Pared" in obj_name or "Solido" in obj_name or "Techo" in obj_name:
			perdida_obstaculos += 35.0 # Pierde 35 dBm
		elif objeto_chocado.is_in_group("madera") or "Puerta" in obj_name or "Mesa" in obj_name or "Laptop" in obj_name or "Silla" in obj_name:
			perdida_obstaculos += 5.0  # Pierde 5 dBm
		else:
			perdida_obstaculos += 20.0 # Objeto desconocido
			
		# Añadir a excluidos para continuar el rayo
		exclude_list.append(resultado.rid)
			
	# Señal final en dBm
	var senal_dbm = base_dbm - perdida_distancia - perdida_obstaculos
	
	# Normalizamos de -90 dBm (Rojo, 0.0) a -40 dBm (Verde, 1.0)
	intensidad_actual = clamp((senal_dbm - (-90.0)) / 50.0, 0.0, 1.0)
	var intensidad_normalizada = intensidad_actual
	
	var c_0 = Color(0.65, 0.0, 0.15) # -90 dBm (Dark Red)
	var c_1 = Color(0.9, 0.2, 0.15)  # -80 dBm (Red)
	var c_2 = Color(0.95, 0.6, 0.2)  # -70 dBm (Orange)
	var c_3 = Color(0.95, 0.95, 0.6) # -60 dBm (Pale Yellow)
	var c_4 = Color(0.5, 0.8, 0.4)   # -50 dBm (Light Green)
	var c_5 = Color(0.1, 0.5, 0.2)   # -40 dBm (Dark Green)
	
	var nuevo_color = c_0
	if intensidad_normalizada <= 0.2:
		nuevo_color = c_0.lerp(c_1, intensidad_normalizada / 0.2)
	elif intensidad_normalizada <= 0.4:
		nuevo_color = c_1.lerp(c_2, (intensidad_normalizada - 0.2) / 0.2)
	elif intensidad_normalizada <= 0.6:
		nuevo_color = c_2.lerp(c_3, (intensidad_normalizada - 0.4) / 0.2)
	elif intensidad_normalizada <= 0.8:
		nuevo_color = c_3.lerp(c_4, (intensidad_normalizada - 0.6) / 0.2)
	else:
		nuevo_color = c_4.lerp(c_5, (intensidad_normalizada - 0.8) / 0.2)
		
	material.albedo_color = nuevo_color
