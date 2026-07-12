import os

scene_content = """[gd_scene load_steps=9 format=3 uid="uid://cfxj82j1p1yq"]

[ext_resource type="Script" path="res://plano_calor.gd" id="1_heatmap"]
[ext_resource type="Texture2D" path="res://textures/wall.png" id="2_wall"]
[ext_resource type="Texture2D" path="res://textures/floor.png" id="3_floor"]
[ext_resource type="Texture2D" path="res://textures/wood.png" id="4_wood"]

[sub_resource type="PlaneMesh" id="PlaneMesh_calor"]
size = Vector2(21, 21)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_metal"]
albedo_color = Color(0.35, 0.35, 0.4, 1)
metallic = 0.8
roughness = 0.4

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_plastico_negro"]
albedo_color = Color(0.1, 0.1, 0.1, 1)
roughness = 0.8

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_cartel"]
albedo_color = Color(0.1, 0.7, 0.2, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_concreto"]
albedo_color = Color(1, 1, 1, 1)
albedo_texture = ExtResource("2_wall")
uv1_scale = Vector3(10, 3, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_piso"]
albedo_color = Color(1, 1, 1, 1)
albedo_texture = ExtResource("3_floor")
uv1_scale = Vector3(10, 10, 1)

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_madera"]
albedo_color = Color(1, 1, 1, 1)
albedo_texture = ExtResource("4_wood")
uv1_scale = Vector3(1, 2, 1)

[node name="EdificioLayout" type="Node3D"]

[node name="Piso_Facultad" type="CSGBox3D" parent="." groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.1, 0)
use_collision = true
size = Vector3(21, 0.2, 21)
material = SubResource("StandardMaterial3D_piso")

[node name="Muros" type="Node3D" parent="."]

[node name="Muro_Norte" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.5, -10.25)
use_collision = true
size = Vector3(21, 3, 0.5)
material = SubResource("StandardMaterial3D_concreto")

[node name="Muro_Sur" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.5, 10.25)
use_collision = true
size = Vector3(21, 3, 0.5)
material = SubResource("StandardMaterial3D_concreto")

[node name="Muro_Oeste" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -10.25, 1.5, 0)
use_collision = true
size = Vector3(0.5, 3, 20)
material = SubResource("StandardMaterial3D_concreto")

[node name="Muro_Este" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 10.25, 1.5, 0)
use_collision = true
size = Vector3(0.5, 3, 20)
material = SubResource("StandardMaterial3D_concreto")

[node name="Pared_Pasillo_Izquierda" type="CSGCombiner3D" parent="Muros" groups=["concreto"]]
use_collision = true

[node name="Solido" type="CSGBox3D" parent="Muros/Pared_Pasillo_Izquierda"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 1.5, 0)
size = Vector3(0.5, 3, 20)
material = SubResource("StandardMaterial3D_concreto")

[node name="Hueco_Puerta_Aula1" type="CSGBox3D" parent="Muros/Pared_Pasillo_Izquierda"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 1, -2.5)
operation = 2
size = Vector3(1, 2, 2)

[node name="Hueco_Puerta_Aula2" type="CSGBox3D" parent="Muros/Pared_Pasillo_Izquierda"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 1, 2.5)
operation = 2
size = Vector3(1, 2, 2)

[node name="Pared_Pasillo_Derecha" type="CSGCombiner3D" parent="Muros" groups=["concreto"]]
use_collision = true

[node name="Solido" type="CSGBox3D" parent="Muros/Pared_Pasillo_Derecha"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 1.5, 0)
size = Vector3(0.5, 3, 20)
material = SubResource("StandardMaterial3D_concreto")

[node name="Hueco_Puerta_Aula3" type="CSGBox3D" parent="Muros/Pared_Pasillo_Derecha"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 1, -2.5)
operation = 2
size = Vector3(1, 2, 2)

[node name="Hueco_Puerta_Aula4" type="CSGBox3D" parent="Muros/Pared_Pasillo_Derecha"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 1, 2.5)
operation = 2
size = Vector3(1, 2, 2)

[node name="Pared_Divisoria_Aulas1_2" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -6, 1.5, 0)
use_collision = true
size = Vector3(8, 3, 0.5)
material = SubResource("StandardMaterial3D_concreto")

[node name="Pared_Divisoria_Aulas3_4" type="CSGBox3D" parent="Muros" groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 6, 1.5, 0)
use_collision = true
size = Vector3(8, 3, 0.5)
material = SubResource("StandardMaterial3D_concreto")

[node name="Techo_Habitacion4" type="CSGBox3D" parent="." groups=["concreto"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 6, 3.1, 5)
use_collision = true
size = Vector3(8.5, 0.2, 10.5)
material = SubResource("StandardMaterial3D_concreto")

[node name="Puertas" type="Node3D" parent="."]

[node name="Puerta_Aula1" type="CSGBox3D" parent="Puertas" groups=["madera"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 1, -2.5)
use_collision = true
size = Vector3(0.5, 2, 1.5)
material = SubResource("StandardMaterial3D_madera")

[node name="Puerta_Aula2" type="CSGBox3D" parent="Puertas" groups=["madera"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 1, 2.5)
use_collision = true
size = Vector3(0.5, 2, 1.5)
material = SubResource("StandardMaterial3D_madera")

[node name="Puerta_Aula3" type="CSGBox3D" parent="Puertas" groups=["madera"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 1, -2.5)
use_collision = true
size = Vector3(0.5, 2, 1.5)
material = SubResource("StandardMaterial3D_madera")

[node name="Puerta_Aula4" type="CSGBox3D" parent="Puertas" groups=["madera"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 1, 2.5)
use_collision = true
size = Vector3(0.5, 2, 1.5)
material = SubResource("StandardMaterial3D_madera")

[node name="Plano_Calor" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.05, 0)
mesh = SubResource("PlaneMesh_calor")
script = ExtResource("1_heatmap")
"""

