//==================================================================================\\
//       _____           _        _             |-------[File Information]-------  	\\                                                         
//      |__  / ___   ___| | _ ___| |_   _       |   [DevConsole: Version 1.0]     	\\
//        / / / _ `|/ __| |/ / __| | | | |      |   [License: MIT]               	\\
//       / /_| (_| | (__|   <\__ \ | |_| |      |   	                        	\\ 
//      /_____\__,_|\___|_|\_\___/_|\__, |      |                                  	\\        
//      - https://github.com/Zacksly |__/       |                                	\\
//                                              |                              		\\
//==================================================================================\\
// 	Zacksly Links:  																\\
//		Youtube: https://www.youtube.com/channel/UC6eIKGkSNxBwa0NyZn_ow0A 			\\
//		Twitter: https://twitter.com/_Zacksly										\\
//		Github: https://github.com/Zacksly 											\\
//		Itch: https://itch.io/profile/zacksly    									\\
//==================================================================================\\
// 			Github Project: github.com/Zacksly/Zacksly-Godot-Dev-Console]    		\\
// 				Special thanks to Eliot Lash's tutorial: 							\\
//			https://hub.packtpub.com/making-game-console-unity-part-2/      		\\     	
//==================================================================================\\

using Godot;
using System;
using System.Collections.Generic;
using System.Reflection;
using ConsoleCommands;
using System.Linq;
using System.Text.RegularExpressions;
using System.Text;

namespace DeveloperConsole { 

	public delegate void CommandHandler(string[] args);

	public class DevConsole {
		//Get reference to Node Hierarchy
		public static Node SceneSpace;
		public static Node Root;
		//System Reference to Document Folder
		private string myDocuments = System.Environment.GetFolderPath(System.Environment.SpecialFolder.MyDocuments);

		public static DevConsoleUI consoleUI;

		// Used to communicate with ConsoleView
		public delegate void LogChangedHandler(string[] log);
		public static event LogChangedHandler logChanged;
		
		//Holds information for each command
		class CommandRegistration {
			public string command { get; private set; }
			public CommandHandler handler { get; private set; }
			public string help { get; private set; }
			
			public CommandRegistration(string command, CommandHandler handler, string help) {
				this.command = command;
				this.handler = handler;
				this.help = help;
			}
		}

		//How many lines should be recorded
		public static int logSize = 20;

		internal static Queue<string> logQueue = new Queue<string>(logSize);
		internal static List<string> commandHistory = new List<string>();
		static Dictionary<string, CommandRegistration> commands = new Dictionary<string, CommandRegistration>();

		public static string[] log { get; private set; } //Copy of logQueue as an array for easier use by ConsoleView
		
		const string repeatCmdName = "!!"; //Name of the repeat command, constant since it needs to skip these if they are in the command history
		
		static DevConsole() {
			//Register Default Commands
			AddCommand("help", Help, "Show this command list.");
			AddCommand(repeatCmdName, RepeatCommand, "Repeat last command.");
			AddCommand("quit", Quit, "Quit the application.");
			AddCommand("reload", Reload, "Reload the current scene.");
			AddCommand("clear", Clear, "Clears the log of all text");
			AddCommand("timescale", SetTimeScale, "Set the time scale");
			AddCommand("sys_data", GetSystemData, "Gets current hardware information");
			
			//Add Custom Commands through reflection
			GetConsoleCommands();
		}

		static void GetConsoleCommands()
		{
			Type parentType = typeof(ConsoleCommand);
			Assembly assembly = Assembly.GetExecutingAssembly();
			IEnumerable<Type> types = FindDerivedTypes(assembly, parentType);
			
			foreach (var type in types)
			{
				var command = $"ConsoleCommands.{type.Name}, {assembly.GetName().Name} | {types.Count() }";
				var instance = Activator.CreateInstance(type);
			}
		}

		public static IEnumerable<Type> FindDerivedTypes(Assembly assembly, Type baseType)
		{
			return assembly.GetTypes().Where(t => baseType.IsAssignableFrom(t));
		}
	
		//This registers a command in the dev console
		public static void AddCommand(string command, CommandHandler handler, string help) {
			commands.Add(command, new CommandRegistration(command, handler, help));
		}
		
		public static void Log(string line) {
			GD.Print(line);
			
			if (logQueue.Count >= DevConsole.logSize) {
				logQueue.Dequeue();
			}
			logQueue.Enqueue(line);
			
			log = logQueue.ToArray();
			consoleUI.UpdateLog(log);
		}
		
