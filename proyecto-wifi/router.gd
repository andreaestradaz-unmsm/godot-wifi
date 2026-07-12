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

func _process(_delta: float) -> void:
	# Oscilación de la señal
	var tiempo = Time.get_ticks_msec() / 1000.0
	potencia_emision = 175.0 + (sin(tiempo * 2.0) * 125.0)
