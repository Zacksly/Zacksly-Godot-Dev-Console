extends ConsoleCommand

var help_text = "Reloads current scene"

func command(args):
	var current_scene = get_tree().get_current_scene().get_filename()
	get_tree().change_scene(current_scene)
