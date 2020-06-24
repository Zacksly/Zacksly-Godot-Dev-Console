using Godot;
using System;
using DeveloperConsole;

public class DevConsoleUI : Node {
	private string[] zackslyConsoleInfo = {"","[center]Zacksly DevConsole", "Version 1.0 Beta", "[color=#2ec057]https://github.com/Zacksly[/color][/center]"};
	private string DevConsolePath = "res://DevConsole/";
	private enum Themes{
		Dark,
		Light
	}

	[Export]
	private Themes consoleTheme;

	private int logHistoryLength = 20;
	[Export]
	public int LogHistoryLength{
		set{
			DevConsole.logSize = value;
			logHistoryLength = value;
		}
		get{
			return logHistoryLength;
		}
	}

	public bool unlockMouse = true;

	bool didShow = false;

	public Control viewContainer; //Container for console view, should be a child of this GameObject
	public RichTextLabel logTextArea;
	private float TextAreaMarginTop;
	public LineEdit commandInput;

	public ScrollContainer scrollContainer;

	public override void _Ready() {

		if(GetTree().CurrentScene != this){
			GetParent().CallDeferred("remove_child", this);
			GetTree().CurrentScene.CallDeferred("add_child", this);
		}

		viewContainer = GetNode("MainContainer") as Control;
		logTextArea = GetNode<RichTextLabel>("MainContainer/DevPanel/ScrollContainer/Log");
		commandInput = GetNode<LineEdit>("MainContainer/DevPanel/CommandInput");
		scrollContainer = GetNode<ScrollContainer>("MainContainer/DevPanel/ScrollContainer");

		TextAreaMarginTop = logTextArea.MarginTop;
		logTextArea.SelectionEnabled = true;

		toggleVisibility();
		DevConsole.consoleUI = this;
		DevConsole.SceneSpace = GetTree().CurrentScene;
		DevConsole.Root = GetTree().Root;
		UpdateLog(zackslyConsoleInfo);

		//Set theme
		switch(consoleTheme){
			case Themes.Dark:
				SetTheme(ResourceLoader.Load(DevConsolePath + "Themes/DarkTheme.tres") as Theme);
			break;
			case Themes.Light:
				SetTheme(ResourceLoader.Load(DevConsolePath + "Themes/LightTheme.tres") as Theme);
			break;
		}
	}
	public void SetTheme(Theme theme){
		viewContainer.Theme = theme;
		commandInput.Theme = theme;
		logTextArea.Theme = theme;
		scrollContainer.Theme = theme;
	}
	
	public override void _Input(InputEvent inputEvent)
	{
		//If key is pressed and it is not a repeated input
		if (inputEvent is InputEventKey keyEvent) 
		{
			// [Enter] : Run Command
			if ((KeyList)keyEvent.Scancode == KeyList.Enter && !keyEvent.Echo && keyEvent.Pressed)
			{
				SendCommand();
			}
			// [`] : Show/hide the console
			if ((KeyList)keyEvent.Scancode == KeyList.Quoteleft && !keyEvent.Echo && !keyEvent.Pressed)
			{
				toggleVisibility();
			}
		}
	}

	public void Log(string text){
		DevConsole.Log($"Logger: {text}");
	}

	public void Log(string text, Exception ex){
		DevConsole.Log($"Error: {ex.GetType().Name} Message: {text}");
	}

	void toggleVisibility() {
		viewContainer.Visible = !viewContainer.Visible;
		//If we're now visible focus on the line text field
		if(viewContainer.Visible){
			commandInput.GrabFocus();
			if(unlockMouse && Input.GetMouseMode() == Input.MouseMode.Captured){
				Input.SetMouseMode(Input.MouseMode.Visible);
			}
		}else{
			if(unlockMouse && Input.GetMouseMode() == Input.MouseMode.Visible){
				Input.SetMouseMode(Input.MouseMode.Captured);
			}
		}
		commandInput.Clear();
	}
	
	void SetVisibility(bool visible) {
		viewContainer.Visible = visible;
	}
	
	public void UpdateLog(string[] newLog) {
		if (newLog == null) {
			logTextArea.BbcodeText = "";
		}  else {
			logTextArea.BbcodeText = string.Join("\n", newLog);
		}

		Font font = logTextArea.GetFont("JetBrainsMono-Regular");
		int lines = logTextArea.GetLineCount();
		float letterHeight = font.GetHeight();
		float heightOffset = letterHeight * lines;
		float textAreaSize = logTextArea.RectSize.y;
		
		if(heightOffset < textAreaSize){
			logTextArea.RectPosition = new Vector2(logTextArea.RectPosition.x, textAreaSize-heightOffset - lines);
		}else{
			logTextArea.RectPosition = new Vector2(0,0);
		}
		
		logTextArea.ScrollToLine(logTextArea.GetLineCount() -1);
	}

	public void SendCommand() {
		DevConsole.RunCommand(commandInput.Text);
		commandInput.Text = "";
	}

	public void _on_Log_meta_clicked(string meta){
		OS.ShellOpen(meta);
	}

}