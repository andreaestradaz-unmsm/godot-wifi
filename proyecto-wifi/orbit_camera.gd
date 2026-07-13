extends Camera3D

var look_at_target = Vector3.ZERO
var distance = 25.0
var min_distance = 2.0
var max_distance = 60.0
var rotation_speed = 0.005
var pan_speed = 0.02
var zoom_speed = 2.0

var rot_x = -PI / 3 # Inclinación (unos 60 grados hacia abajo)
var rot_y = 0.0

var dragging_player = false
var player_node: Node3D

func _ready():
	_update_camera()
	player_node = get_node_or_null("../Player")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var space_state = get_world_3d().direct_space_state
				var from = project_ray_origin(event.position)
				var to = from + project_ray_normal(event.position) * 1000.0
				var query = PhysicsRayQueryParameters3D.create(from, to)
				var result = space_state.intersect_ray(query)
				if result and result.collider.name == "Player":
					dragging_player = true
			else:
				dragging_player = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clamp(distance - zoom_speed, min_distance, max_distance)
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clamp(distance + zoom_speed, min_distance, max_distance)
			_update_camera()
			
	elif event is InputEventMouseMotion:
		if dragging_player and player_node:
			var from = project_ray_origin(event.position)
			var to = from + project_ray_normal(event.position) * 1000.0
			var plane = Plane(Vector3.UP, Vector3(0, 1.0, 0)) # Plano a la altura del jugador
			var intersection = plane.intersects_ray(from, to - from)
			if intersection:
				player_node.global_position = intersection
			get_viewport().set_input_as_handled()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			# Rotar con click derecho
			rot_y -= event.relative.x * rotation_speed
			rot_x -= event.relative.y * rotation_speed
			rot_x = clamp(rot_x, -PI/2 + 0.01, PI/2 - 0.01)
			_update_camera()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			# Panear con click central
			var right = transform.basis.x
			var up = transform.basis.y
			var forward = Vector3(transform.basis.z.x, 0, transform.basis.z.z).normalized()
			look_at_target -= (right * event.relative.x + up * event.relative.y) * pan_speed
			_update_camera()

func _update_camera():
	var offset = Vector3(
		cos(rot_x) * sin(rot_y),
		-sin(rot_x),
		cos(rot_x) * cos(rot_y)
	) * distance
	
	global_position = look_at_target + offset
	look_at_from_position(global_position, look_at_target, Vector3.UP)
