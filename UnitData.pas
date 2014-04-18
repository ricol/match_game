unit UnitData;

interface

uses
  UnitShare, UnitStack, Dialogs;

const
  MAX = 100;

type
  TMyArray = array of array of integer;
  TLine = array [1 .. MAX] of TPoint;
  TGameLevel = (GAMELEVELLOW, GAMELEVELMEDIUM, GAMELEVELHIGH, GAMELEVELSPECIAL);
  TArrangeType = (ARRANGETYPE0, ARRANGETYPE1, ARRANGETYPE2, ARRANGETYPE3,
    ARRANGETYPE4, ARRANGETYPE5, ARRANGETYPE6, ARRANGETYPE7, ARRANGETYPE8,
    ARRANGETYPE9, ARRANGETYPE10);

const
  AddX = 50;
  AddY = 80;
  MulX = 50;
  MulY = 50;
  R = 50;
  RANDNUM = 1000;

var
  Total: integer = 100;
  data: TMyArray;
  AUpLineLen: integer = 1;
  ARightLineLen: integer = 1;
  ADownLineLen: integer = 1;
  ALeftLineLen: integer = 1;
  BUpLineLen: integer = 1;
  BRightLineLen: integer = 1;
  BDownLineLen: integer = 1;
  BLeftLineLen: integer = 1;
  bIntersect, bNear, bOther, bDirect: boolean;
  AUpLine, ARightLine, ADownLine, ALeftLine, BUpLine, BRightLine, BDownLine,
    BLeftLine, ShareLine, PathLine: TLine;

function IToX(i: integer): integer;
function JToY(j: integer): integer;
function XToI(x: integer): integer;
function YToJ(y: integer): integer;
function Compare(a, b: TPoint): boolean;
procedure InitData();
procedure ReArrange();
procedure RearrangeLeftOverData();
procedure Swap(var tmpA: integer; var tmpB: integer);
procedure InitLine(var tmpLine: TLine; var tmpLineLen: integer);
function BuildUpLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
function BuildRightLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
function BuildDownLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
function BuildLeftLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
function ANearToB(a, b: TPoint): boolean;
function GetHint(var a: TPoint; var b: TPoint): boolean;
function LineNotEmpty(tmpLine: TLine; tmpLineLen: integer): boolean;
function PointIsInArea(tmpPoint: TPoint): boolean;
function PointEqualToPoint(a, b: TPoint): boolean;
function PointIsAvailable(tmpPoint: TPoint): boolean;
function LineIntersectLine(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpPoint: TPoint): boolean;
function HaveLineBetweenLineAndLineHorizon(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpThirdLine: TLine): boolean;
function HaveLineBetweenLineAndLineVertical(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpThirdLine: TLine): boolean;
function ReArrangeData(tmpType: TArrangeType): boolean;
function GetStringFromArrangeType(tmpType: TArrangeType): string;
function GetStringFromGameLevel(tmpLevel: TGameLevel): string;

implementation

function XToI(x: integer): integer;
begin
  result := (x - AddX) div MulX + 1;
end;

function YToJ(y: integer): integer;
begin
  result := (y - AddY) div MulY + 1;
end;

function IToX(i: integer): integer;
begin
  result := (i - 1) * MulX + AddX;
end;

function JToY(j: integer): integer;
begin
  result := (j - 1) * MulY + AddY;
end;

procedure InitData();
var
  i, j, temp: integer;
begin
  SetLength(data, 0, 0);
  SetLength(data, x, y);
  randomize;
  for i := 1 to (x - 2) div 2 do
    for j := 1 to y - 2 do
    begin
      temp := random(Total) + 1;
      data[i, j] := temp;
      data[i + ((x - 2) div 2), j] := temp;
    end;
  ReArrange();
  for i := 0 to y - 1 do
  begin
    data[0, i] := 0;
    data[x - 1, i] := 0;
  end;
  for j := 0 to x - 1 do
  begin
    data[j, 0] := 0;
    data[j, y - 1] := 0;
  end;
end;

procedure Swap(var tmpA: integer; var tmpB: integer);
var
  tmp: integer;
begin
  tmp := tmpA;
  tmpA := tmpB;
  tmpB := tmp;
end;

procedure ReArrange();
var
  num: integer;
  tmpAX, tmpAY, tmpBX, tmpBY: integer;
