extends ConsoleCommand

var help_text = "Example Command for learning Zacksly Console"

#    This is an example command for learning the Zacksly DevConsole
#    Try copying and pasting the following command into the dev console:
#    print this is the "Zacksly DevConsole"

func command(args):
	# Log text to console in green (usually used to notify a task completing successfully)
	DevConsole.log_success("Print Command Started!");

	# Log text in default color
	DevConsole.log_normal("Printing command arguments...");
	
	# Log all arguments to console in yellow (usually used to notify a warning)
	for i in range(0, args.size()):
		DevConsole.log_warning ("Argument " + str(i) + " is '" + str(args[i]) + "'");
	
	DevConsole.log_normal("Printed Successfuly!");
	# Log text to console in red (usually used to a task failure)
	DevConsole.log_error("Sorry, the print command is over :( !");
	
	# connect to another function
	var salutation = "Enjoy Zacksly Dev Console!";
	give_salutation(salutation);
	
	# Complete the command by deleting the command instance
	complete()
	pass

func give_salutation(text):
	#Log text in a specific color
	DevConsole.log_color("-- " + text + " :)" , "#d4882e");
