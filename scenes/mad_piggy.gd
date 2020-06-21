extends Spatial

onready var anim = $AnimationPlayer
var speed = 0.35
var cur_anim = ''
var dead = false
var cooldown = false
var stopped = true

func _ready():
	# Idle
	change_anim('Pig_Idle')


func _physics_process(delta):
	if !dead:
		# Chase player if spotted
		find_player()
		# Handle death
		if get_node("Sphere_Target_Root").health <= 0:
			dead()


func dead():
	dead = true
	get_node("Sphere_Target_Root").scale.y = 10
	get_node("Armature").visible = true
	get_node(".").rotate(Vector3(1, 0, 0), -90)
	anim.stop()
	yield(get_tree().create_timer(0.1), "timeout")
	get_node("Armature").visible = false


func change_anim(new_anim):
	if cur_anim != new_anim:
		anim.play(new_anim)
		cur_anim = new_anim


func ai_get_dir():
	return get_node("../ARVROrigin").transform.origin - self.transform.origin


func find_player():
	# If within player range, go towards player
	var dir = ai_get_dir()
	var distance = dir.dot(get_node("../ARVROrigin").transform.basis.z)
	if distance < 10 && distance > 1.5:
		stopped = false
		change_anim('Pig_Running')
		var motion = dir.normalized() * Vector3(-(speed), 0, -(speed))
		translate(motion)
	else:
		stopped = true
		change_anim('Pig_Idle')
		if !cooldown:
			if distance < 2:
				attack_player()

var curr_pos

func attack_player():
	# Play jump animation and move towards camera
	#change_anim('Pig_Attacking')
	curr_pos = self.transform.origin
	var dir = ai_get_dir()
	# Y doesn't reset enemy correctly still...
	var motion = dir.normalized() * Vector3(-(speed * 1.5), 0, -(speed * 1.5))
	translate(motion)
	# If hit successful deduct health and shake screen, else slide back?
	yield(get_tree().create_timer(0.5), "timeout")
	cooldown = true
