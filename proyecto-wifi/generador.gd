extends Node3D

var sensor_scene = preload("res://sensor.tscn")

func _ready() -> void:
	var posiciones = []
	
	# Aula B (Top Left, 3x3 = 9 nodes)
	for x in [-8, -6, -4]:
		for z in [-8, -5, -2]:
			posiciones.append(Vector3(x, 0, z))
			
	# Aula A (Bottom Left, 3x4 = 12 nodes) - Router is here
	for x in [-8, -6, -4]:
		for z in [2, 4.5, 7, 9.5]:
			posiciones.append(Vector3(x, 0, z))
			
	# Aula C (Right, 3x3 = 9 nodes)
	for x in [4, 6, 8]:
		for z in [-8, -5, -2]:
			posiciones.append(Vector3(x, 0, z))
			
	# Pasillo Principal (Center, 2x12 = 24 nodes)
	for x in [-0.75, 0.75]:
		for z_idx in range(12):
			var z = -8.5 + z_idx * 1.5
			posiciones.append(Vector3(x, 0, z))
			
	# Instanciar sensores
	for pos in posiciones:
		var nuevo_sensor = sensor_scene.instantiate()
		nuevo_sensor.position = pos
		add_child(nuevo_sensor)
	
	# Ubicar el router en el centro de Aula A (opcional, si es que lo quieres fijo ahí)
	var router = get_node_or_null("../Router")
	if router:
		router.position = Vector3(-6, 0, 5.75)