begin
  randomize();
  for num := 0 to RANDNUM do
  begin
    tmpAX := random(x - 2) + 1;
    tmpAY := random(y - 2) + 1;
    tmpBX := random(x - 2) + 1;
    tmpBY := random(y - 2) + 1;
    Swap(data[tmpAX, tmpAY], data[tmpBX, tmpBY]);
  end;
end;

procedure RearrangeLeftOverData();
var
  num: integer;
  tmpAX, tmpAY, tmpBX, tmpBY: integer;
begin
  randomize();
  for num := 0 to RANDNUM do
  begin
    repeat
      tmpAX := random(x - 2) + 1;
      tmpAY := random(y - 2) + 1;
    until data[tmpAX, tmpAY] <> 0;
    repeat
      tmpBX := random(x - 2) + 1;
      tmpBY := random(y - 2) + 1;
    until data[tmpBX, tmpBY] <> 0;
    Swap(data[tmpAX, tmpAY], data[tmpBX, tmpBY]);
  end;
end;

function GetHint(var a: TPoint; var b: TPoint): boolean;
var
  i, j: integer;
  tmpI, tmpJ: integer;
  tmpA, tmpB: TPoint;
begin
  result := false;
  for i := 1 to x - 2 do
    for j := 1 to y - 2 do
    begin
      if data[i, j] <> 0 then
      begin
        for tmpI := 1 to x - 2 do
          for tmpJ := 1 to y - 2 do
          begin
            if (tmpI = i) and (tmpJ = j) then
              continue;
            if (data[tmpI, tmpJ] <> 0) then
            begin
              if (data[tmpI, tmpJ] = data[i, j]) then
              begin
                tmpA.x := i;
                tmpA.y := j;
                tmpB.x := tmpI;
                tmpB.y := tmpJ;
                if Compare(tmpA, tmpB) then
                begin
                  result := true;
                  a := tmpA;
                  b := tmpB;
                  exit;
                end;
              end
              else
                continue;
            end
            else
              continue;
          end;
      end;
    end;
end;

function ANearToB(a, b: TPoint): boolean;
var
  aLeft, aUp, aDown, aRight: TPoint;
begin
  result := false;
  aLeft.x := a.x - 1;
  aLeft.y := a.y;
  aUp.x := a.x;
  aUp.y := a.y - 1;
  aDown.x := a.x;
  aDown.y := a.y + 1;
  aRight.x := a.x + 1;
  aRight.y := a.y;
  if PointIsInArea(aLeft) and PointEqualToPoint(aLeft, b) then
  begin
    result := true;
    exit;
  end;
  if PointIsInArea(aUp) and PointEqualToPoint(aUp, b) then
  begin
    result := true;
    exit;
  end;
  if PointIsInArea(aDown) and PointEqualToPoint(aDown, b) then
  begin
    result := true;
    exit;
  end;
  if PointIsInArea(aRight) and PointEqualToPoint(aRight, b) then
  begin
    result := true;
    exit;
  end;
end;

function PointIsInArea(tmpPoint: TPoint): boolean;
begin
  result := true;
  if (tmpPoint.x < 0) or (tmpPoint.x > (x - 1)) or (tmpPoint.y < 0) or
    (tmpPoint.y > (y - 1)) then
    result := false;
end;

function PointEqualToPoint(a, b: TPoint): boolean;
begin
  result := false;
  if (a.x = b.x) and (a.y = b.y) then
    result := true;
end;

function PointIsAvailable(tmpPoint: TPoint): boolean;
begin
  result := true;
  if data[tmpPoint.x, tmpPoint.y] <> 0 then
    result := false;
end;

function BuildUpLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
var
  tempPoint: TPoint;
  i: integer;
