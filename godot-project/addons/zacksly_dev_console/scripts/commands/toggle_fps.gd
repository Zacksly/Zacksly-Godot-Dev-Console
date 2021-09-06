extends ConsoleCommand

var help_text = "Toggle frames per second counter"


onready var fps_counter: Label;

func command(args):
	if not DevConsole.root.has_node("toggle_fps_command/FPS_Counter"):
		fps_counter = Label.new()
		self.add_child(fps_counter)
		fps_counter.name = "FPS_Counter"
		DevConsole.log_success("FPS Counter Enabled")
	else:
		var old_command = DevConsole.root.get_node("toggle_fps_command")
		old_command.queue_free()
		DevConsole.log_success("FPS Counter Disabled")
		complete()
	pass 

func _process(delta):
	fps_counter.text = "FPS: " + str(Engine.get_frames_per_second())  
	pass


