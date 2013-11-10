// Imports
import 'dart:html';
import 'workspacemanager.dart';
import 'toolbarmanager.dart';
import 'datagraphmanager.dart';
import 'programmodel.dart';

// Globals
WorkSpaceManager gWSManager;
ToolBarManager gTBManager;
DataGraphManager gDGManager;
ProgramModel gProgramModel;

void main() {
  // Create global objects
  gWSManager = new WorkSpaceManager(querySelector("#workspace").getContext('2d'));
  gTBManager = new ToolBarManager(querySelector("#toolbar").getContext('2d'));
  gDGManager = new DataGraphManager(querySelector("#datagraph").getContext('2d'));
  gProgramModel = new ProgramModel();
}