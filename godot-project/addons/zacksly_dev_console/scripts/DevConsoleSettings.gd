extends Node
class_name DevConsoleSettings

# Which theme to use. Themes are located in the /zacksly_dev_console/themes folder | Default = dark_theme.tres
const THEME = "hax_theme.tres"

# How many log lines until lines are overritten | Default = 20
const LOG_HISTORY_LENGTH = 20 

# Whether or not to unlock mouse when DevConsole opens | Default = true
const UNLOCK_MOUSE = true

# Whether or not to relock mouse when DevConsole closes | Default = true
const LOCK_MOUSE = true

# Which Key opens the DevConsole | Default = KEY_QUOTELEFT ( [`] )
# Key list available at: https://docs.godotengine.org/en/stable/classes/class_@globalscope.html
const OPEN_KEY = KEY_QUOTELEFT
# Which Key opens the DevConsole | Default = KEY_ENTER 
const ENTER_KEY = KEY_ENTER

# How many times you have to press the console key before it allows you to open the console | Default = 0
const PRESS_TO_OPEN_AMOUNT = 0

# Path to DevConsole root. Just in case you would like to relocate it.
const DEVCONSOLE_PATH = "res://addons/zacksly_dev_console/"
