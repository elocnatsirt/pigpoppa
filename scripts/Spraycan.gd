extends VR_Interactable_Rigidbody

var can_mesh
var spray_sound
var decal_projector = preload("res://scenes/ProjectedDecal.tscn")
onready var fire_point = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/Spray/Position3D")
onready var particle = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/Spray")
var colors = ['white', 'pink', 'orange', 'yellow', 'blue', 'purple', 'green', 'grey', 'black']

export var color = 'gold'


func _ready():
	print(color)
	can_mesh = get_node("SpraycanMesh")
	var can_mat = can_mesh.get_surface_material(0)
	can_mat = can_mat.duplicate()
	can_mat.albedo_color = Color(color)
	can_mesh.set_surface_material(0, can_mat)
	print(can_mat)
	spray_sound = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/AudioStreamPlayer3D")
	particle.visible = false


# Ensure this runs only when picked up.
func _process(delta):
	if controller != null:
		if controller.trigger_down:
			spray()
		else:
			if particle.visible:
				particle.visible = false
				spray_sound.stop()


func spray():
	# Paint decal
	var decal = decal_projector.instance()
	get_tree().get_root().add_child(decal)
	decal.material_override.albedo_color = Color(color)
	decal.global_transform = fire_point.global_transform
	# Show spraybeam placeholder
	if !particle.visible:
		particle.visible = true
	# Give user feedback
	controller.rumble = 0.05
	if !spray_sound.is_playing():
		spray_sound.play()


func picked_up():
	# Register color in menu UI
	match color:
		'F2EFE9':
			change_can_color('Can')
		'CC004E':
			change_can_color('Can2')
		'FF3F00':
			change_can_color('Can3')
		'FFD639':
			change_can_color('Can4')
		'00A7E1':
			change_can_color('Can5')
		'31081F':
			change_can_color('Can6')
		'00AF54':
			change_can_color('Can7')
		'837569':
			change_can_color('Can8')
		'121113':
			change_can_color('Can9')


# can == can name in menu hierarchy
func change_can_color(can):
	var new_can = get_parent().get_node("ARVROrigin/Player_Camera/Menu/CanGui/" + can + "/Highlight")
	if !new_can.visible:
		new_can.get_surface_material(0).albedo_color = color
		new_can.visible = true
		get_parent().get_node("ARVROrigin/Player_Camera/Menu/CanGui").visible = true
		get_parent().get_node("ARVROrigin/Player_Camera/Menu/AudioStreamPlayer3D").play()
		yield(get_tree().create_timer(3), "timeout")
		get_parent().get_node("ARVROrigin/Player_Camera/Menu/CanGui").visible = false
