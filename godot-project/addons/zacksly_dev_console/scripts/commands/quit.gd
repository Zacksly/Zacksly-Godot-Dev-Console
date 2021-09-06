extends ConsoleCommand

var help_text = "Exits the application"

func command(args):
	get_tree().quit()
