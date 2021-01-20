# Plethora-Ore-Tracers
Draws tracers to ores with Plethora and CC:Tweaked. The tracers have customizable colors and the selected ores can be chosen.

IF YOU HAVE COLOR BLINDNESS, MAKE SURE TO EDIT VARIABLES "COLOR_GREEN", "COLOR_RED" AND ANY ORE-SPECIFIC COLORS YOU WANT TO CHANGE. ORE COLORS TAKE HEX + ALPHA VALUES. COLOR_GREEN AND COLOR_RED USE INTEGER VALUES FROM COMPUTERCRAFT AND CAN BE FOUND [HERE](http://computercraft.info/wiki/Colors_(API))


## Requirements
Requires Plethora and CC:Tweaked.

The required modules are Neural Interface, Overlay Glasses and Block Scanner. Without these, it simply cannot function.

## Examples
Here is a YouTube video demonstrating how it works. (Click the image to be redirected)
[![YouTube video demonstration](https://img.youtube.com/vi/ljtvr_jARDk/0.jpg)](https://www.youtube.com/watch?v=ljtvr_jARDk)


The tracers have different colours depending on what ore it's targeting.
![Different Tracer Colors](tracer_colors.png)


It has an interface that lets you choose what ores you want to target.
![Unchecked Interface](tracers_interface_unchecked.png)


By clicking on an item you can select it. Clicking said item again unselects it
![Unchecked Interface](tracers_interface_checked.png)

## Usage
You can download it from here, if you're using it on your local machine, but the easiest way is to download it through pastebin. Type these into your neural connector:
```
pastebin get xLHQDZTd startup.lua
reboot
```

After that you are greeted with the interface shown above. After that, simply check the ores you want to find and press "Start Application" for it to start finding ores for you. Good luck!

### Bugs
No bugs have been found as of yet, but if you do find one, please leave it as an issue here on GitHub so I can get to fixing it. Thank you
