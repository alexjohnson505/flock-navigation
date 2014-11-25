swarm-navigation
=====================

Goal
-------------

To develop an experimental visualization of swarm behaviour. 
This passive visualization will provide a visually engaging 
environment to demonstrate swarm (flocking) behaviour. This 
project was inspired by [Craig Reynold](http://www.red3d.com/cwr/)’s work in creating 
algorithms to emulate the navigational behaviour of creatures 
such as birds and fish.  While movement appears random, every 
action is determined by the surroundings. The following quote 
is from Craig Reynold’s online writings on boids:

> “A significant property of life-like behavior is unpredictability over moderate time scales...
> It would be all but impossible to predict which direction they will be moving (say) five minutes
> later... This property is unique to complex systems and contrasts with both chaotic
> behavior… and ordered … behavior. This fits with Langton's 1990 observation that life-like
> phenomena exist poised at the edge of chaos.” ([source](http://www.red3d.com/cwr/boids/))

Demo:
-------------
Online: [alexjohnson.io/swarm-navigation](http://alexjohnson.io/swarm-navigation)

Running:
-------------

> Running swarm-navigation on your computer

Load src/index.html from a web server. To run locally, I 
recommend installing MAMP, and pointing the root directory 
to swarm-navigation/src. This sets up a local, development 
Apache server. You can then load the project from locahost:8080.

User Interaction:
-------------

> How to Play

Swarms navigate the environment. When a fish
collects a food, they reproduce, and their health
is refreshed. When a fish goes too long without
eating, they will fade away and die (yellow ripple).

Click on the screen to place a new food item
at the center of your cursor.

Hold 'W' & 'S' to change the currently selected
swarm. Notice how a white box is drawn around their
color in the top left of the screen.

TO-DO:
-------------

> Upcoming Features:

"Improvements"
- Swarms should respect/avoid collisions with other swarms
- Optimize Code: Section off boids to avoid unnecessary collision detection


Boids
-------------

This project is inspired by [Craig Reynolds](http://www.red3d.com/cwr/index.html)' research in modeling flocking behaviour. Reynolds was influenced by the animal motions of flocks such as birds, or fish schools. Reynolds referred to his generic [simulated flocking creatures as Boids](http://www.red3d.com/cwr/boids/).

To quote Craig Reynolds, 

> In 1986 I made a computer model of coordinated animal 
> motion such as bird flocks and fish schools. It was based 
> on three dimensional computational geometry of the sort 
> normally used in computer animation or computer aided design.
> I called the generic simulated flocking creatures boids. 
> The basic flocking model consists of three simple [steering behaviors](http://www.red3d.com/cwr/steer/) 
> which describe how an individual boid maneuvers based on 
> the positions and velocities its nearby flockmates ([source](http://www.red3d.com/cwr/boids/)).

Boids operate on 3 main principles:

 - **Separation**: Avoid crowding flockmates.
 - **Alignment**: Aim for average heading of flockmates.
 - **Cohesion**: Aim for average position of flockmates.

Special Thanks:
-------------

Inspiration and code from ss5_7_flock, and in class example program, implementing Craig Reynold's classic [autonomous steering behaviors](http://www.red3d.com/cwr). Original code from '[THE NATURE OF CODE](http://natureofcode.com)' by Daniel Shiffman