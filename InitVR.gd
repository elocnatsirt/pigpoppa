extends ARVROrigin

func _ready():
	# Find the interface and initialise
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if arvr_interface and arvr_interface.initialize():		
		# switch to ARVR mode
		get_viewport().arvr = true
		
		# keep linear color space, not needed and thus ignored with the GLES2 renderer
		get_viewport().keep_3d_linear = true
		
		# make sure vsync is disabled or we'll be limited to 60fps
		OS.vsync_enabled = false
		
		# up our physics to 90fps to get in sync with our rendering
		Engine.iterations_per_second= 90
