swarm-navigation
=====================

Using Processing to expiriment with flock behavior. This project aims to provide basic 'visual' delight to the user, while demonstrating semi-random flocking AI behaviour.

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

Running:
-------------

This branch (java) contains the original Java code, for use in running through the Processing 2.0 IDE. To run, download the processing IDE, and open the swarm_navigation.pde file to run. As of 10/27/14, this branch is no longer supported. Instead, please refer to the master branch, utilizing processing.js as the rendering platform.

Special Thanks:
-------------

Inspiration and code from ss5_7_flock, and in class example program, implementing Craig Reynold's classic  autonomous steering behaviors, see http://www.red3d.com/cwr Original code from 'THE NATURE OF CODE' by Daniel Shiffman, more details: http://natureofcode.com