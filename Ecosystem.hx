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

typedef Species =
  {
    var speed:Float;
    var colour:Int;
    var reproduction:Float;
    var efficiency:Float;
  }

class Ecosystem
{

  private var speciesProperties:Array<Species>;
  private var preyMatrix:Array<Array<Bool>>;
  private var stepMatrix:Array<Array<Float>>;

  public function new(description:String)
  {
    var sds = description.split(";");
    var n = sds.length;
    speciesProperties = [];
    preyMatrix = [];
    stepMatrix = [];

    for (sd in sds)
      {
	var data = sd.split(",");
	var speed = Std.parseFloat(data.shift());
	var colour = Std.parseInt("0x" + data.shift());
	var reproduction = Std.parseFloat(data.shift());
	var efficiency = Std.parseFloat(data.shift());

	var preys = [];
	for (i in 0...n) preys.push(false);
	for (p in data) preys[Std.parseInt(p)] = true;

	speciesProperties.push({speed:speed, colour:colour, reproduction:reproduction, efficiency:efficiency});
	preyMatrix.push(preys);
      }

    for (i in 0...n)
      {
	var cs = [];

	for (j in 0...n)
	  {
	    cs.push((preyOf(i, j) ? speciesProperties[i].efficiency : 0) -
		    (preyOf(j, i) ? speciesProperties[j].efficiency : 0));
	  }

	stepMatrix.push(cs);
      }
  }

  public function species(sid:Int):Species
  {
    return speciesProperties[sid];
  }

  public function preyOf(predator:Int, prey:Int):Bool
  {
    return preyMatrix[predator][prey];
  }

  public function stepCoefficient(subject:Int, partner:Int):Float
  {
    return stepMatrix[subject][partner];
  }

}
