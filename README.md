# FlappyBunny

A small one-button side-scroller made in 2020, mainly to learn how to work with
the Godot engine and how to create a game. It was recently migrated to the
Godot 4.7 project format, but the gameplay and art are unchanged from the
original learning project.

## Creation

https://github.com/user-attachments/assets/07567754-75b8-479b-a621-169f1005db8e

## Gameplay

Before each run, pick one of the two characters:

- **Bunny**: available from the start
- **Bird**: unlocked once your best score reaches 37

Then fly for as far as you can. The course is not just pipes: the gaps get
narrower as you progress, walls of fire replace the pipes further in, and on
some obstacles the flames keep growing while you approach. Coins are scattered
along the way, and a rival bird joins the course mid-run: collide with it and
you go down. The run ends when you hit an obstacle, the rival, or the ground.

Your best score is saved between runs.

## Controls

Both actions use the same button (**Space**, **click** or **tap**), and the same
press also selects your character on the menu:

- **Tap**: flap
- **Hold**: sprint forward at increasing speed

## Running the project

1. Install [Godot 4.7](https://godotengine.org/download).
2. Clone this repository.
3. Open `project.godot` in the Godot editor and press **F5** (Run Project).

The main scene (`stages/game_stage.tscn`) shows the character selection menu
and starts the run from there.

## Project layout

```
scenes/    Reusable game scenes (characters, pipes, fire walls, coins, spawners, ...)
scripts/   GDScript logic (autoloads: Game, Utils, StageManager)
sprites/   Pixel art
sounds/    Sound effects
stages/    Main stage
```
