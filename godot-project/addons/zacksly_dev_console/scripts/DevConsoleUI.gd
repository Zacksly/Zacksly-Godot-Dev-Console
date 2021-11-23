#       _____           _        _             |                                |                                                                               |
#      |__  / ___   ___| | _ ___| |_   _       |-------[File Information]-------|----[Links]------------------------------------------------------------------- |
#        / / / _ `|/ __| |/ / __| | | | |      |   [DevConsole: Version 1.0]    |       Website: https://zacksly.com                                            | 
#       / /_| (_| | (__|   <\__ \ | |_| |      |   [License: MIT]               |       Twitter: https://twitter.com/_Zacksly                                   |
#      /_____\__,_|\___|_|\_\___/_|\__, |      |                                |       Itch: https://itch.io/profile/zacksly                                   |
#      - https://github.com/Zacksly |__/       |                                |       Youtube: https://www.youtube.com/channel/UC6eIKGkSNxBwa0NyZn_ow0A       |
#===============================================================================================================================================================
class_name DevConsoleUI  # /
#=========================/

extends Node

var zackslyConsoleInfo = ["","[center]Zacksly DevConsole", "Version 1.0 Beta", "[color=#2ec057]https://github.com/Zacksly[/color][/center]"]

var dev_console_path = DevConsoleSettings.DEVCONSOLE_PATH

var theme_name = DevConsoleSettings.THEME

var log_history_length = DevConsoleSettings.LOG_HISTORY_LENGTH
var command_history_length = DevConsoleSettings.COMMAND_HISTORY_LENGTH
var dev_console

var current_history_index = 0

onready var view_container = $DevConsole  #Container for console view, should be a child of this GameObject
onready var log_text_area: RichTextLabel = $DevConsole/MainContainer/DevPanel/ScrollContainer/Log
onready var command_input: LineEdit = $DevConsole/MainContainer/DevPanel/CommandInput
onready var dev_panel := $DevConsole/MainContainer/DevPanel
onready var scroll_container: ScrollContainer = $DevConsole/MainContainer/DevPanel/ScrollContainer
onready var logo := $DevConsole/MainContainer/DevPanel/ZackslyDevConsoleLogo

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().get_root().connect("size_changed", self, "recenter_logo")
	
	if get_tree().current_scene != self:
		get_parent().call_deferred("remove_child", self);
		get_tree().current_scene.call_deferred("add_child", self);


	log_text_area.selection_enabled = true;

	toggle_visibility(true)
	dev_console = get_tree().root.get_node("DevConsole")
	dev_console.dev_console_ui = self
	dev_console.current_scene = get_tree().current_scene
	dev_console.root = get_tree().root
	update_log(zackslyConsoleInfo)

	#Set theme
	set_theme(load(dev_console_path + "themes/" + theme_name));	
	pass 

func recenter_logo():
	var viewport_rect = get_viewport().get_visible_rect()
	yield(get_tree(),"idle_frame")
	logo.position.x = viewport_rect.size.x * .5
	logo.position.y = dev_panel.rect_position.y * .5

func _input(inputEvent):
	if DevConsole.console_disabled:
		return
		
	#If key is pressed and it is not a repeated input
	if inputEvent is InputEventKey:
		
		# Default [`] : Show/hide the console
		if inputEvent.scancode == DevConsoleSettings.OPEN_KEY and !inputEvent.echo and !inputEvent.pressed:
			if DevConsole.open_pressed_count < DevConsole.unlock_count:
				DevConsole.open_pressed_count += 1
				if DevConsole.open_pressed_count == DevConsole.unlock_count:
					DevConsole.dev_mode_enabled = true
					yield(get_tree().create_timer(1.5),"timeout")
					DevConsole.log_success("Developer mode enabled")
			else:
				toggle_visibility()
		
		if DevConsole.console_disabled || !view_container.visible:
			return
		
		# Default [Enter] : Run Command
		if inputEvent.scancode == DevConsoleSettings.ENTER_KEY and !inputEvent.echo and inputEvent.pressed:
			send_command()
		# Default [↑] : Move up in history
		if inputEvent.scancode == DevConsoleSettings.HISTORY_FORWARD and !inputEvent.echo and !inputEvent.pressed:
			history_forward()
		# Default [↓] : Move up in history
		if inputEvent.scancode == DevConsoleSettings.HISTORY_BACK and !inputEvent.echo and !inputEvent.pressed:
			history_back()
		
	pass 

func history_forward():
	
	if current_history_index < DevConsole.command_history.size()-1:
		current_history_index += 1
		command_input.text = DevConsole.command_history[current_history_index]
		command_input.caret_position = command_input.text.length()
	pass
	
func history_back():
	
	if current_history_index > 0:
		current_history_index -= 1
		command_input.text = DevConsole.command_history[current_history_index]
		command_input.caret_position = command_input.text.length()
	pass
	
func toggle_visibility(is_init = false):
	recenter_logo()
	view_container.visible = !view_container.visible		
	
	# If we're now visible, focus on the line text field
	if view_container.visible:
		get_tree().paused = true
		if DevConsoleSettings.UNLOCK_MOUSE && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		yield(get_tree(), "idle_frame")
		command_input.grab_focus()
	else:
		get_tree().paused = false
		if DevConsoleSettings.LOCK_MOUSE && Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE && !is_init:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	command_input.clear();
	pass

func send_command():
	dev_console.run_command(command_input.text);
	command_input.text = "";
	pass

func update_log(new_log):
	
	if DevConsole.console_disabled:
		return
		
	if new_log == null:
		log_text_area.bbcode_text = "";
	else:
		var fullText = ""
		for i in range(0, new_log.size()):
			fullText += new_log[i] + "\n"
		log_text_area.bbcode_text = fullText
	
	var font: Font = log_text_area.get_font("JetBrainsMono-Regular");
	var lines = log_text_area.get_line_count();
	var letter_height = font.get_height();
	var height_offset = letter_height * lines;
	var text_area_size = log_text_area.rect_size.y;
	
	if height_offset < text_area_size:
		log_text_area.rect_position = Vector2(log_text_area.rect_position.x, text_area_size-height_offset - lines)
	else:
		log_text_area.rect_position = Vector2(0,0)
	
	
	log_text_area.scroll_to_line(log_text_area.get_line_count() -1);
	pass

func log_normal(text):
	dev_console.log("Logger: " + text);
	pass

func set_theme(theme):
	view_container.theme = theme;
	command_input.theme = theme;
	log_text_area.theme = theme;
	scroll_container.theme = theme;
	dev_panel.theme = theme;
	pass

func _on_Log_meta_clicked(meta):
	OS.shell_open(meta)
	pass
