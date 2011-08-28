/*
 * Ecosygulator - Experimental Gameplay August 2011 (Offspring) entry
 * Copyright (C) 2011, Patai Gergely
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package;

import flash.Lib;
import flash.display.Sprite;

class Scene extends Sprite
{

  private var ecosystem:Ecosystem;
  private var creatures:Array<List<Creature>>;
  private var populations:Array<Float>;
  private var maxPopulations:Array<Float>;
  private var prevPopulations:Array<Float>;
  private var interactions:Int;

  private var prevTime:Int;

  public function new()
  {
    super();
    prevTime = Lib.getTimer() * 10;
    ecosystem = new Ecosystem("0,33cc22,0.01,0;3,ffffff,-0.2,0.001,0;5,000000,-0.03,0.004,1");
    populations = [200.0,20.0,2.0];
    prevPopulations = populations.copy();
    maxPopulations = [1000.0,200.0,20.0];
    interactions = 0;
  }

  // Coordinates of a species blob in the ecosystem diagram
  private function speciesCoordinates(species:Int)
  {
    var angle = 2 * species * Math.PI / populations.length;
    var x = stage.stageWidth * (0.9 + 0.05 * Math.sin(angle));
    var y = stage.stageWidth * (0.1 + 0.05 * Math.cos(angle));
    return {x: x, y: y};
  }

  public function init()
  {
    creatures = [];
    for (species in 0...populations.length)
      {
	creatures.push(new List());

	// Create populations
	for (i in 0...Std.int(populations[species])) { create(species); }

	// Draw ecosystem blobs
	var coords = speciesCoordinates(species);
	graphics.beginFill(ecosystem.species(species).colour);
	graphics.drawEllipse(coords.x - 5, coords.y - 5, 10, 10);
	graphics.endFill();
      }

    // Draw ecosystem connections
    for (i in 0...populations.length)
      {
	for (j in 0...populations.length)
	  {
	    if (ecosystem.preyOf(i, j))
	      {
		var predator = speciesCoordinates(i);
		var prey = speciesCoordinates(j);
		var dx = prey.x - predator.x;
		var dy = prey.y - predator.y;
		var d = 8 / Math.sqrt(dx * dx + dy * dy);
		graphics.beginFill(0x333333);
		graphics.moveTo(prey.x - d * dx, prey.y - d * dy);
		graphics.lineTo(predator.x + d * dx - 0.3 * d * dy, predator.y + d * dy + 0.3 * d * dx);
		graphics.lineTo(predator.x + d * dx + 0.3 * d * dy, predator.y + d * dy - 0.3 * d * dx);
		graphics.endFill();
	      }
	  }
      }
  }

  public function update()
  {
    // Calculate the duration of the current frame
    var curTime = Lib.getTimer() * 10;
    var dt = (curTime - prevTime) * 0.001;

    // Move creature blobs
    for (cs in creatures) { for (c in cs) { c.update(dt); } }

    // Population dynamics
    var p = populations.copy();
    for (i in 0...populations.length)
      {
	var s = ecosystem.species(i);

	// Natural reproduction (negative for non-plants)
	var d = s.reproduction;

	// Effects of hunting
	for (j in 0...populations.length)
	  {
	    if (ecosystem.preyOf(i, j)) { d += s.efficiency * p[j]; }
	  }

	// Effects of being hunted
	for (j in 0...populations.length)
	  {
	    if (ecosystem.preyOf(j, i)) { d -= ecosystem.species(j).efficiency * p[j]; }
	  }
	populations[i] *= 1 + dt * d;
      }

    // Update creature list to reflect population changes
    for (species in 0...populations.length)
      {
	var d = Std.int(populations[species]) - Std.int(p[species]);
	if (d > 0)
	  {
	    for (i in 0...d) { create(species); }
	  }
	else
	  {
	    for (i in 0...-d) { removeChild(creatures[species].pop()); }
	  }
      }

    // Update population trend plots
    for (species in 0...populations.length)
      {
	graphics.lineStyle(1, ecosystem.species(species).colour);
	graphics.moveTo(prevTime * 0.001, stage.stageHeight * (1 - 0.25 * prevPopulations[species] / maxPopulations[species]));
	graphics.lineTo(curTime * 0.001, stage.stageHeight * (1 - 0.25 * populations[species] / maxPopulations[species]));
      }

    // Save time and populations for the next round
    prevTime = curTime;
    prevPopulations = populations.copy();
  }

  // Create a new creature of a given species
  private function create(species:Int)
  {
    var s = ecosystem.species(species);
    var c = new Creature(species, s.speed, s.colour);
    addChild(c);
    creatures[species].add(c);
    c.init();
  }

  // Kill a specific creature
  public function kill(creature:Creature, interactive:Bool = true)
  {
    var species = creature.species;
    populations[species] = Math.max(0, populations[species] - 1);
    creatures[species].remove(creature);
    removeChild(creature);
    interactions++;
  }

}
