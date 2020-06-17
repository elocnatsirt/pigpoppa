extends VR_Interactable_Rigidbody

var spray_mesh
var spray_sound
var decal_projector = preload("res://scenes/ProjectedDecal.tscn")
onready var fire_point = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/Spray/Position3D")


func _ready():
	spray_mesh = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/Spray")
	spray_mesh.visible = false
	spray_sound = get_node("SpraycanMesh/SpraycanTop/SprayTrigger/AudioStreamPlayer3D")


# Ensure this runs only when picked up.
func _process(delta):
	if controller != null:
		if controller.trigger_down:
			spray()
		else:
			if spray_mesh.visible:
				spray_mesh.visible = false
				spray_sound.stop()


func spray():
	# Paint decal
	var decal = decal_projector.instance()
	get_tree().get_root().add_child(decal)
	decal.global_transform = fire_point.global_transform
	# Show spraybeam placeholder
	spray_mesh.visible = true
	# Give user feedback
	controller.rumble = 0.05
	if !spray_sound.is_playing():
		spray_sound.play()
