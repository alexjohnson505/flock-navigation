swarm-navigation
=====================

Goal
-------------
To develop an experimental visualization of swarm behaviour. 
This passive visualization will provide a visually engaging 
environment to demonstrate swarm (flocking) behaviour. This 
project was inspired by [Craig Reynold](http://www.red3d.com/cwr/)’s work in creating 
algorithms to emulate the navigational behaviour of creatures 
such as birds and fish. I find the concept of organic emulation 
such as swarm behaviour tobe fascinating. While movement appears 
random, every action is determined by the surroundings. The 
following quote is from Craig Reynold’s online writings on boids:

> “A significant property of life-like behavior is unpredictability over moderate time scales...It
> would be all but impossible to predict which direction they will be moving (say) five minutes
> later…. This property is unique to complex systems and contrasts with both chaotic
> behavior… and ordered … behavior. This fits with Langton's 1990 observation that life-like
> phenomena exist poised at the edge of chaos.” ([source](http://www.red3d.com/cwr/boids/))

Read More:
-------------
To read more about Flocking Behaviour, please refer to this project's [Background Documentation](https://github.com/alexjohnson505/swarm-navigation/tree/master/documentation)

Demo:
-------------
Online: [alexjohnson.io/swarm-navigation](http://alexjohnson.io/swarm-navigation)

Running:
-------------

Load src/index.html from a web server. To run locally, I 
recommend installing MAMP, and pointing the root directory 
to swarm-navigation/src. This sets up a local, development 
Apache server. You can then load the project from locahost:8888.

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

Todo
-------------

> This file exists as a reminder of
> features that I plan to implement.

"Improvements"
- Death ripple should be darker
- Swarms should avoid collisions with each other.
- Tweak Parameters via HTML/JS UI
- Section/Quadrant boids for efficiency
- Control "Alpha" fish, aim your swarm to victory

Special Thanks:
-------------

Inspiration and code from ss5_7_flock, and in class example program, implementing Craig Reynold's classic  autonomous steering behaviors, see http://www.red3d.com/cwr Original code from 'THE NATURE OF CODE' by Daniel Shiffman, more details: http://natureofcode.com