extends ConsoleCommand

var help_text = "Run a GDScript expression. The expression should be in quotes"
var output = []

func command(args):
	match args.size():
		0:
			DevConsole.log_error("Please specify code to run")
		1:
			DevConsole.log_success("Running Code... ")
			var expression = Expression.new()
			
			var error = expression.parse(args[0], [])
			if error != OK:
				DevConsole.log_error("Error: " + str(expression.get_error_text()))
				complete()
				return
				
			var output = expression.execute([], null, true)
			if !expression.has_execute_failed():
				DevConsole.log_success("\nResult:")
				DevConsole.log_normal(str(output))
			else:
				DevConsole.log_error("Error: execution failed")
				complete()
			
		2:
			DevConsole.log_error("Too many parameters, expression must be in quotes")	

