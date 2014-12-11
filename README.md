swarm-navigation
=====================

Goal
-------------

To develop an experimental visualization of swarm behaviour. 
I wanted to create an interactive visualization of flocking
behaviour. This project was inspired by [Craig Reynold](http://www.red3d.com/cwr/)’s 
work in creating algorithms to emulate the behaviour of organic
creatures. 

I wanted the experience to instill a sense of 'companionship' 
with the other creatures in your swarm. I purposefully reduced
the turn speed, and turn radius of the player fish. This 
forces the player into a movement scheme similar to his 
neighbors. As a result of slower turning radius, the player
must collect, and rely on the fish in their swarm to make a 
difference in the environment.

Demo:
-------------
Online: [alexjohnson.io/swarm-navigation](http://alexjohnson.io/swarm-navigation)

User Interaction:
-------------

> How to Play

Swarms navigate the environment. When a fish
collects a food, they reproduce, and their health
is refreshed. If a fish goes too long without
food, they will fade away and die.

You control a single fish. The Player Fish is a single, 
blue fish with a **white outline**. The other blue fish are 
your swarm. They will attempt to flock with you if you 
are close by.

Hold down the '**LEFT**' &amp; '**RIGHT**' arrow keys to
control the Player Fish's direction. Hold '**UP**' &amp; 
'**DOWN**' to make slight adjustments to acceleration. 


Inspiration
-------------

> “A significant property of life-like behavior is unpredictability over moderate time scales...
> It would be all but impossible to predict which direction they will be moving (say) five minutes
> later... This property is unique to complex systems and contrasts with both chaotic
> behavior… and ordered … behavior. This fits with Langton's 1990 observation that life-like
> phenomena exist poised at the edge of chaos.” ([source](http://www.red3d.com/cwr/boids/))

The above quote is from Craig Reynold’s online writings on boids.
This project was inspired by the chaotic, yet beautiful nature
of organic creatures. I wanted to create an interactive experience
that used this theme as a gameplay mechanic.


Running:
-------------

> Running swarm-navigation on your computer

Load src/index.html from a web server. To run locally, 
load swarm-navigation/src from an HTTP Server. On Mac
OSX, I recommend using MAMP, a desktop app for running
local Apache servers.

Boids
-------------

This project is inspired by [Craig Reynolds](http://www.red3d.com/cwr/index.html)' 
research in modeling flocking behaviour. Reynolds 
was influenced by the animal motions of flocks 
such as birds, or fish schools. Reynolds referred 
to his generic [simulated flocking creatures as Boids](http://www.red3d.com/cwr/boids/).

To quote Craig Reynolds, 

> In 1986 I made a computer model of coordinated animal 
> motion such as bird flocks and fish schools. It was based 
> on three dimensional computational geometry of the sort 
> normally used in computer animation or computer aided design.
> I called the generic simulated flocking creatures boids. 
> The basic flocking model consists of three simple [steering behaviors](http://www.red3d.com/cwr/steer/) 
> which describe how an individual boid maneuvers based on 
> the positions and velocities its nearby flockmates ([source](http://www.red3d.com/cwr/boids/)).

The 3 Principles of Boids:

 - **Separation**: Avoid crowding flockmates.
 - **Alignment**: Aim for average heading of flockmates.
 - **Cohesion**: Aim for average position of flockmates.

Special Thanks:
-------------

Inspiration and code from ss5_7_flock, and in class example program, implementing Craig Reynold's classic [autonomous steering behaviors](http://www.red3d.com/cwr). Original code from '[THE NATURE OF CODE](http://natureofcode.com)' by Daniel Shiffman