# Documentación del Proyecto y Simulador de Propagación WiFi (FISI - UNMSM)

## 1. Contexto y Objetivos del Proyecto
El acceso a redes inalámbricas de calidad dentro de las instalaciones universitarias es un factor determinante para el rendimiento académico. En el pabellón de la **Facultad de Ingeniería de Sistemas e Informática (FISI)** de la UNMSM, la infraestructura de red WiFi debe lidiar con aulas de concreto armado y ambientes con mobiliario metálico, lo cual genera una distribución heterogénea de la señal.

Este proyecto tiene como objetivo analizar la propagación y atenuación de señales WiFi (2.4 GHz) mediante **mediciones experimentales de RSSI en 54 puntos** (distribuidos en el pasillo principal y tres aulas), generando mapas de calor y simulaciones que contrastan los datos reales con los modelos teóricos de pérdida en espacio libre (FSPL).

---

## 2. Bases Teóricas y Modelado Físico
Para comprender las caídas de señal y las "zonas muertas", el proyecto se fundamenta en los siguientes principios electromagnéticos:

### A. Longitud de Onda ($\lambda$) y Frecuencia
El WiFi a 2.4 GHz tiene una longitud de onda de aproximadamente **12.5 cm**. Esta magnitud es clave: diferencias de recorrido espacial de apenas 6.25 cm (medio ciclo) producto de rebotes en paredes pueden generar un desfase de 180°, cancelando la señal (interferencia destructiva).

### B. Propagación por Multicamino (*Multipath*) e Interferencia
En interiores, la señal choca con la arquitectura:
* **Concreto:** Genera absorción (pérdidas típicas de 20 a 30 dB) y dispersión.
* **Metal (Casilleros):** Actúa como conductor, provocando reflexión casi total (barrera de Faraday).
La superposición de estas ondas reflejadas genera **Interferencia Constructiva** (zonas de excelente conexión) e **Interferencia Destructiva** (zonas muertas espaciales).

---

## 3. Arquitectura del Simulador 3D (Godot 4)
Para complementar el análisis numérico (basado en interpolación RBF y Python/Flask), se desarrolló un entorno interactivo en Godot que recrea la propagación espacial del pabellón de la FISI, calculando dinámicamente el RSSI.

### Lógica Matemática del Simulador
La ecuación implementada en el código calcula el RSSI basándose en la atenuación por distancia y por penetración de obstáculos (Raycasting):
$$ \text{RSSI (dBm)} = \text{Potencia Base} - 20\log_{10}(d) - \sum (\text{Atenuación Obstáculos}) $$

Las penalizaciones configuradas en el motor de físicas son coherentes con la teoría:
* **Metal (`"Casillero"`):** Resta 30 dBm (Reflejo casi total).
* **Concreto (`"Muro"`):** Resta 35 dBm (Alta pérdida).
* **Madera (`"Puerta"`):** Resta 5 dBm.

### Descripción de los Scripts
* **`generador.gd`**: Construye el mapa estático instanciando los 54 sensores exactos del estudio (Aula A: 12, Aula B: 9, Aula C: 9, Pasillo: 24).
* **`sensor.gd`**: Calcula el rayo directo al router atravesando hasta 10 obstáculos para definir la intensidad de señal de ese punto de la grilla.
* **`wifi_particle.gd`**: Representa el comportamiento dinámico (frentes de onda o trazos). Esta "onda" viaja y **rebota** físicamente en superficies metálicas, o tiene probabilidad de dispersión en el concreto, ilustrando el fenómeno de *multipath*.
* **`generate_layout.gd`**: Construcción procedural (`@tool`) del pabellón, paredes y puertas mediante geometría CSG.
* **`orbit_camera.gd`**: Cámara interactiva que permite manipular a un receptor móvil ("Player") en tiempo real.

---

## 4. Mapa de Calor: Simulador vs Resultados Experimentales
La simulación interpola los valores de **-90 dBm a -40 dBm** en 5 rangos de colores, los cuales concuerdan de manera precisa con los resultados medidos en el pabellón de la FISI:

1. **Zona Verde / Señal Excelente (-40 a -55 dBm):**
   * **Resultados reales:** Aula A (donde está el router) promedió **-45.8 dBm**.
   * **Simulador:** El cálculo logarítmico sin obstáculos directos pinta esta sala de color verde intenso.
2. **Zona Amarilla / Señal Media (-55 a -70 dBm):**
   * **Resultados reales:** El pasillo central promedió **-70.9 dBm**, actuando como guía de onda.
   * **Simulador:** Muestra atenuación gradual amarilla en el corredor.
3. **Zona Roja / Señal Crítica a Nula (-70 a -90 dBm):**
   * **Resultados reales:** El Aula B (con los casilleros metálicos) registró un promedio de **-85.3 dBm**, con mínimos de -90 dBm (saturación). El Aula C promedió -77.4 dBm.
   * **Simulador:** Refleja la interferencia destructiva masiva. Al atravesar el nodo de "Metal", el algoritmo resta 30 dBm, tiñendo el Aula B de color rojo oscuro al instante.

---

## 5. Conclusiones
* La distribución de la señal WiFi a 2.4 GHz en el pabellón de la FISI es altamente heterogénea debido al impacto de la infraestructura (concreto) y mobiliario (casilleros metálicos).
* Existe una diferencia de hasta **39.5 dB** entre el Aula A y el Aula B, lo que significa que la señal cae en un factor de ~9,000 veces. Los modelos teóricos (FSPL) subestiman esta pérdida si no se consideran los materiales, algo que el simulador en Godot sí logra corregir mediante sus cálculos de colisión (Shadowing Loss).
* Las representaciones dinámicas (*wifi_particle*) y el mapa de calor estático comprueban visualmente la existencia de "zonas muertas", sirviendo de base justificativa para la reubicación de los AP (Access Points) en el recinto, priorizando el Aula C y los extremos del pasillo.
