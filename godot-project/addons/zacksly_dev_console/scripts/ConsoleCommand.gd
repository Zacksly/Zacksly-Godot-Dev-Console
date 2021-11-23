class_name ConsoleCommand

extends Node

var current_scene: Node 
var root: Node
var dev_console_ui: DevConsoleUI

# This function may get features in the future to report back data about the command
func complete():
	queue_free()
	pass
