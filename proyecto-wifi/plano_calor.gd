extends MeshInstance3D

var shader_material: ShaderMaterial

func _ready() -> void:
	if material_override is ShaderMaterial:
		shader_material = material_override
	else:
		shader_material = ShaderMaterial.new()
		shader_material.shader = preload("res://heatmap.gdshader")
		material_override = shader_material

func _process(delta: float) -> void:
	var sensores = get_tree().get_nodes_in_group("grupo_sensores")
	if sensores.size() == 0 or shader_material == null:
		return
		
	var limit = min(sensores.size(), 54)
	var positions = PackedVector3Array()
	var intensities = PackedFloat32Array()
	
	positions.resize(limit)
	intensities.resize(limit)
	
	for i in range(limit):
		positions[i] = sensores[i].global_position
		intensities[i] = sensores[i].intensidad_actual
		
	shader_material.set_shader_parameter("sensor_positions", positions)
	shader_material.set_shader_parameter("sensor_intensities", intensities)
	shader_material.set_shader_parameter("sensor_count", limit)
