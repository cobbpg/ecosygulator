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

import flash.display.Sprite;

class Creature extends Sprite
{

  private static inline var radius:Float = 5;

  private var speed:Float;
  private var colour:Int;

  private var px:Float;
  private var py:Float;
  private var vx:Float;
  private var vy:Float;

  public function new(speed:Float, colour:Int)
  {
    super();
    this.speed = speed;
    this.colour = colour;
  }

  public function init() {
    px = Math.random() * stage.stageWidth;
    py = Math.random() * stage.stageHeight;

    var a = Math.random() * 2 * Math.PI;
    vx = Math.cos(a) * speed;
    vy = Math.sin(a) * speed;

    graphics.beginFill(colour);
    graphics.drawEllipse(-radius, -radius, radius * 2, radius * 2);
    graphics.endFill();
  }

  public function update(dt:Float)
  {
    px += vx * dt;
    py += vy * dt;

    if ((px < radius && vx < 0) || (px > stage.stageWidth - radius && vx > 0))
      {
	vx *= -1;
      }
    if ((py < radius && vy < 0) || (py > stage.stageHeight - radius && vy > 0))
      {
	vy *= -1;
      }

    x = px;
    y = py;
  }

}