scene_content += """
[node name="Luces" type="Node3D" parent="."]

[node name="Luz_Pasillo_1" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.5, -5)
omni_range = 10.0
light_energy = 0.8

[node name="Luz_Pasillo_2" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.5, 5)
omni_range = 10.0
light_energy = 0.8

[node name="Luz_Aula1" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -6, 2.5, -5)
omni_range = 12.0
light_energy = 1.0

[node name="Luz_Aula2" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -6, 2.5, 5)
omni_range = 12.0
light_energy = 1.0

[node name="Luz_Aula3" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 6, 2.5, -5)
omni_range = 12.0
light_energy = 1.0

[node name="Luz_Aula4" type="OmniLight3D" parent="Luces"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 6, 2.5, 5)
omni_range = 12.0
light_energy = 1.0

[node name="Mobiliario" type="Node3D" parent="."]
"""

def add_table(name, x, z):
    return f"""
[node name="{name}" type="CSGBox3D" parent="Mobiliario" groups=["madera"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, {x}, 0.75, {z})
use_collision = true
size = Vector3(1.2, 0.05, 0.8)
material = SubResource("StandardMaterial3D_madera")
[node name="{name}_Pata1" type="CSGBox3D" parent="Mobiliario/{name}"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.5, -0.375, -0.3)
size = Vector3(0.05, 0.75, 0.05)
[node name="{name}_Pata2" type="CSGBox3D" parent="Mobiliario/{name}"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.5, -0.375, -0.3)
size = Vector3(0.05, 0.75, 0.05)
[node name="{name}_Pata3" type="CSGBox3D" parent="Mobiliario/{name}"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -0.5, -0.375, 0.3)
size = Vector3(0.05, 0.75, 0.05)
[node name="{name}_Pata4" type="CSGBox3D" parent="Mobiliario/{name}"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0.5, -0.375, 0.3)
size = Vector3(0.05, 0.75, 0.05)
[node name="{name}_Laptop" type="CSGCombiner3D" parent="Mobiliario" groups=["metal"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, {x}, 0.775, {z - 0.1})
use_collision = true
[node name="Base" type="CSGBox3D" parent="Mobiliario/{name}_Laptop"]
size = Vector3(0.4, 0.02, 0.3)
material = SubResource("StandardMaterial3D_metal")
[node name="Pantalla" type="CSGBox3D" parent="Mobiliario/{name}_Laptop"]
transform = Transform3D(1, 0, 0, 0, 0.965926, -0.258819, 0, 0.258819, 0.965926, 0, 0.12, -0.15)
size = Vector3(0.4, 0.25, 0.02)
material = SubResource("StandardMaterial3D_metal")
[node name="{name}_Silla" type="CSGCombiner3D" parent="Mobiliario" groups=["metal"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, {x}, 0.25, {z + 0.4})
use_collision = true
[node name="Asiento" type="CSGBox3D" parent="Mobiliario/{name}_Silla"]
size = Vector3(0.4, 0.05, 0.4)
material = SubResource("StandardMaterial3D_metal")
[node name="Respaldo" type="CSGBox3D" parent="Mobiliario/{name}_Silla"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.2, 0.175)
size = Vector3(0.4, 0.4, 0.05)
material = SubResource("StandardMaterial3D_metal")
"""

