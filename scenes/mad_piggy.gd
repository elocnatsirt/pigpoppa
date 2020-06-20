extends Spatial


onready var anim = $AnimationPlayer

var cur_anim = ''

func _ready():
	change_anim('ArmatureAction')
	
func change_anim(new_anim):
	if cur_anim != new_anim:
		anim.play(new_anim)
		cur_anim = new_anim
