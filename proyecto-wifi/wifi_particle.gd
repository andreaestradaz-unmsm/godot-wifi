extends Node3D

var direction: Vector3 = Vector3.FORWARD
var speed: float = 10.0
var max_distance: float = 40.0
var distance_traveled: float = 0.0

var base_dbm: float = -15.0
var obstacle_loss: float = 0.0

@onready var mesh_instance = $MeshInstance3D

func _ready():
	if get_parent() and "potencia_emision" in get_parent():
		base_dbm = -23.0 + (get_parent().potencia_emision * 0.06)

func get_color_for_dbm(dbm: float) -> Color:
	var norm = clamp((dbm - (-90.0)) / 50.0, 0.0, 1.0)
	var c_0 = Color(0.65, 0.0, 0.15) # Dark Red
	var c_1 = Color(0.9, 0.2, 0.15)  # Red
	var c_2 = Color(0.95, 0.6, 0.2)  # Orange
	var c_3 = Color(0.95, 0.95, 0.6) # Pale Yellow
	var c_4 = Color(0.5, 0.8, 0.4)   # Light Green
	var c_5 = Color(0.1, 0.5, 0.2)   # Dark Green
	
	if norm <= 0.2: return c_0.lerp(c_1, norm / 0.2)
	elif norm <= 0.4: return c_1.lerp(c_2, (norm - 0.2) / 0.2)
	elif norm <= 0.6: return c_2.lerp(c_3, (norm - 0.4) / 0.2)
	elif norm <= 0.8: return c_3.lerp(c_4, (norm - 0.6) / 0.2)
	else: return c_4.lerp(c_5, (norm - 0.8) / 0.2)

var exclude_list = []

func _process(delta: float) -> void:
	# Asegurarnos de que mire en la dirección de movimiento
	if direction.length_squared() > 0.001:
		var target_look = global_position + direction
		# Prevenir errores de look_at si la dirección es exactamente arriba/abajo
		if abs(direction.y) < 0.99:
			look_at(target_look, Vector3.UP)
			
	var dist_efectiva = max(distance_traveled, 1.0)
	var distance_loss = 20.0 * (log(dist_efectiva) / log(10.0))
	var current_dbm = base_dbm - distance_loss - obstacle_loss

	if distance_traveled > max_distance:
		queue_free()
		return
		
	var step_dist = speed * delta
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + direction * step_dist)
	query.exclude = exclude_list
	
	var resultado = space_state.intersect_ray(query)
	
	if resultado:
		var obj = resultado.collider
		var obj_name = obj.name
		
		# Solo los muros realmente exteriores destruyen la partícula
		if obj_name == "Muro_Norte" or obj_name == "Muro_Sur" or obj_name == "Muro_Este" or obj_name == "Muro_Oeste":
			queue_free()
			return
		
		# Evitar chocar con el mismo objeto infinitamente
		exclude_list.append(resultado.rid)
		
		# Move to hit point but push out slightly along the normal to prevent getting trapped inside
		global_position = resultado.position + resultado.normal * 0.05
		distance_traveled += global_position.distance_to(resultado.position)
		
		if obj.is_in_group("metal") or "Casillero" in obj_name:
			obstacle_loss += 30.0
			var normal_plana = Vector3(resultado.normal.x, 0, resultado.normal.z).normalized()
			if normal_plana.length_squared() > 0.1:
				direction = direction.bounce(normal_plana).normalized()
			else:
				direction = -direction
			exclude_list.clear()
		elif obj.is_in_group("concreto") or "Muro" in obj_name or "Pared" in obj_name or "Solido" in obj_name or "Techo" in obj_name:
			obstacle_loss += 35.0
			if randf() < 0.15:
				direction = direction.bounce(Vector3(resultado.normal.x, 0, resultado.normal.z).normalized()).normalized()
				exclude_list.clear()
		elif obj.is_in_group("madera") or "Puerta" in obj_name or "Mesa" in obj_name or "Laptop" in obj_name or "Silla" in obj_name:
			obstacle_loss += 5.0
		else:
			# Objeto desconocido (como los casilleros si tienen otro nombre)
			obstacle_loss += 20.0
			var normal_plana = Vector3(resultado.normal.x, 0, resultado.normal.z).normalized()
			if normal_plana.length_squared() > 0.1:
				direction = direction.bounce(normal_plana).normalized()
			else:
				direction = -direction
			exclude_list.clear()
			
	else:
		global_position += direction * step_dist
		distance_traveled += step_dist
		
	# Update color
	var mat = mesh_instance.mesh.surface_get_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mesh_instance.material_override = mat
	
	if mesh_instance.material_override:
		mesh_instance.material_override.albedo_color = get_color_for_dbm(current_dbm)
