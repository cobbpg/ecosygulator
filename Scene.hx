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

  private var creatures:List<Creature>;

  private var prevTime:Int;

  public function new()
  {
    super();
    prevTime = Lib.getTimer();
  }

  public function init()
  {
    creatures = new List();
    for (i in 0...50)
      {
	var c = new Creature(i % 3, 10);
	addChild(c);
	creatures.add(c);
	c.init();
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
