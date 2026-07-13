extends CanvasLayer

@onready var label = $MarginContainer/Label
var router_node: Node3D

func _ready():
	var routers = get_tree().get_nodes_in_group("grupo_router")
	if routers.size() > 0:
		router_node = routers[0]

func _process(delta):
	if router_node:
		# Calculamos el dBm base tal como lo hace el sensor.gd
		var base_dbm = -23.0 + (router_node.potencia_emision * 0.06)
		label.text = "Emisión del Router: %.1f dBm" % base_dbm
		
		# Normalizamos el valor para el color:
		# Rango: -20.0 dBm (mínimo) a -5.0 dBm (máximo)
		var normalizado = clamp((base_dbm - (-20.0)) / 15.0, 0.0, 1.0)
		
		# Interpolar de Rojo (señal baja) a Verde (señal fuerte)
		var color = Color(1.0, 0.2, 0.2).lerp(Color(0.2, 1.0, 0.2), normalizado)
		
		# Aplicar el color a la fuente
		label.add_theme_color_override("font_color", color)
