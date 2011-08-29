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
import flash.events.Event;
import flash.events.MouseEvent;

class Creature extends Sprite
{

  private static inline var radius:Float = 15;

  private static var fieldWidth:Float = 0;
  private static var fieldHeight:Float = 0;

  public var species(default, null):Int;
  private var speed:Float;
  private var colour:Int;

  private var px:Float;
  private var py:Float;
  private var vx:Float;
  private var vy:Float;

  public function new(species:Int, speed:Float, colour:Int)
  {
    super();
    this.species = species;
    this.speed = speed;
    this.colour = colour;
  }

  public function init() {
    if (fieldWidth == 0)
      {
	fieldWidth = stage.stageWidth * 0.8;
	fieldHeight = stage.stageHeight * 0.75;
      }

    px = Math.random() * (fieldWidth - radius * 2) + radius;
    py = Math.random() * (fieldHeight - radius * 2) + radius;

    var a = Math.random() * 2 * Math.PI;
    vx = Math.cos(a) * speed;
    vy = Math.sin(a) * speed;

    x = px;
    y = py;

    graphics.beginFill(colour);
    graphics.drawEllipse(-radius, -radius, radius * 2, radius * 2);
    graphics.endFill();

    addEventListener(MouseEvent.CLICK, kill, false, 0, true);
  }

  public function update(dt:Float)
  {
    px += vx * dt;
    py += vy * dt;

    if ((px < radius && vx < 0) || (px > fieldWidth - radius && vx > 0))
      {
	vx *= -1;
      }
    if ((py < radius && vy < 0) || (py > fieldHeight - radius && vy > 0))
      {
	vy *= -1;
      }

    x = px;
    y = py;
  }

  public function kill(event:Event)
  {
    cast(parent, Scene).kill(this);
  }

}
