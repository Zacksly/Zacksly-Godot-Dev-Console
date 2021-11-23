extends ConsoleCommand

var help_text = "Open a directory on pc (type list for a list of built-in directories)"

const directories = ["user", "exec_path", "desktop", "dcim", "documents", "movies", "music", "pictures", "screenshots"]

func command(args):
	match args[0]:
		"list":
			DevConsole.log_success("Built-in directories:")
			for dir in directories:
				DevConsole.log_warning("\t" + dir)
		"user":
			OS.shell_open(OS.get_user_data_dir())
		"exec_path":
			OS.shell_open(OS.get_executable_path())
		"desktop":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP))
		"dcim":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DCIM))
		"documents":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
		"downloads":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS))
		"movies":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_MOVIES))
		"music":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_MUSIC))
		"pictures":
			OS.shell_open(OS.get_system_dir(OS.SYSTEM_DIR_PICTURES))
		"screenshots":
			OS.shell_open(OS.get_user_data_dir() +"/screenshots")
		_:
			OS.shell_open(str("file://", args[0]))
