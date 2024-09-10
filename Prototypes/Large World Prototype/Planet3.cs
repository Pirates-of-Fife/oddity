using Godot;
using System;
using System.Threading;
using System.Threading.Tasks;

public partial class Planet3 : Node3D
{
	[Export]
	public Node3D player {  get; set; }

	[Export]
	public string PlanetPath { get; set; }

	private bool PlanetLoaded { get; set; } = true;

	private float LoadDistance { get; set; } = 10000000.0f;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override async void _Process(double delta)
	{
		float distance = (GlobalPosition - player.GlobalPosition).Length();

// GD.Print("Distance: " + distance);

		if (distance > LoadDistance)
		{
			if (PlanetLoaded == true)
			{
				foreach (Node3D node in GetChildren())
				{
					RemoveChild(node);
				}

				GD.Print("Unloaded " + PlanetPath);

				PlanetLoaded = false;
			}
		}
		else
		{
			if (PlanetLoaded == true)
				return;

            PlanetLoaded = true;


            Task<PackedScene> task = Task.Run(() =>
			{
				GD.Print("Loading Planet " + PlanetPath);
				return GD.Load<PackedScene>(PlanetPath);
			});

			var planet = await task;

			var planet_scene = planet.Instantiate();

			AddChild(planet_scene);
			GD.Print("Planet added to Scene " + PlanetPath);

		}

	}
}
