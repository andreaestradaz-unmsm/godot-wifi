extends CharacterBody3D

var router_node: Node3D

func _process(_delta: float) -> void:
	if router_node == null:
		var routers = get_tree().get_nodes_in_group("grupo_router")
		if routers.size() > 0:
			router_node = routers[0]
		return 
		
	var distancia = global_position.distance_to(router_node.global_position)
	var base_dbm = -23.0 + (router_node.potencia_emision * 0.06)
	var distancia_efectiva = max(distancia, 1.0)
	var perdida_distancia = 20.0 * (log(distancia_efectiva) / log(10.0))
	var perdida_obstaculos = 0.0
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position + Vector3(0, 0.5, 0), router_node.global_position + Vector3(0, 0.5, 0))
	var exclude_list = [self.get_rid()] # Exclude the player itself
	
	for i in range(10):
		query.exclude = exclude_list
		var resultado = space_state.intersect_ray(query)
		
		if not resultado:
			break
			
		var objeto_chocado = resultado.collider
		var obj_name = objeto_chocado.name
		if objeto_chocado.is_in_group("metal") or "Casillero" in obj_name:
			perdida_obstaculos += 30.0
		elif objeto_chocado.is_in_group("concreto") or "Muro" in obj_name or "Pared" in obj_name or "Solido" in obj_name or "Techo" in obj_name:
			perdida_obstaculos += 35.0
		elif objeto_chocado.is_in_group("madera") or "Puerta" in obj_name or "Mesa" in obj_name or "Laptop" in obj_name or "Silla" in obj_name:
			perdida_obstaculos += 5.0
		else:
			perdida_obstaculos += 20.0
			
		exclude_list.append(resultado.rid)
			
	var senal_dbm = base_dbm - perdida_distancia - perdida_obstaculos
	
	if has_node("Label3D"):
		var lbl = get_node("Label3D")
		lbl.text = "Señal: " + String("%.1f" % senal_dbm) + " dBm"
