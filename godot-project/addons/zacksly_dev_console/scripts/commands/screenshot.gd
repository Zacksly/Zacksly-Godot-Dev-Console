extends ConsoleCommand

var audio_player

var help_text = "Takes a screenshot and save it to user directory. Optionally can use a countdown time parameter"
var time_left = -1
var screenshot_foldername = "screenshots"
var timer

func command(args):
	match args.size():
		0:
			audio_player = AudioStreamPlayer.new()
			add_child(audio_player)
			DevConsole.dev_console_ui.toggle_visibility()
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			_take_screenshot()
			DevConsole.dev_console_ui.toggle_visibility()
		1:
			_start_countdown(args[0])
			
func _take_screenshot():
	var image = DevConsole.current_scene.get_viewport().get_texture().get_data()
	image.flip_y()
	
	# Store Time data in filename
	var t = OS.get_datetime()
	var file_name = "Screenshot_" + str(t["day"]) + "-" + str(t["month"]) + "-" + str(t["year"]) + "~" + str(t["hour"]) + "_" + str(t["minute"]) + "-" + str(t["second"])
	
	var user_dir = OS.get_user_data_dir()

	# Check for screenshot directory
	var dir = Directory.new()
	if not dir.dir_exists(user_dir + "/" + screenshot_foldername):
		var error = dir.make_dir(user_dir + "/" + screenshot_foldername)
		if error:
			DevConsole.log_error("Error creating directory")
			complete()

	# Save file
	var filepath = user_dir + "/" + screenshot_foldername + "/" + file_name + ".png";
	image.save_png(filepath);

	DevConsole.log_success("Screenshot Taken [url]" + filepath + "[/url]");
	audio_player.volume_db = 0
	audio_player.stream = load("res://addons/zacksly_dev_console/audio/camera_click.ogg")
	audio_player.play()

func _start_countdown(time):
	time_left = float(time)
	
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = load("res://addons/zacksly_dev_console/audio/camera_tick.ogg")
	audio_player.volume_db = -10
	
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "_tick")
	timer.start()
	DevConsole.log_success("Countdown will being when console is closed")

func _tick():
	
	if time_left <= 0:
		timer.queue_free()
		_take_screenshot()
	else:
		time_left -= 1
		audio_player.play()
		DevConsole.log_warning("Screenshot in " + str(time_left+1))
	
