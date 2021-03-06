unit stack;

interface

uses
  share;

const
  STACKLEN = 10;

type
  TStack = array [1 .. STACKLEN] of TPoint;

var
  MyStack: TStack;
  StackFlag: integer;

procedure InitStack();
function StackIsEmpty(): boolean;
function GetTop(): TPoint;
procedure Push(point: TPoint);
function Pop(): TPoint;

implementation

procedure InitStack();
var
  i: integer;
begin
  StackFlag := 1;
  for i := 1 to STACKLEN do
  begin
    MyStack[i].x := 100;
    MyStack[i].y := 100;
  end;
end;

function StackIsEmpty(): boolean;
begin
  result := false;
  if StackFlag = 1 then
    result := true;
end;

function GetTop(): TPoint;
begin
  if not StackIsEmpty() then
  begin
    result.x := MyStack[StackFlag - 1].x;
    result.y := MyStack[StackFlag - 1].y;
  end
  else
  begin
    result.x := x;
    result.y := y;
  end;
end;

procedure Push(point: TPoint);
begin
  MyStack[StackFlag].x := point.x;
  MyStack[StackFlag].y := point.y;
  Inc(StackFlag);
end;

function Pop(): TPoint;
begin
  dec(StackFlag);
  result.x := MyStack[StackFlag].x;
  result.y := MyStack[StackFlag].y;
end;

end.
