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
  private var creatures:List<Creature>;
  private var populations:Array<Float>;
  private var maxPopulations:Array<Float>;
  private var prevPopulations:Array<Float>;
  private var interactions:Int;

  private var prevTime:Int;

  public function new()
  {
    super();
    prevTime = Lib.getTimer();
    ecosystem = new Ecosystem("0,33cc22,10,0;3,ffffff,0,-2,0;5,000000,1,-1,1");
    populations = [300.0,70.0,5.0];
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

  // Utility function to instantiate a new creature
  private function newCreature(species:Int)
  {
    return new Creature(species, ecosystem.speedOf(species), ecosystem.colourOf(species));
  }

  public function init()
  {
    creatures = new List();
    for (species in 0...populations.length)
      {
	// Create populations
	for (i in 0...Std.int(populations[species]))
	  {
	    var c = newCreature(species);
	    addChild(c);
	    creatures.add(c);
	    c.init();
	  }

	// Draw ecosystem blobs
	var coords = speciesCoordinates(species);
	graphics.beginFill(ecosystem.colourOf(species));
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
    var curTime = Lib.getTimer();
    var dt = (curTime - prevTime) * 0.001;

    // Move creature blobs
    for (c in creatures)
      {
	c.update(dt);
      }

    // Update population trend plots
    for (species in 0...populations.length)
      {
	graphics.lineStyle(1, ecosystem.colourOf(species));
	graphics.moveTo(prevTime * 0.001, stage.stageHeight * (1 - 0.25 * prevPopulations[species] / maxPopulations[species]));
	graphics.lineTo(curTime * 0.001, stage.stageHeight * (1 - 0.25 * populations[species] / maxPopulations[species]));
      }

    // Save time and populations for the next round
    prevTime = curTime;
    prevPopulations = populations.copy();
  }

  // Kill a specific creature
  public function kill(creature:Creature)
  {
    populations[creature.species] = Math.max(0, populations[creature.species] - 1);
    creatures.remove(creature);
    removeChild(creature);
    interactions++;
  }

}