		//Commands without parameters
		public static void RunCommand(string commandString) {
			Log("$ " + commandString);
			
			string[] commandSplit = ParseArguments(commandString);
			string[] args = new string[0];
			if (commandSplit.Length < 1) {
				Log(string.Format("Unable to process command '{0}'", commandString));
				return;
				
			}  else if (commandSplit.Length >= 2) {
				int numArgs = commandSplit.Length - 1;
				args = new string[numArgs];
				Array.Copy(commandSplit, 1, args, 0, numArgs);
			}
			RunCommand(commandSplit[0].ToLower(), args);
			commandHistory.Add(commandString);
		}

		//Commands that include parameters
		public static void RunCommand(string commandName, string[] args) {
			CommandRegistration command = null;
			if (!commands.TryGetValue(commandName, out command)) {
				var error = $"Unknown command '{commandName}', type 'help' for list.";
				LogError(error);
			} 
			else {
				if (command.handler == null) {
					var error = $"Unable to process command '{commandName}', handler was null.";
					LogError(error);
				}  else {
					command.handler(args);
				}
			}
		}

		//Preset Colors for Visual Feedback
		public static void LogError(string text){
			//Log($"[color=#f48771]{text}[/color]");
			LogColor(text, "#f48771");
		}
		public static void LogSuccess(string text){
			//Log($"[color=#2ec057]{text}[/color]");
			LogColor(text, "#2ec057");
		}
		public static void LogWarning(string text){
			//Log($"[color=#dcdcaa]{text}[/color]");
			LogColor(text, "#dcdcaa");
		}

		//Log with specified hex color or Godot Color (List of colors names can be found at https://docs.godotengine.org/en/stable/classes/class_color.html#constants)
		public static void LogColor(string text, string color){
			Log($"[color={color}]{text}[/color]");
		}

		public static string[] ParseArguments(string cmdLine)
		{
			var args = new List<string>();
			if (string.IsNullOrWhiteSpace(cmdLine)) return args.ToArray();

			var currentArg = new StringBuilder();
			bool inQuotedArg = false;

			for (int i = 0; i < cmdLine.Length; i++)
			{
				if (cmdLine[i] == '"')
				{
					if (inQuotedArg)
					{
						args.Add(currentArg.ToString());
						currentArg = new StringBuilder();
						inQuotedArg = false;
					}
					else
					{
						inQuotedArg = true;
					}
				}
				else if (cmdLine[i] == ' ')
				{
					if (inQuotedArg)
					{
						currentArg.Append(cmdLine[i]);
					}
					else if (currentArg.Length > 0)
					{
						args.Add(currentArg.ToString());
						currentArg = new StringBuilder();
					}
				}
				else
				{
					currentArg.Append(cmdLine[i]);
				}
			}

			if (currentArg.Length > 0) args.Add(currentArg.ToString());

			return args.ToArray();
		}

		#region Built-in commands
		static void Help(string[] args) {
			foreach(CommandRegistration commandRef in commands.Values) {
				Log($"[color=#dcdcaa]{commandRef.command}: [color=#9cb8a7]{commandRef.help}[/color]");
			}
		}
		
		static void RepeatCommand(string[] args) {
			for (int cmdIdx = commandHistory.Count - 1; cmdIdx >= 0; --cmdIdx) {
				string cmd = commandHistory[cmdIdx];
				if (String.Equals(repeatCmdName, cmd)) {
					continue;
				}
				RunCommand(cmd);
				break;
			}
		}
		
		static void Reload(string[] args) {
			SceneSpace.GetTree().ReloadCurrentScene();
		}

		static void Quit(string[] args){
			SceneSpace.GetTree().Quit();
		}

		static void Clear(string[] args){
			logQueue.Clear();
			log = logQueue.ToArray();
			consoleUI.UpdateLog(log);
		}

		static void SetTimeScale(string[] args){
			var time = Regex.Replace(args[0], "[^.0-9]", "");
			Engine.TimeScale = float.Parse(time);

			Log($"Time scale set to {time}");
		}

		static void GetSystemData(string[] args){
			Log($"Operating System: { OS.GetName() }");
			Log($"Thread Count: { OS.GetProcessorCount() }");
			Log($"Video Driver: { OS.GetCurrentVideoDriver() }");
		}
		#endregion
	}
}