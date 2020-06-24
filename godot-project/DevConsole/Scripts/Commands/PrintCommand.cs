using Godot;
using ConsoleCommands;
using DeveloperConsole;

/*  
    This is an example command for learning the Zacksly DevConsole
    Try copying and pasting the following line into the dev console:
    print this is the "Zacksly DevConsole"
*/

public class PrintCommand : ConsoleCommand {
    public PrintCommand()
    {
        DevConsole.AddCommand("print", Print, "Example Command for learning Zacksly Console");
    }

    public void Print(string[] args) {
        //Log text to console in green
        DevConsole.LogSuccess("Print Command Started!");

        //Log text in default color
        DevConsole.Log("Printing command arguments...");

        //Log all arguments to console in yellow
        for(int i = 0; i < args.Length; i++){
            DevConsole.LogWarning($"Argument {i}: {args[i]}");
        }

        //Log text to console in red
        DevConsole.LogError("Print Command Completed!");
        
        //Logic in another function
        string salutation = "Enjoy Zacksly Dev Console!";
        GiveSalutation(salutation);
        
    }

    public void GiveSalutation(string text) {
        //Log text in a specific color
        DevConsole.LogColor($"-- {text} :)" , "#d4882e");
    }

}