for i, x in enumerate([-7.5, -6.0, -4.5]):
    for j, z in enumerate([-8, -6, -4, -2]):
        scene_content += add_table(f"MesaB_{i}_{j}", x, z)

for i, x in enumerate([-7.5, -6.0, -4.5]):
    for j, z in enumerate([2, 4, 6, 8]):
        scene_content += add_table(f"MesaA_{i}_{j}", x, z)

def add_locker(name, x, z):
    return f"""
[node name="{name}" type="CSGBox3D" parent="Mobiliario" groups=["metal"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, {x}, 1.0, {z})
use_collision = true
size = Vector3(0.6, 2.0, 0.6)
material = SubResource("StandardMaterial3D_metal")
[node name="Linea" type="CSGBox3D" parent="Mobiliario/{name}"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0.3)
operation = 2
size = Vector3(0.05, 1.9, 0.05)
"""

for i in range(12):
    # Place lockers against the north wall of Aula C (Right Room, x is 3 to 10, z is -10 to 0)
    # North wall is z = -10
    scene_content += add_locker(f"Locker_{i}", 3.0 + i * 0.61, -9.8)

# Detalles del Pasillo: Rendijas (Vents)
for i, z in enumerate([-7.5, -3.5, 3.5, 7.5]):
    # Rendijas izquierda (subtract from Pared_Pasillo_Izquierda)
    scene_content += f"""
[node name="Rendija_Izq_{i}" type="CSGBox3D" parent="Muros/Pared_Pasillo_Izquierda"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.75, 2.6, {z})
operation = 2
size = Vector3(1.0, 0.5, 2.5)
"""
    # Rendijas derecha (subtract from Pared_Pasillo_Derecha)
    scene_content += f"""
[node name="Rendija_Der_{i}" type="CSGBox3D" parent="Muros/Pared_Pasillo_Derecha"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.75, 2.6, {z})
operation = 2
size = Vector3(1.0, 0.5, 2.5)
"""

# Detalles del Pasillo: Tachos de Basura y Carteles
scene_content += """
[node name="Detalles_Pasillo" type="Node3D" parent="."]
"""

# Tachos de Basura
for i, z in enumerate([-8, 0, 8]):
    # Tacho Izquierda
    scene_content += f"""
[node name="Tacho_Izq_{i}" type="CSGCylinder3D" parent="Detalles_Pasillo" groups=["metal"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.2, 0.4, {z})
radius = 0.25
height = 0.8
material = SubResource("StandardMaterial3D_plastico_negro")
"""
    # Tacho Derecha
    scene_content += f"""
[node name="Tacho_Der_{i}" type="CSGCylinder3D" parent="Detalles_Pasillo" groups=["metal"]]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.2, 0.4, {z + 2})
radius = 0.25
height = 0.8
material = SubResource("StandardMaterial3D_plastico_negro")
"""

# Cartelitos al lado de las puertas
puertas_z = [-2.5, 2.5]
for i, z in enumerate(puertas_z):
    # Cartel Izquierda
    scene_content += f"""
[node name="Cartel_Izq_{i}" type="CSGBox3D" parent="Detalles_Pasillo"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.45, 1.8, {z - 1.2})
size = Vector3(0.1, 0.3, 0.3)
material = SubResource("StandardMaterial3D_cartel")
"""
    # Cartel Derecha
    scene_content += f"""
[node name="Cartel_Der_{i}" type="CSGBox3D" parent="Detalles_Pasillo"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.45, 1.8, {z - 1.2})
size = Vector3(0.1, 0.3, 0.3)
material = SubResource("StandardMaterial3D_cartel")
"""

with open("c:/Users/ANDREA/OneDrive - Universidad Privada Peruano Alemana/Documentos/proyecto-wifi/habitaciones.tscn", "w") as f:
    f.write(scene_content)
