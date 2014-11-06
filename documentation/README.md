swarm-navigation
===

Craig Reynolds
---

This project is inspired by [Craig Reynolds](http://www.red3d.com/cwr/index.html)' research in modeling flocking behaviour. Reynolds was influenced by the animal motions of flocks such as birds, or fish schools. Reynolds referred to his generic [simulated flocking creatures as Boids](http://www.red3d.com/cwr/boids/).

Boids
---

To quote Craig Reynolds, 

> In 1986 I made a computer model of coordinated animal 
> motion such as bird flocks and fish schools. It was based 
> on three dimensional computational geometry of the sort 
> normally used in computer animation or computer aided design.
> I called the generic simulated flocking creatures boids. 
> The basic flocking model consists of three simple [steering behaviors](http://www.red3d.com/cwr/steer/) 
> which describe how an individual boid maneuvers based on 
> the positions and velocities its nearby flockmates ([source](http://www.red3d.com/cwr/boids/)).

![Separation](img/separation.gif)
**Separation**: Avoid crowding flockmates.

![Alignment](img/alignment.gif)
**Alignment**: Aim for average heading of flockmates.

![Cohesion](img/cohesion.gif)
**Cohesion**: Aim for average position of flockmates.


The Nature of Code
---

Resources
---