extends ConsoleCommand

var help_text = "Enable debug render modes"

func command(args):
	match args.size():
		0:
			DevConsole.log_error("Please specify a draw mode: 0 (normal), 1 (unshaded), 2 (overdraw), 3 (wireframe)")
		1:
			match args[0]:
				"0", "normal":
					get_viewport().debug_draw = 0
					VisualServer.set_debug_generate_wireframes(false)
					DevConsole.log_success("Render Mode set to 'normal'")
				"1", "unshaded":
					get_viewport().debug_draw = 1
					DevConsole.log_success("Render Mode set to 'unshaded'")
				"2", "overdraw":
					get_viewport().debug_draw = 2
					DevConsole.log_success("Render Mode set to 'overdraw'")
				"3", "wireframe":
					get_viewport().debug_draw = 3
					DevConsole.log_success("Render Mode set to 'wireframe'")
					DevConsole.log_warning("P.S. This mode is bugged by Godot\nReload of scene needed to take effect")
					VisualServer.set_debug_generate_wireframes(true)

	complete()
