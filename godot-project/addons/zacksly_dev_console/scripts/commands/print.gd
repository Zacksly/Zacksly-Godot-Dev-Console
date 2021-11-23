extends ConsoleCommand

var help_text = "Example command for learning Zacksly Console"

#    This is an example command for learning the Zacksly DevConsole
#    Try copying and pasting the following command into the dev console:
#    print this is the "Zacksly DevConsole"

func command(args):
	
	# Log text to console in green 
	# (usually used to notify a task completing successfully)
	DevConsole.log_success("Print Command Started!");

	# Log text in default color
	DevConsole.log_normal("Printing command arguments...");
	
	# Log all arguments to console in yellow 
	# (usually used to notify a warning)
	for i in range(0, args.size()):
		yield(get_tree().create_timer(.1), "timeout")
		DevConsole.log_warning ("Argument " + str(i) + " is '" + str(args[i]) + "'");
	
	# Provide a Status Update
	DevConsole.log_success("Printed Arguments Successfuly!");
	
	# Do a series up logs that overwrite the previous ones
	# Passing true as the second parameter overwrite the last line
	for i in range(0, 101):
		yield(get_tree().create_timer(.05), "timeout")
		DevConsole.log_success("Progress: " + str(i) + "%", true);
		
	# Log text to console in red (usually used to a task failure)
	DevConsole.log_error("Sorry, the print command is over :( !");
	
	# Connect to another function
	# Use BB Code styling
	# Muli-line Example
	var salutation = "That's all, \n[wave amp=25 freq=10]Enjoy Zacksly Dev Console![/wave]❤️";
	_give_salutation(salutation);
	
	# The complete command deletes the command instance/node
	# Not doing this may cause issues and will waste memory
	complete()
	pass

func _give_salutation(text):
	# Log text in a specific hex color
	DevConsole.log_color("-- " + text + " :)" , "#d4882e");
