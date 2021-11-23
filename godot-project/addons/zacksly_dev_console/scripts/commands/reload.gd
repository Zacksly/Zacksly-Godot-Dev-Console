extends ConsoleCommand

var help_text = "Reloads current scene"

func command(args):
	DevConsole.log_success("Reloading Current Scene...")
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().paused = false
	var current_scene = DevConsole.dev_console_ui.get_tree().reload_current_scene()
