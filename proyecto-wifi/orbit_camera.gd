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

func _ready():
	_update_camera()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clamp(distance - zoom_speed, min_distance, max_distance)
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clamp(distance + zoom_speed, min_distance, max_distance)
			_update_camera()
			
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			# Rotar con click derecho
			rot_y -= event.relative.x * rotation_speed
			rot_x -= event.relative.y * rotation_speed
			rot_x = clamp(rot_x, -PI/2 + 0.01, PI/2 - 0.01)
			_update_camera()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
			# Panear con click central
			var right = transform.basis.x
			var up = transform.basis.y
			# En un paneo típico de mapa, nos movemos en el plano XZ si queremos que el suelo sea la referencia
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
