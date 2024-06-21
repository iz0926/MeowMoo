# Meow Moo :D

June 2022<br>
Grew up playing 2-player Flash games, so I decided to create this! Built using Java and Processing IDE
Demo Here: https://youtu.be/xZPoyh0fBHc

# Game Features:
~ 2 Player game <br>
~ Interact dynamically with the environment, such as collecting objects, dodging obstacles, or interacting with various in-game elements<br>
~ Every round, there is one player that is "it" (displayed on dashboard)<br>
~ Eating the poisons lowers speed, eating the peaches gains speed for the respective player<br>
~ Peaches and poisons regenerate after a certain amount is eaten<br>
~ Animated characters (character image frames reflect direction of movement, player's foot moves at a constant frame rate) <br>
~ A scoring system based on the number of successive rounds won<br>
~ A dashboard displaying score, speed, the player that is 'it'<br>
~ Sound effects when you collect the gold coin and tag the other player<br>
~ Gain invisibility for a few seconds by collecting the gold coin! (Player won't be able to collect or collide with the obstacles, peaches, or poisons when they are invisible)<br>
~ Use crates as shields from the fighter cat and man (but not the opponent!)<br>
~ The fighter cat and man have varying velocities and starting positions for each round<br>
~ Colliding with the fighter cat and man nudges the player toward the center of the screen<br>
~ Hitting the wall restarts the round<br>

What I want to add: <br>
~ Adding AI smart characters (by implementing A* algorithm where the graph cells are converted to nodes and they're marked as walkable as the players traverse the map)<br>
~ Enhancing UI by adding background and customized & animated pixel characters<br>
~ Adding a pause and sound toggle button on the dashboard <br>

# Instructions for Setting Up to Play
Step 1: Install Processing<br>
Download Processing: Visit the Processing website and download the appropriate version for your operating system (Windows, macOS, Linux).<br>
Install Processing: Follow the instructions specific to your OS to install Processing on your machine.<br>

Step 2: Download the Game<br>
click on the Code button and select Download ZIP, or clone the repository using Git:<br>

bash<br>
`git clone (https://github.com/iz0926/MeowMoo.git)` <br>
Extract the Files: If you downloaded the ZIP file, extract it to a location of your choice.<br>

Step 3: Open and Run the Game<br>
Navigate to the folder you just downloaded<br>
Open the .pde file `MeowMoo.pde` <br>
Press the play button in IDE<br>
