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

  private var prevTime:Int;

  public function new()
  {
    super();
    prevTime = Lib.getTimer();
    ecosystem = new Ecosystem("0,33cc22,10,0;3,ffffff,0,-2,1;5,000000,1,-1,1");
  }

  public function init()
  {
    var populations = [1000,50,5];
    creatures = new List();
    for (n in 0...populations.length)
      {
	for (i in 0...populations[n])
	  {
	    var c = new Creature(ecosystem.speedOf(n), ecosystem.colourOf(n));
	    addChild(c);
	    creatures.add(c);
	    c.init();
	  }
      }
  }

  public function update()
  {
    var curTime = Lib.getTimer();
    var dt = (curTime - prevTime) * 0.001;
    prevTime = curTime;

    for (c in creatures)
      {
	c.update(dt);
      }
  }

}
