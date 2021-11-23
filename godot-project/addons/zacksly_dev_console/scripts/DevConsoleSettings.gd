#       _____           _        _             |                                |                                                                               |
#      |__  / ___   ___| | _ ___| |_   _       |-------[File Information]-------|----[Links]------------------------------------------------------------------- |
#        / / / _ `|/ __| |/ / __| | | | |      |   [DevConsole: Version 1.0]    |       Website: https://zacksly.com                                            | 
#       / /_| (_| | (__|   <\__ \ | |_| |      |   [License: MIT]               |       Twitter: https://twitter.com/_Zacksly                                   |
#      /_____\__,_|\___|_|\_\___/_|\__, |      |                                |       Itch: https://itch.io/profile/zacksly                                   |
#      - https://github.com/Zacksly |__/       |                                |       Youtube: https://www.youtube.com/channel/UC6eIKGkSNxBwa0NyZn_ow0A       |
#===============================================================================================================================================================
class_name DevConsoleSettings  # /
#===============================/

# Disable use of DevConsole once game has been exported | Default = false
const ENABLED_ON_RELEASE_EXPORT = false

# Enable use of DevConsole if game has been exported with debug enabled | Default = true
const ENABLED_ON_DEBUG_EXPORT = true

# Which theme to use. Themes are located in the /zacksly_dev_console/themes folder | Default = dark_theme.tres
const THEME = "dark_theme.tres"

# How many log lines until lines are overritten | Default = 20
const LOG_HISTORY_LENGTH = 20 

# How many commands until command history is overritten | Default = 20
const COMMAND_HISTORY_LENGTH = 20 

# Whether or not to unlock mouse when DevConsole opens | Default = true
const UNLOCK_MOUSE = true

# Whether or not to relock mouse when DevConsole closes | Default = true
const LOCK_MOUSE = true

# How many times you have to press the console key before it allows you to open the console | Default = 0
const PRESS_TO_OPEN_AMOUNT = 0

# Path to DevConsole root. Just in case you would like to relocate it.
const DEVCONSOLE_PATH = "res://addons/zacksly_dev_console/"

# - KEYBINDS -------------------------------------------------------------------------------------#
# Key list available at: https://docs.godotengine.org/en/stable/classes/class_@globalscope.html   #
# ------------------------------------------------------------------------------------------------#

# Which Key opens the DevConsole 		| Default = KEY_QUOTELEFT ( [`] )
const OPEN_KEY = KEY_QUOTELEFT
# Which Key opens the DevConsole 		| Default = KEY_ENTER 
const ENTER_KEY = KEY_ENTER
# Which key moves back in history 		| Default = KEY_UP  
const HISTORY_BACK = KEY_UP 
# Which key moves forward in history	| Default = KEY_DOWN  
const HISTORY_FORWARD = KEY_DOWN

# ---------------------------------------------------------------------------------------------------