begin
  result := false;
  for i := tmpPoint.y - 1 downto 0 do
  begin
    tempPoint.x := tmpPoint.x;
    tempPoint.y := i;
    if PointEqualToPoint(tempPoint, tmpB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(tempPoint) then
    begin
      tmpLine[tmpLineLen] := tempPoint;
      inc(tmpLineLen);
    end
    else
      break;
  end;
end;

function BuildRightLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
var
  tempPoint: TPoint;
  i: integer;
begin
  result := false;
  for i := tmpPoint.x + 1 to x - 1 do
  begin
    tempPoint.x := i;
    tempPoint.y := tmpPoint.y;
    if PointEqualToPoint(tempPoint, tmpB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(tempPoint) then
    begin
      tmpLine[tmpLineLen] := tempPoint;
      inc(tmpLineLen);
    end
    else
      break;
  end;
end;

function BuildDownLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
var
  tempPoint: TPoint;
  i: integer;
begin
  result := false;
  for i := tmpPoint.y + 1 to y - 1 do
  begin
    tempPoint.x := tmpPoint.x;
    tempPoint.y := i;
    if PointEqualToPoint(tempPoint, tmpB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(tempPoint) then
    begin
      tmpLine[tmpLineLen] := tempPoint;
      inc(tmpLineLen);
    end
    else
      break;
  end;
end;

function BuildLeftLine(tmpPoint: TPoint; var tmpLine: TLine;
  var tmpLineLen: integer; tmpB: TPoint): boolean;
var
  tempPoint: TPoint;
  i: integer;
begin
  result := false;
  for i := tmpPoint.x - 1 downto 0 do
  begin
    tempPoint.x := i;
    tempPoint.y := tmpPoint.y;
    if PointEqualToPoint(tempPoint, tmpB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(tempPoint) then
    begin
      tmpLine[tmpLineLen] := tempPoint;
      inc(tmpLineLen);
    end
    else
      break;
  end;
end;

function LineNotEmpty(tmpLine: TLine; tmpLineLen: integer): boolean;
begin
  result := true;
  if tmpLineLen = 1 then
    result := false;
end;

function LineIntersectLine(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpPoint: TPoint): boolean;
var
  i, j: integer;
begin
  result := false;
  tmpPoint.x := -1;
  tmpPoint.y := -1;
  for i := 1 to tmpLineALen - 1 do
    for j := 1 to tmpLineBLen - 1 do
    begin
      if PointEqualToPoint(tmpLineA[i], tmpLineB[j]) then
      begin
        tmpPoint := tmpLineA[i];
        result := true;
        exit;
      end;
    end;
end;

procedure InitLine(var tmpLine: TLine; var tmpLineLen: integer);
var
  i: integer;
  tmpZero: TPoint;
begin
  tmpZero.x := 0;
  tmpZero.y := 0;
  tmpLineLen := 1;
  for i := 1 to MAX do
    tmpLine[i] := tmpZero;
end;

function HaveLineBetweenLineAndLineHorizon(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpThirdLine: TLine): boolean;
var
  tmpLine, tmpUpLine, tmpDownLine: TLine;
  tmpLineLen, tmpUpLineLen, tmpDownLineLen, i, j: integer;
  tmpPoint: TPoint;
begin
  result := false;
  for i := 1 to tmpLineALen - 1 do
  begin
    tmpUpLineLen := 1;
    for j := tmpLineA[i].y downto 0 do
    begin
      tmpPoint.x := tmpLineA[i].x;
      tmpPoint.y := j;
      if PointIsInArea(tmpPoint) and PointIsAvailable(tmpPoint) then
      begin
        tmpUpLine[tmpUpLineLen] := tmpPoint;
        inc(tmpUpLineLen);
      end
      else
        break;
    end;
    tmpDownLineLen := 1;
    for j := tmpLineA[i].y + 1 to y - 1 do
    begin
      tmpPoint.x := tmpLineA[i].x;
      tmpPoint.y := j;
      if PointIsInArea(tmpPoint) and PointIsAvailable(tmpPoint) then
      begin
        tmpDownLine[tmpDownLineLen] := tmpPoint;
        inc(tmpDownLineLen);
      end
      else
        break;
    end;
    for j := 1 to tmpUpLineLen - 1 do
      tmpLine[j] := tmpUpLine[j];
    for j := tmpUpLineLen to tmpUpLineLen + tmpDownLineLen - 1 do
      tmpLine[j] := tmpDownLine[j - tmpUpLineLen + 1];
    tmpLineLen := tmpUpLineLen + tmpDownLineLen - 1;
    if LineIntersectLine(tmpLine, tmpLineB, tmpLineLen, tmpLineBLen, tmpPoint)
    then
    begin
      ShareLine[3] := tmpPoint;
      LineIntersectLine(tmpLine, tmpLineA, tmpLineLen, tmpLineALen, tmpPoint);
      ShareLine[4] := tmpPoint;
      result := true;
      exit;
    end;
  end;
end;

function HaveLineBetweenLineAndLineVertical(tmpLineA, tmpLineB: TLine;
  tmpLineALen, tmpLineBLen: integer; var tmpThirdLine: TLine): boolean;
var
  tmpLine, tmpLeftLine, tmpRightLine: TLine;
  tmpLineLen, tmpLeftLineLen, tmpRightLineLen, i, j: integer;
  tmpPoint: TPoint;
begin
  result := false;
  for i := 1 to tmpLineALen - 1 do
  begin
    tmpLeftLineLen := 1;
    for j := tmpLineA[i].x downto 0 do
    begin
      tmpPoint.x := j;
      tmpPoint.y := tmpLineA[i].y;
      if PointIsInArea(tmpPoint) and PointIsAvailable(tmpPoint) then
      begin
        tmpLeftLine[tmpLeftLineLen] := tmpPoint;
        inc(tmpLeftLineLen);
      end
      else
        break;
    end;
    tmpRightLineLen := 1;
    for j := tmpLineA[i].x + 1 to x - 1 do
    begin
      tmpPoint.x := j;
      tmpPoint.y := tmpLineA[i].y;
      if PointIsInArea(tmpPoint) and PointIsAvailable(tmpPoint) then
      begin
        tmpRightLine[tmpRightLineLen] := tmpPoint;
        inc(tmpRightLineLen);
      end
      else
        break;
    end;
    for j := 1 to tmpLeftLineLen - 1 do
      tmpLine[j] := tmpLeftLine[j];
    for j := tmpLeftLineLen to tmpLeftLineLen + tmpRightLineLen - 1 do
      tmpLine[j] := tmpRightLine[j - tmpLeftLineLen + 1];
    tmpLineLen := tmpLeftLineLen + tmpRightLineLen - 1;
    if LineIntersectLine(tmpLine, tmpLineB, tmpLineLen, tmpLineBLen, tmpPoint)
    then
    begin
      ShareLine[3] := tmpPoint;
      LineIntersectLine(tmpLine, tmpLineA, tmpLineLen, tmpLineALen, tmpPoint);
      ShareLine[4] := tmpPoint;
      result := true;
      exit;
    end;
  end;
end;

function Compare(a, b: TPoint): boolean;
var
  IntersectPoint: TPoint;
begin
  result := false;
  bIntersect := false;
  bNear := false;
  bOther := false;
  bDirect := false;
  if data[a.x, a.y] <> data[b.x, b.y] then
    exit;
  if ANearToB(a, b) then
  begin
    ShareLine[1] := a;
    ShareLine[2] := b;
    bNear := true;
    result := true;
    exit;
  end;
  InitLine(AUpLine, AUpLineLen);
  InitLine(ARightLine, ARightLineLen);
  InitLine(ADownLine, ADownLineLen);
  InitLine(ALeftLine, ALeftLineLen);
  InitLine(BUpLine, BUpLineLen);
  InitLine(BRightLine, BRightLineLen);
  InitLine(BDownLine, BDownLineLen);
  InitLine(BLeftLine, BLeftLineLen);
  if BuildUpLine(a, AUpLine, AUpLineLen, b) or BuildRightLine(a, ARightLine,
    ARightLineLen, b) or BuildDownLine(a, ADownLine, ADownLineLen, b) or
    BuildLeftLine(a, ALeftLine, ALeftLineLen, b) then
  begin
    ShareLine[1] := a;
    ShareLine[2] := b;
    bDirect := true;
    result := true;
    exit;
  end;
  BuildUpLine(b, BUpLine, BUpLineLen, a);
  BuildRightLine(b, BRightLine, BRightLineLen, a);
  BuildDownLine(b, BDownLine, BDownLineLen, a);
  BuildLeftLine(b, BLeftLine, BLeftLineLen, a);
  if (LineNotEmpty(AUpLine, AUpLineLen) and
    ((LineNotEmpty(BRightLine, BRightLineLen) and LineIntersectLine(AUpLine,
    BRightLine, AUpLineLen, BRightLineLen, IntersectPoint)) or
    (LineNotEmpty(BLeftLine, BLeftLineLen) and LineIntersectLine(AUpLine,
    BLeftLine, AUpLineLen, BLeftLineLen, IntersectPoint)))) or
    (LineNotEmpty(ADownLine, ADownLineLen) and
    ((LineNotEmpty(BRightLine, BRightLineLen) and LineIntersectLine(ADownLine,
    BRightLine, ADownLineLen, BRightLineLen, IntersectPoint)) or
    (LineNotEmpty(BLeftLine, BLeftLineLen) and LineIntersectLine(ADownLine,
    BLeftLine, ADownLineLen, BLeftLineLen, IntersectPoint)))) or
    (LineNotEmpty(ARightLine, ARightLineLen) and
    (((LineNotEmpty(BUpLine, BUpLineLen) and LineIntersectLine(ARightLine,
    BUpLine, ARightLineLen, BUpLineLen, IntersectPoint)) or
    (LineNotEmpty(BDownLine, BDownLineLen) and LineIntersectLine(ARightLine,
    BDownLine, ARightLineLen, BDownLineLen, IntersectPoint))))) or
    (LineNotEmpty(ALeftLine, ALeftLineLen) and
    (((LineNotEmpty(BUpLine, BUpLineLen) and LineIntersectLine(ALeftLine,
    BUpLine, ALeftLineLen, BUpLineLen, IntersectPoint)) or
    (LineNotEmpty(BDownLine, BDownLineLen) and LineIntersectLine(ALeftLine,
    BDownLine, ALeftLineLen, BDownLineLen, IntersectPoint))))) then
  begin
    ShareLine[1] := a;
    ShareLine[2] := IntersectPoint;
    ShareLine[3] := b;
    bIntersect := true;
    result := true;
    exit;
  end;
  if (LineNotEmpty(AUpLine, AUpLineLen) and
    ((LineNotEmpty(BUpLine, BUpLineLen) and HaveLineBetweenLineAndLineVertical
    (AUpLine, BUpLine, AUpLineLen, BUpLineLen, ShareLine)) or
    (LineNotEmpty(BDownLine, BDownLineLen) and
    HaveLineBetweenLineAndLineVertical(AUpLine, BDownLine, AUpLineLen,
    BDownLineLen, ShareLine)))) or (LineNotEmpty(ADownLine, ADownLineLen) and
    ((LineNotEmpty(BUpLine, BUpLineLen) and HaveLineBetweenLineAndLineVertical
    (ADownLine, BUpLine, ADownLineLen, BUpLineLen, ShareLine)) or
    (LineNotEmpty(BDownLine, BDownLineLen) and
    HaveLineBetweenLineAndLineVertical(ADownLine, BDownLine, ADownLineLen,
    BDownLineLen, ShareLine)))) or (LineNotEmpty(ARightLine, ARightLineLen) and
    ((LineNotEmpty(BRightLine, BRightLineLen) and
    HaveLineBetweenLineAndLineHorizon(ARightLine, BRightLine, ARightLineLen,
    BRightLineLen, ShareLine)) or (LineNotEmpty(BLeftLine, BLeftLineLen) and
    HaveLineBetweenLineAndLineHorizon(ARightLine, BLeftLine, ARightLineLen,
    BLeftLineLen, ShareLine)))) or (LineNotEmpty(ALeftLine, ALeftLineLen) and
    ((LineNotEmpty(BRightLine, BRightLineLen) and
    HaveLineBetweenLineAndLineHorizon(ALeftLine, BRightLine, ALeftLineLen,
    BRightLineLen, ShareLine)) or (LineNotEmpty(BLeftLine, BLeftLineLen) and
    HaveLineBetweenLineAndLineHorizon(ALeftLine, BLeftLine, ALeftLineLen,
    BLeftLineLen, ShareLine)))) then
  begin
    ShareLine[1] := a;
    ShareLine[2] := b;
    bOther := true;
    result := true;
    exit;
  end;
end;

function ReArrangeData(tmpType: TArrangeType): boolean;
var
  i, j, tmpI, tmpJ, StartX, StartY, EndX, EndY: integer;
begin
  result := true;
  StartX := 1;
  StartY := 1;
  EndX := x - 2;
  EndY := y - 2;
  if tmpType = ARRANGETYPE0 then // 第０关 不变化
    exit
  else if tmpType = ARRANGETYPE1 then // 第１关 向下
  begin
    for j := EndY downto StartY do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j - 1 downto StartY do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE2 then // 第２关 向左
  begin
    for i := StartX to EndX do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i + 1 to EndX do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE3 then // 第３关 上下分离
  begin
    // 第一步上半部分向上
    for j := StartY to EndY div 2 do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j + 1 to EndY div 2 do
          begin
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
          end;
        end;
      end;
    // 第二步下半部分向下
    for j := EndY downto EndY div 2 + 1 do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j - 1 downto EndY div 2 + 1 do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE4 then // 第４关 左右分离
  begin
    // 第一步左半部分向左
    for i := StartX to EndX div 2 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i + 1 to EndX div 2 do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
    // 第二步右半部分向右
    for i := EndX downto EndX div 2 + 1 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i - 1 downto EndX div 2 + 1 do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE5 then // 第５关 上下集中
  begin
    // 第一步上半部分向中集中
    for i := StartX to EndX do
      for j := EndY div 2 downto StartY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j - 1 downto StartY do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
    // 第二步下半部分向中集中
    for i := StartX to EndX do
      for j := EndY div 2 + 1 to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j + 1 to EndY do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE6 then // 第６关 左右集中
  begin
    // 第一步左半部分向中集中
    for i := EndX div 2 downto StartX do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i - 1 downto StartX do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
    // 第二步右半部分向中集中
    for i := EndX div 2 + 1 to EndX do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i + 1 to EndX do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE7 then // 第７关 上左下右
  begin
    // 第一步上半部分向左集中
    for i := StartX to EndX do
      for j := StartY to EndY div 2 do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i + 1 to EndX do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;

    // 第二步上半部分向上集中
    for j := StartY to EndY div 2 do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j + 1 to EndY div 2 do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;

    // 第三步下半部分向右集中
    for i := EndX downto StartX do
      for j := (EndY div 2 + 1) to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := (i - 1) downto StartX do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;

    // 第四步下半部分向下集中
    for j := EndY downto (EndY div 2 + 1) do
      for i := EndX downto StartX do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := (j - 1) downto (EndY div 2 + 1) do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE8 then // 第８关 左下右上
  begin
    // 第一步左半部分向左集中
    for i := StartX to EndX div 2 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i + 1 to EndX div 2 do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
    // 第二步左半部分向下集中
    for j := EndY downto StartY do
      for i := StartX to EndX div 2 do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j - 1 downto StartY do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
    // 第三步右半部分向右集中
    for i := EndX downto EndX div 2 + 1 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for tmpI := i - 1 downto EndX div 2 + 1 do
            if data[tmpI, j] <> 0 then
            begin
              data[i, j] := data[tmpI, j];
              data[tmpI, j] := 0;
              break;
            end;
        end;
      end;
    // 第四步右半部分向上集中
    for j := StartY to EndY do
      for i := EndX downto EndX div 2 + 1 do
      begin
        if data[i, j] = 0 then
        begin
          for tmpJ := j + 1 to EndY do
            if data[i, tmpJ] <> 0 then
            begin
              data[i, j] := data[i, tmpJ];
              data[i, tmpJ] := 0;
              break;
            end;
        end;
      end;
  end
  else if tmpType = ARRANGETYPE9 then // 第９关 向外扩散
  begin
    ReArrangeData(ARRANGETYPE3);
    ReArrangeData(ARRANGETYPE4);
  end
  else if tmpType = ARRANGETYPE10 then // 第１０关 向内集中
  begin
    ReArrangeData(ARRANGETYPE5);
    ReArrangeData(ARRANGETYPE6);
  end;
end;

function GetStringFromArrangeType(tmpType: TArrangeType): string;
begin
  case tmpType of
    ARRANGETYPE0:
      result := '不变化';
    ARRANGETYPE1:
      result := '向下';
    ARRANGETYPE2:
      result := '向左';
    ARRANGETYPE3:
      result := '上下分离';
    ARRANGETYPE4:
      result := '左右分离';
    ARRANGETYPE5:
      result := '上下集中';
    ARRANGETYPE6:
      result := '左右集中';
    ARRANGETYPE7:
      result := '上左下右';
    ARRANGETYPE8:
      result := '左下右上';
    ARRANGETYPE9:
      result := '向外扩散';
    ARRANGETYPE10:
      result := '向内集中';
  end;
end;

function GetStringFromGameLevel(tmpLevel: TGameLevel): string;
begin
  case tmpLevel of
    GAMELEVELLOW:
      result := '初级';
    GAMELEVELMEDIUM:
      result := '中级';
    GAMELEVELHIGH:
      result := '高级';
    GAMELEVELSPECIAL:
      result := '特级';
  end;
end;

end.
