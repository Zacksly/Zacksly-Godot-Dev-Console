extends ConsoleCommand

var help_text = "Clears the dev console log"

func command(args):
	DevConsole.log_success("Clearing Log...")
	yield(get_tree().create_timer(1), "timeout")
	DevConsole.log_history = []
	DevConsole.dev_console_ui.update_log([])
	complete()
