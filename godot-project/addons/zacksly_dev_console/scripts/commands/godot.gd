extends ConsoleCommand

var help_text = "Get info about Godot. (type 'godot help' for a list of parameters)"

const parameters = ["version", "locale", "model", "os", "dpi", "vdriver"]

func command(args):
	match args.size():
		0:
			DevConsole.log_error("Please specify a parameter, type 'godot help' for a list of parameters")
		1:
			match args[0]:
				"help":
					DevConsole.log_success("Godot command parameters:")
					for param in parameters:
						DevConsole.log_warning("\t" + param)
				"version":
					var data = Engine.get_version_info()
					DevConsole.log_normal(data["string"])
				"locale":
					DevConsole.log_normal(OS.get_locale())
				"model":
					DevConsole.log_normal(OS.get_model_name())
				"os":
					DevConsole.log_normal(OS.get_name())
				"dpi":
					DevConsole.log_normal(str(OS.get_screen_dpi()))
				"vdriver":
					DevConsole.log_normal(OS.get_video_driver_name(OS.get_current_video_driver()))			
				

	complete()
