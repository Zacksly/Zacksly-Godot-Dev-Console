extends ConsoleCommand

var help_text = "Fly camera mode. Will spawn at position of currently active camera"
var free_cam_node = null
var original_camera = null

func command(args):
	if DevConsole.root.has_node("free_cam_command/FreeCam"):
		free_cam_node = DevConsole.root.get_node("free_cam_command/FreeCam")
		if original_camera != null: 
			free_cam_node.get_parent().original_camera.current = true
			original_camera.visible = true
	match args.size():
		0:
			DevConsole.log_error("Error: Please specify 2D, 3D, or exit")
		1, 2:
			if free_cam_node != null && args[0] != "exit":
				if free_cam_node is Camera:
					DevConsole.log_error("Free cam 3D: Disabled")
				elif free_cam_node is Camera2D:
					DevConsole.log_error("Free cam 2D: Disabled")
					
				free_cam_node.get_parent().free()
				
			match args[0]:
				"2d", "2D":
					DevConsole.log_success("Free cam 2D Enabled")
					call_deferred("_spawn_camera_2D", args)
				"3D", "3d":
					DevConsole.log_success("Free cam 3D Enabled")
					call_deferred("_spawn_camera_3D", args)
				"exit":
					if free_cam_node != null:
						free_cam_node.get_parent().queue_free()
					else:
						DevConsole.log_error("Error: No free cam found")
					complete()
				_:
					DevConsole.log_error("Error: Please specify 2D or 3D")

func _spawn_camera_3D(args):
	var script = load("res://addons/zacksly_dev_console/scripts/command_utils/free_cam_3d.gd")
	free_cam_node = Camera.new()
	free_cam_node.set_script(script)
	free_cam_node.name = "FreeCam"
	add_child(free_cam_node)
	free_cam_node.get_parent().name = "free_cam_command"
	
	# Set Control Mode
	if args.size() == 2:
		match args[1]:
			"0", "false", "arrow", "arrowkey", "alt":
				free_cam_node.wasd_control_mode = false
			"1", "true", "wasd", "default":
				free_cam_node.wasd_control_mode = true
			_:
				DevConsole.log_error("Error, unknown control mode '" + str(args[1]) + "'")
			
	# Match to Live Camera
	original_camera = get_viewport().get_camera()
	if  original_camera != null && original_camera is Camera:
		free_cam_node.fov = original_camera.fov
		free_cam_node.global_transform = original_camera.global_transform
		free_cam_node.near = original_camera.near
		free_cam_node.far = original_camera.far
		original_camera.visible = false
		original_camera.current = false
	
		
	free_cam_node.current = true


func _spawn_camera_2D(args):
	var script = load("res://addons/zacksly_dev_console/scripts/command_utils/free_cam_2d.gd")
	free_cam_node = Camera2D.new()
	free_cam_node.set_script(script)
	free_cam_node.name = "FreeCam"
	add_child(free_cam_node)
	free_cam_node.get_parent().name = "free_cam_command"
	
	# Match to Live Camera2D
	original_camera = get_viewport().get_camera()
	if original_camera != null && original_camera is Camera2D:
		free_cam_node.global_position = original_camera.global_position
		free_cam_node.zoom = original_camera.zoom
		original_camera.visible = false
		original_camera.current = false
		
	free_cam_node.current = true
