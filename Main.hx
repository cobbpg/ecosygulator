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
import flash.display.MovieClip;
import flash.events.Event;

class Main extends MovieClip
{

  private var scene:Scene;

  public function new()
  {
    super();
    Lib.current.addChild(this);
    scene = new Scene();
    addChild(scene);
    scene.init();
    addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
  }

  public function onEnterFrame(e:Event)
  {
    scene.update();
  }

  public static function main()
  {
    new Main();
  }

}
