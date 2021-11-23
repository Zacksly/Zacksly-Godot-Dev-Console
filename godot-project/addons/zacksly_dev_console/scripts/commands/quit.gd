extends ConsoleCommand

var help_text = "Exits the application"

func command(args):
	DevConsole.log_success("Exiting Application...")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().quit()
