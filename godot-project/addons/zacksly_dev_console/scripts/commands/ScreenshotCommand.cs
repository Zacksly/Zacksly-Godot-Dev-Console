
using Godot;
using ConsoleCommands;
using DeveloperConsole;
using System;

public class ScreenShotCommand : ConsoleCommand
{
    private static System.Threading.Timer timer;
    private static System.Threading.Timer CountdownTimer;
    private int secondsRemaining = 0;
    public ScreenShotCommand()
    {
        DevConsole.AddCommand("screenshot", TakeScreenshot, "Take a screenshot [optional parameter, delay]");
    }

    public void TakeScreenshot(string[] args){
        //If delay is specified
        if (args.Length == 1)
        {
            int Length = (int) Math.Round( float.Parse( args[0] ) * 1000 );
            secondsRemaining = (int) Math.Round( float.Parse( args[0] )); 
            timer = new System.Threading.Timer(func => TimerCompleted(), null, Length, 0);
            CountdownTimer = new System.Threading.Timer(func => Tick(), null, 0, 1000);
            
        }
        else{
            Capture();
        }
        
    }


    private void Tick(){
        if(secondsRemaining >= 0){
            secondsRemaining -= 1;
            DevConsole.LogWarning($"Screen shot in: {secondsRemaining+1}");
        }
    }

    private void TimerCompleted(){
        timer.Dispose();
        CountdownTimer.Dispose();
        Capture();
    }

    private void Capture(){
        
        Image img = DevConsole.SceneSpace.GetViewport().GetTexture().GetData();
        img.FlipY();
        var fileName = $"Screenshot_{DateTime.Now}";
        //Formatting
        fileName = fileName.Replace("/","-");
        fileName = fileName.Replace(":","-");
        fileName = fileName.Replace(" ","_");
        //Save files
        img.SavePng($"user://{fileName}.png");

        string filepath =  OS.GetUserDataDir() + "/" + fileName + ".png";
        GD.Print(filepath);
        DevConsole.LogSuccess($"Screenshot Taken [url]{filepath}[/url]");
    }


}
