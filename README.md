swarm-navigation
=====================

Using Processing.js to expiriment with flock behavior. This project aims to provide basic 'visual' delight to the user, while demonstrating semi-random flocking AI behaviour.

Read More:
-------------
To read more about Flocking Behaviour, please refer to this project's [Background Documentation](https://github.com/alexjohnson505/swarm-navigation/tree/master/documentation)


Demo:
-------------
Online: [alexjohnson.io/swarm-navigation](http://alexjohnson.io/swarm-navigation)

Running:
-------------

Load src/index.html from a web server. To run locally, I recommend installing MAMP, and pointing the root directory to swarm-navigation/src. This sets up a local, development Apache server. You can then load the project from locahost:8888.

User Interaction:
-------------

Swarms navigate the environment. When a fish
collects a food, they reproduce, and their health
is refreshed. When a fish goes too long without
eating, they will fade away and die (yellow ripple).

Click on the screen to place a new food item
at the center of your cursor.

Press 'W' & 'S' to change the currently selected
swarm. Notice how a white box is drawn around their
color in the top left of the screen.

Press 'D' to grant extra fish to the currently
selected swarm.

Special Thanks:
-------------

Inspiration and code from ss5_7_flock, and in class example program, implementing Craig Reynold's classic  autonomous steering behaviors, see http://www.red3d.com/cwr Original code from 'THE NATURE OF CODE' by Daniel Shiffman, more details: http://natureofcode.com