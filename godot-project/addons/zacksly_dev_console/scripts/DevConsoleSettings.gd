#       _____           _        _             |                                |                                                                               |
#      |__  / ___   ___| | _ ___| |_   _       |-------[File Information]-------|----[Links]------------------------------------------------------------------- |
#        / / / _ `|/ __| |/ / __| | | | |      |   [DevConsole: Version 1.0]    |       Youtube: https://www.youtube.com/channel/UC6eIKGkSNxBwa0NyZn_ow0A       |              
#       / /_| (_| | (__|   <\__ \ | |_| |      |   [License: MIT]               |       Twitter: https://twitter.com/_Zacksly                                   |
#      /_____\__,_|\___|_|\_\___/_|\__, |      |                                |       Github: https://github.com/Zacksly                                      |
#      - https://github.com/Zacksly |__/       |                                |       Itch: https://itch.io/profile/zacksly                                   |
#===============================================================================================================================================================|
class_name DevConsoleSettings

# Disable use of DevConsole once game has been exported | Default = false
const ENABLED_ON_RELEASE_EXPORT = false

# Enable use of DevConsole if game has been exported with debug enabled | Default = true
const ENABLED_ON_DEBUG_EXPORT = true

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
