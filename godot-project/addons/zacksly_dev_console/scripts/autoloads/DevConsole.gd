#       _____           _        _             |                                |                                                                               |
#      |__  / ___   ___| | _ ___| |_   _       |-------[File Information]-------|----[Links]------------------------------------------------------------------- |
#        / / / _ `|/ __| |/ / __| | | | |      |   [DevConsole: Version 1.0]    |       Youtube: https://www.youtube.com/channel/UC6eIKGkSNxBwa0NyZn_ow0A       |              
#       / /_| (_| | (__|   <\__ \ | |_| |      |   [License: MIT]               |       Twitter: https://twitter.com/_Zacksly                                   |
#      /_____\__,_|\___|_|\_\___/_|\__, |      |                                |       Github: https://github.com/Zacksly                                      |
#      - https://github.com/Zacksly |__/       |                                |       Itch: https://itch.io/profile/zacksly                                   |
#===============================================================================================================================================================|

extends Node

var dev_console_scene = preload("res://addons/zacksly_dev_console/ui/DevConsole.tscn")
var command_path = "res://addons/zacksly_dev_console/scripts/commands/"

# Get references to Node Hierarchy to make coding more convenient
var current_scene: Node
var root: Node

var dev_console_ui;
var commandHistory: Array = []
var open_pressed_count = 0 # how many times [`] has been pressed
var unlock_count = DevConsoleSettings.PRESS_TO_OPEN_AMOUNT # how many times [`] needs to be pressed before opening the console

var commands = [];
var command_help_texts = [];

# Bool that is set when console is opened for the first time
var dev_mode_enabled = false
var console_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# If DISABLE_ON_RELEASE_EXPORT enabled and app is exported don't show console and bypass command calls
	if !DevConsoleSettings.ENABLED_ON_RELEASE_EXPORT && !OS.is_debug_build() && OS.has_feature("standalone"):
		console_disabled = true
		
	# If ENABLE_ON_DEBUG_EXPORT disabled and app is exported don't show console and bypass command calls
	if !DevConsoleSettings.ENABLED_ON_DEBUG_EXPORT && OS.is_debug_build() && OS.has_feature("standalone"):
		console_disabled = true
		
	launch_console()
	
func launch_console():
	var console = dev_console_scene.instance()
	get_tree().current_scene.call_deferred("add_child", console)
	dev_console_ui = console

	commands = get_commands(command_path)
	
	pass # Replace with function body.

func _process(delta):	
	if !is_instance_valid(dev_console_ui):
		launch_console()
		
		yield(get_tree(),"idle_frame")
		dev_console_ui.update_log(commandHistory)	

func run_command(command_string: String):
	log_normal("$ " + command_string)
	if command_string == "":
		return
	#var command_split = command_string.split(" ");
	var command_split = parse_command(command_string);
	var args = []
	
	if command_split.size() < 1:
		log_normal("Unable to process command '" + command_string + "'")
		pass
		
	elif command_split.size() >= 1:
		for i in range(0, command_split.size()):
			if i != 0:
				args.append(command_split[i])
	
	do_command(command_split[0].to_lower(), args);
	pass

func do_command(command_name: String, args: Array):
	var command_found = false
	# Check if is the help command
	if command_name == "help":
		help_command()
		return
	# Otherwise try something else
	else:
		for i in range(0, commands.size()):
			if command_name == commands[i]:
				command_found = true
				break
	
	# Create an instance of the command
	if command_found:
		
		var directory = Directory.new();
		var command_instance = null
		if  directory.file_exists (command_path + command_name + ".gd"):
			command_instance = load(command_path + command_name + ".gd").new()
		elif directory.file_exists (command_path + command_name + ".gdc"):
			command_instance = load(command_path + command_name + ".gdc").new()
		if command_instance == null:
			log_error("Command not found")
			return
			
		command_instance.dev_console_ui = dev_console_ui
		command_instance.current_scene = current_scene
		command_instance.root = root
		root.add_child(command_instance)
		command_instance.name = command_name + "_command"
		command_instance.command(args);
	else:
		var error: String = "Unknown command '" + command_name + "', type 'help' for list of commands.";
		log_error(error);
	pass

func log_normal(line: String, override_last = false): 
	if !is_instance_valid(dev_console_ui):
		return
		
	if commandHistory.size() >= dev_console_ui.log_history_length:
		commandHistory = commandHistory.slice(1,commandHistory.size(),1)
	
	if !override_last:
		commandHistory.append(line)
		dev_console_ui.update_log(commandHistory)
	else:
		commandHistory[-1] = line
		dev_console_ui.update_log(commandHistory)
	pass

func log_color(text, color, override_last = false):
	log_normal("[color=" + color +"]" +text + "[/color]", override_last)

func log_error(text, override_last = false):
	log_color(text, "#f48771", override_last)

func log_success(text, override_last = false):
	log_color(text, "#2ec057", override_last)

func log_warning(text, override_last = false):
	log_color(text, "#dcdcaa", override_last)

func help_command():
	var directory = Directory.new();
	for command_name in commands:
		
		var command_instance = null
		if directory.file_exists (command_path + command_name + ".gd"):
			command_instance = load(command_path + command_name + ".gd").new()
		elif directory.file_exists (command_path + command_name + ".gdc"):
			command_instance = load(command_path + command_name + ".gdc").new()
		if command_instance == null:
			log_error("Command not found")
			return
			
		var help_text = "No help info is listed for this command. Add a string var called 'help_text' in your command script to create one"
		
		if not command_instance.get("help_text") == null:
			help_text = command_instance.help_text
		
		log_normal("[color=#dcdcaa]" + str(command_name) + ": [color=#9cb8a7]" + help_text + "[/color]");
		command_instance.complete()

func get_commands(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if(file.ends_with(".gd") || file.ends_with(".gdc")):
				var command_name = file.get_basename()
				files.append(command_name)
	
	dir.list_dir_end()
	
	return files

func parse_command(command_text):
	var parsed_command = []
	var last_index = 0
	var waiting_for_quote = false;
	
	for i in range(0, command_text.length()):
		
		#print(command_text[i])
		
		if(i == command_text.length()-1):
			if waiting_for_quote and command_text[i] == '"' :
				parsed_command.append(command_text.substr(last_index,i-last_index))
			else:
				parsed_command.append(command_text.substr(last_index,i-last_index+1)) 
			waiting_for_quote = false
		
		elif command_text[i] == " " and !waiting_for_quote and i >= last_index:
			parsed_command.append(command_text.substr(last_index,i-last_index)) 
			last_index = i+1
		
		elif command_text[i] == '"':
			if waiting_for_quote:
				parsed_command.append(command_text.substr(last_index,i-last_index)) 
				last_index = i+2
			else:
				last_index = i+1	
			waiting_for_quote = !waiting_for_quote
	
	return parsed_command

