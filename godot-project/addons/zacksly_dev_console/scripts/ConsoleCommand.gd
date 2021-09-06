class_name ConsoleCommand

extends Node

var current_scene: Node
var root: Node
var dev_console_ui: DevConsoleUI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func complete():
	queue_free()
	pass
