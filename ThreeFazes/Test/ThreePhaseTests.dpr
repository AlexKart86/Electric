program ThreePhaseTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  TestuFormulaUtils in '..\TestuFormulaUtils.pas',
  uFormulaUtils in '..\..\SharedCode\uFormulaUtils.pas',
  ExprDraw in '..\..\SharedCode\ExprDraw.pas',
  ExprMake in '..\..\SharedCode\ExprMake.pas',
  uConstsShared in '..\..\SharedCode\uConstsShared.pas',
  uStringUtilsShared in '..\..\SharedCode\uStringUtilsShared.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

