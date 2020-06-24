using Godot;
using ConsoleCommands;
using DeveloperConsole;

public class ShowFPSCommand : ConsoleCommand
{
    private Label fpsCounter = new Label();
    private static System.Threading.Timer timer;
    public ShowFPSCommand()
    {
        DevConsole.AddCommand("show_fps", ShowFPS, "Show frames per second counter");
        DevConsole.AddCommand("hide_fps", HideFPS, "Hide frames per second counter");
        DevConsole.AddCommand("toggle_fps", ToggleFPS, "Toggle frames per second counter");
        Init();
    }

    async void Init(){
        
        if (DevConsole.SceneSpace == null)
        {
            timer = new System.Threading.Timer(func => Init(), null, 100, 0);
            return;
        }
        DevConsole.Root.AddChild(this);
        AddChild(fpsCounter);
        fpsCounter.Visible = false;

        timer.Dispose();
    }
    
    public void ShowFPS(string[] args){
        fpsCounter.Visible = true;
    }
    public void HideFPS(string[] args){
        fpsCounter.Visible = false;
    }
    public void ToggleFPS(string[] args){
        fpsCounter.Visible = !fpsCounter.Visible;
    }

    public override void _Process(float delta){
        fpsCounter.Text = $"FPS: {Engine.GetFramesPerSecond()}";
    }



}
