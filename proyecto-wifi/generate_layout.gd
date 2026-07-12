@tool
extends SceneTree

func _init():
	var root = Node3D.new()
	root.name = "EdificioLayout"
	
	var floor_material = StandardMaterial3D.new()
	floor_material.albedo_color = Color(0.8, 0.8, 0.8)
	
	var floor = CSGBox3D.new()
	floor.name = "Piso_Facultad"
	floor.size = Vector3(21, 0.2, 21)
	floor.position = Vector3(0, -0.1, 0)
	floor.use_collision = true
	root.add_child(floor)
	floor.owner = root
	
	var walls_node = Node3D.new()
	walls_node.name = "Muros"
	root.add_child(walls_node)
	walls_node.owner = root

	var add_wall = func(name: String, pos: Vector3, size: Vector3):
		var wall = CSGBox3D.new()
		wall.name = name
		wall.size = size
		wall.position = pos
		wall.use_collision = true
		walls_node.add_child(wall)
		wall.owner = root
	
	# Muros Exteriores (Grosor 0.5, Altura 3)
	add_wall.call("Muro_Norte", Vector3(0, 1.5, -10.25), Vector3(21, 3, 0.5))
	add_wall.call("Muro_Sur", Vector3(0, 1.5, 10.25), Vector3(21, 3, 0.5))
	add_wall.call("Muro_Oeste", Vector3(-10.25, 1.5, 0), Vector3(0.5, 3, 20))
	add_wall.call("Muro_Este", Vector3(10.25, 1.5, 0), Vector3(0.5, 3, 20))
	
	# Paredes Pasillo (2 paredes centrales dejando 3m de pasillo en medio)
	# Pasillo va de X = -1.5 a X = 1.5
	# Pared pasillo izquierda (X = -1.75), Pared pasillo derecha (X = 1.75)
	# Pero tienen puertas, así que haremos los tramos de pared.
	# Z va de -10 a 10.
	# Puertas de 1.5 de ancho, 2 de alto.
	
	# En lugar de tramos, usaré CSGCombiner3D para cada pared del pasillo y le resto las puertas
	var pared_izq = CSGCombiner3D.new()
	pared_izq.name = "Pared_Pasillo_Izquierda"
	walls_node.add_child(pared_izq)
	pared_izq.owner = root
	
	var pared_izq_solid = CSGBox3D.new()
	pared_izq_solid.name = "Solido"
	pared_izq_solid.size = Vector3(0.5, 3, 20)
	pared_izq_solid.position = Vector3(-1.75, 1.5, 0)
	pared_izq_solid.use_collision = true
	pared_izq.add_child(pared_izq_solid)
	pared_izq_solid.owner = root
	
	var door_hole1 = CSGBox3D.new()
	door_hole1.name = "Hueco_Puerta_Aula1"
	door_hole1.size = Vector3(1, 2, 2)
	door_hole1.position = Vector3(-1.75, 1.0, -2.5)
	door_hole1.operation = CSGShape3D.OPERATION_SUBTRACTION
	pared_izq.add_child(door_hole1)
	door_hole1.owner = root
	
	var door_hole2 = CSGBox3D.new()
	door_hole2.name = "Hueco_Puerta_Aula2"
	door_hole2.size = Vector3(1, 2, 2)
	door_hole2.position = Vector3(-1.75, 1.0, 2.5)
	door_hole2.operation = CSGShape3D.OPERATION_SUBTRACTION
	pared_izq.add_child(door_hole2)
	door_hole2.owner = root

	var pared_der = CSGCombiner3D.new()
	pared_der.name = "Pared_Pasillo_Derecha"
	walls_node.add_child(pared_der)
	pared_der.owner = root
	
	var pared_der_solid = CSGBox3D.new()
	pared_der_solid.name = "Solido"
	pared_der_solid.size = Vector3(0.5, 3, 20)
	pared_der_solid.position = Vector3(1.75, 1.5, 0)
	pared_der_solid.use_collision = true
	pared_der.add_child(pared_der_solid)
	pared_der_solid.owner = root
	
	var door_hole3 = CSGBox3D.new()
	door_hole3.name = "Hueco_Puerta_Aula3"
	door_hole3.size = Vector3(1, 2, 2)
	door_hole3.position = Vector3(1.75, 1.0, -2.5)
	door_hole3.operation = CSGShape3D.OPERATION_SUBTRACTION
	pared_der.add_child(door_hole3)
	door_hole3.owner = root
	
	var door_hole4 = CSGBox3D.new()
	door_hole4.name = "Hueco_Puerta_Aula4"
	door_hole4.size = Vector3(1, 2, 2)
	door_hole4.position = Vector3(1.75, 1.0, 2.5)
	door_hole4.operation = CSGShape3D.OPERATION_SUBTRACTION
	pared_der.add_child(door_hole4)
	door_hole4.owner = root
	
	# Paredes Divisorias (X = -6 para izquierda, X = 6 para derecha)
	# Entre aula 1 y 2
	add_wall.call("Pared_Divisoria_Aulas1_2", Vector3(-6, 1.5, 0), Vector3(8, 3, 0.5))
	# Entre aula 3 y 4
	add_wall.call("Pared_Divisoria_Aulas3_4", Vector3(6, 1.5, 0), Vector3(8, 3, 0.5))
	
	# Techo para la Habitacion 4
	var techo4 = CSGBox3D.new()
	techo4.name = "Techo_Habitacion4"
	techo4.size = Vector3(8.5, 0.2, 10.5)
	techo4.position = Vector3(6, 3.1, 5)
	techo4.use_collision = true
	root.add_child(techo4)
	techo4.owner = root
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://habitaciones.tscn")
	
	print("Scene saved successfully.")
	quit()
