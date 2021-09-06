using Godot;
using ConsoleCommands;
using DeveloperConsole;

public class TemplateCommand : ConsoleCommand //Commands must derive from ConsoleCommand.cs
{
    //Constructor for registering Command with Console
    public TemplateCommand()
    {
        //Register Command | Command keyword | Function to call | Description for "help" command
        DevConsole.AddCommand("testcommand", TemplateCommand, "Example Command for learning Zacksly Console");
    }

    //Function containing logic for command
    public void TemplateCommand(string[] args){
        
    }

}
