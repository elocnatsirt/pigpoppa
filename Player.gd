extends ARVROrigin

var health
onready var healthbar = get_node("Player_Camera/Menu/HealthGui/Health/HealthBar")

func _ready():
	health = 95

func _process(delta):
	if health > 0:
		if healthbar.scale.x != (health * 0.01):
			healthbar.scale.x = (health * 0.01)
	else:
		game_over()

func game_over():
	var gui = get_node("Player_Camera/Menu/GameOverGui")
	gui.visible = true
	get_node("Player_Camera/Menu/CanGui").visible = true
	get_node("Player_Camera/Menu/MenuGui").visible = true
	get_node("Player_Camera/Menu/HealthGui").visible = true
	
	get_node("Left_Controller/RayCast").enabled = false
	get_node("Right_Controller/RayCast").enabled = false
	get_node("Right_Controller").grab_mode = "RAYCAST"
	get_node("Left_Controller").grab_mode = "RAYCAST"
