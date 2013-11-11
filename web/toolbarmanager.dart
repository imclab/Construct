library toolbarmanager;

import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'construct.dart';
import 'constructedobject.dart';

class ToolBarManager {
  CanvasRenderingContext2D cvs;
  List<Tool> objectTools;
  List<Tool> constraintTools;
  Tool activeTool;
  
  static const num buttonDim = 30;
  static const num buttonSpacing = 5;
  
  ToolBarManager(this.cvs){
    // Register mouse event handlers
    this.cvs.canvas.addEventListener('mousedown', this.click);
    
    // Paint the background gray
    this.cvs.fillStyle = '#222222';
    this.cvs.fillRect(0, 0, this.cvs.canvas.width, this.cvs.canvas.height);
    
    // Set up the toolsets
    this.objectTools = new List();
    (new PointTool()).register(this);
    this.constraintTools = new List();
    
    // Draw the initial toolbar
    this.draw();
  }
  
  void draw() {
    num vpos = buttonSpacing;
    for (var t in objectTools) {
      t.drawButton(buttonSpacing, vpos, buttonDim, buttonDim);
      vpos += buttonDim + buttonSpacing;
    }
    drawSpacer(buttonSpacing, vpos, buttonDim, buttonSpacing);
    vpos += buttonSpacing + buttonSpacing;
    for (var t in constraintTools) {
      t.drawButton(buttonSpacing, vpos, buttonDim, buttonSpacing);
      vpos += buttonDim + buttonSpacing;
    }
  }
  
  void drawSpacer(num x, num y, num width, num height) {
    cvs.strokeStyle = '#444444';
    cvs.lineWidth = 1;
    cvs.beginPath();
    cvs.moveTo(x, y);
    cvs.lineTo(x+width, y);
    cvs.closePath();
    cvs.stroke();
    cvs.beginPath();
    cvs.moveTo(x, y+height);
    cvs.lineTo(x+width, y+height);
    cvs.closePath();
    cvs.stroke();
  }
  
  void click(MouseEvent event) {
    setClickedToolActive(event.offset);
    
    if (activeTool != null)
      activeTool.start();
  }
  
  void setClickedToolActive(Point mousePt) {
    // Check horizontal bounds
    if ((buttonSpacing <= mousePt.x) && (mousePt.x <= buttonSpacing + buttonDim)) {
      num relY = mousePt.y - 5;
      // Check object tools
      for (int i=0; i<objectTools.length; i++) {
        if (relY < 0) {
          // Clicked in the spacer
          return;
        } else if (relY <= buttonDim) {
          // Clicked on button i
          activeTool = objectTools[i];
          return;
        } else {
          // Clicked beyond current button
          relY -= buttonDim + buttonSpacing;
        }
      }
      // Skip over divider
      relY -= buttonSpacing * 2;
      // Check constraint tools
      for (int i=0; i<constraintTools.length; i++) {
        if (relY < 0) {
          // Clicked in the spacer
          return;
        } else if (relY <= buttonDim) {
          // Clicked on button i
          activeTool = constraintTools[i];
          return;
        } else {
          // Clicked beyond current button
          relY -= buttonDim + buttonSpacing;
        }
      }
      // Didn't click on anything
    }
  }
  
  void deactivateTool() {
    activeTool = null;
  }
}

abstract class Tool {
  // Constructor
  Tool();
  // Called to attach the tool to the toolbar manager
  void register(ToolBarManager tb);
  
  // Called to draw the glyph for the button in the toolbar
  void drawButton(num x, num y, num width, num height);
  
  // Called when the user clicks on the toolbar button
  void start();
  // Called when the user clicks in the workspace
  void click();
}

class PointTool implements Tool {
  CanvasRenderingContext2D cvs;
  
  PointTool() {}
  void register(ToolBarManager tb) {
    cvs = tb.cvs;
    tb.objectTools.add(this);
  }
  
  void drawButton(num x, num y, num width, num height) {
    cvs.strokeStyle = '#BBBBBB';
    cvs.fillStyle = '#BBBBBB';
    num cx = x + (width/2);
    num cy = y + (height/2);
    cvs.beginPath();
    cvs.arc(cx, cy, 2.5, 0, 2*PI);
    cvs.closePath();
    cvs.fill();
  }
  
  void start() {
    // Create an unconstrained point object
    PointObject spawn = new PointObject();
    gProgramModel.create(spawn);
    gWSManager.redraw();
    gTBManager.deactivateTool();
  }
  
  void click() {}
}