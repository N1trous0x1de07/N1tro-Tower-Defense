# TowerDefenseTemplate

In this project there were a lot of different little things added all at different times.
#1 the path generation:
The path generation in this game is completely random going from left to right using the tiles it is given. It's a very interesting thing to implement into a tower defense game and I think it fits in really nicely. There's also the ability for the generation to include loops which makes it even better because the pathway gets much longer. I think if I had the chance to do it again I probably wouldn't though because it took quite a long time to actually implement.

#2 the cannons/towers:
In this game there is only one tower/cannon. The cannon fires modeled cannon balls that have an adjustable fire rate through the Turret1 Node in the turret_1 scene. The detection for the location of enemies isn't perfect, but it definitely works and it can keep up with a pretty large number of enemies especially when you have like 3 or 4 cannon across the path.

#3 State Sheets:
With this game there is a godot extension in use called State Sheets. This is a plugin that gives easy access to a sort of transition system. You can set something to one state and have it perform actions before transitioning into a different one to do very different things without the hassle of trying to figure that out completely manually. This is used for the enemies to spawn and transition to movement or for them to go from moving to dead or despawning. This is also used for the turrets to determine when they need to be searching for enemies or tracking or shooting. There are other uses in this project for this feature, but you get the point. I think this was overall a great thing to add to the project and I would definitely do it again.

#4 the enemies:
In this game there are currently 3 types of enemies. There are the basic enemies which are green and have 100 health as well as 1.0 movement speed. The basic enemy is only worth 15 dollars if you kill it. There is also the power enemy which has 300 health, but moves at 0.5 movement speed. These enemies have a red spaceship with a turret on it, but the turret doesn't work. These are worth 60 dollars if you kill them. Finally, there are the speed enemies which move at 4.0 movement speed and have 150 health. These enemies are worth 35 dollars and have a yellow spaceship. These enemies come in waves and may or may not be mixed together. Overall, I think the different enemy types are interesting and if I had the time I'd make even more.

#5 the money system:
In this game there is a money system where you will need at least 60 dollars to place a turret down. The only way to gain money is by killing enemies. I think this is a simple enough system that adds a little bit more fun to the game. This could definitely be improved upon I think, and if it were to be improved upon I think it would be much more in depth and interesting.

#6 The artistic touches:
In this game there are health bars, interactable UI buttons, there's a lighting system with shadows and post processing, along with sounds and effects when enemies die. The post processing has been tweaked very slightly so that the game looks a bit more vibrant. The lighting creates shadows on all the objects in the game, but it isnt too much. The UI buttons work perfectly and are even coded to gray out when you can't use them. The health bars even change colors based on the enemy's health value.

#7 The wave system
Waves do not automatically start in this game. There is a button in the top left of the screen that you have to click in order to start each wave. This gives players a moment to think and strategize before anything even happens. In my opinion this is a must have for tower defense games and it makes things quite a bit more fun. There are already 4 waves in the game, but more can be added in a couple button presses.
 
