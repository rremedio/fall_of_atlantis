# Fall of Atlantis
A Ruby/Gosu/Chipmunk "remake" of the original Atari 2600 Atlantis.

#Installation and usage
You need Ruby (tested in v2.0) and the gems Gosu and Chipmunk installed. Then run "ruby main.rb" to launch the game. Tested only in Windows 10 64bits.

If you are in Windows XP or newer you can also download executable files -> https://s3-sa-east-1.amazonaws.com/zygrunt/fall_of_atlantis.zip

# Controls
## Classic version
A, S, or D - Shoot
Hold left or right while shooting to shoot from the left or right cannons

## Alternative version
A - Left cannon
S - Central cannon
D - Right cannon

# Gameplay
The central cannon protects Atlantis from attacks. The alien ships need to destroy it to be able to hit the other buildings. Once all the buildings are destroyed, you lose the game. A lot of liberties were taken with the gameplay to fit my tastes, inluding the enemy spawing rate (enemies are deployed at a fixed rate instead of deploying them in slots like the original game), the point system, the enemies speed, the espacing, etc. I also added an alternative control method since we are not restricted to one fire button anymore.

For every 10.000 points you make, you will be able to have your main cannon plus a random building restored between alien waves.

# Plot
The aliens are attacking Atlantis. You control the last defenses keeping it from being destroyed.

# To-do list
- Refactor all the code;
- Add the Cosmic Ark ending;
- Add a space stage;
- Use custom graphics;
- Add more sounds;
- Add a high scores board;
- Add a proper title screen;
- Add release packages so players don't need Ruby and the libraries instaled?
- Rename the game?

The original Atlantis, by Imagic, was the 9th best selling game in the Atari 2600 history.

# Project discussion
https://www.libgosu.org/cgi-bin/mwf/topic_show.pl?tid=1300

# Thanks!
Thanks to Julian Raschke for the Gosu game development library, Scott Lembcke, Beoran, John Mair (banisterfiend) and Shawn Anderson (shawn42) for the Chipmunk Ruby bindings and of course Imagic for Atlantis!
