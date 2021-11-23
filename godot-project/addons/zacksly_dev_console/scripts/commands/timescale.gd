extends ConsoleCommand

var help_text = "Set engine timescale"

func command(args):
	match args.size():
		0:
			DevConsole.log_error("Please specify a time scale value")
		1:
			var float_value = float(args[0])
			if float_value <= 0:
				float_value = .0001
				
			DevConsole.log_success("Timescale set to " + str(float_value))
			Engine.time_scale = float_value

	complete()
