extends ConsoleCommand

var help_text = "Execute a command using OS.execute"
var command_thread = Thread.new()
var output = []

func command(args):
	
	match args.size():
		0:
			DevConsole.log_error("Please specify a command to execute")
		_:
			DevConsole.log_success("Running Command... ")
			var command_array = PoolStringArray(args)
			var comm = command_array[0]
			command_array.remove(0)
			command_thread.start(self, "_run_command_thread", [comm, command_array])
			

func _run_command_thread(arr):
	OS.execute(arr[0], arr[1], true, output) 
	call_deferred("log_result")

func log_result():
	DevConsole.log_success("\nResult:")
	for line in output:
		DevConsole.log_normal( "    " + line)
	complete()

func _exit_tree():
	command_thread.wait_to_finish()
