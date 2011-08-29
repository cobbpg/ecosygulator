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
import flash.events.MouseEvent;

class Main extends MovieClip
{

  /*
    Example for a balanced system:

    ecosystem = new Ecosystem("0,33cc22,0.01,0;3,ffffff,-0.2,0.001,0;5,000000,-0.03,0.003,1");
    startPop = [200.0,20.0,5.0];
    maxPop = [500.0,80.0,30.0];
  */

  public static inline var levels =
    [{ ecosystem: "0,33cc22,0.02,0;3,ffffff,-0.015,0.0025,0;5,000000,-0.02,0.002,1",
       startPop: [20.0,20.0,10.0], maxPop: [50.0,50.0,50.0] },
     { ecosystem: "0,33cc22,0.04,0;3,ffffff,-0.015,0.0035,0;5,000000,-0.02,0.002,1;5,cc2200,-0.02,0.0015,0,1",
       startPop: [20.0,20.0,10.0,10.0], maxPop: [50.0,50.0,50.0,50.0] }
     ];
  private var scene:Scene;
  private var currentLevel:Int;

  public function new()
  {
    super();
    currentLevel = 0;
    Lib.current.addChild(this);

    // Dummy background needed to catch clicks
    graphics.beginFill(0xcccccc);
    graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
    graphics.endFill();

    startLevel(currentLevel);
    addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
  }

  private function waitForClick()
  {
    mouseChildren = false;
    addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
  }

  private function startLevel(level:Int)
  {
    if (scene != null) { removeChild(scene); }
    scene = new Scene(levels[levels.length <= level ? levels.length - 1 : level]);
    addChild(scene);
    scene.init(level, onVictory, onDefeat);
  }

  public function onEnterFrame(e:Event)
  {
    scene.update();
  }

  public function onVictory()
  {
    currentLevel++;
    waitForClick();
  }

  public function onDefeat()
  {
    waitForClick();
  }

  public function onClick(e:Event)
  {
    removeEventListener(MouseEvent.CLICK, onClick, false);
    mouseChildren = true;
    startLevel(currentLevel);
  }

  public static function main()
  {
    new Main();
  }

}
