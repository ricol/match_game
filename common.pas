unit common;

interface

uses
  share, stack, Dialogs;

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
procedure Swap(var a: integer; var b: integer);
procedure InitLine(var line: TLine; var lineLen: integer);
function BuildUpLine(point: TPoint; var line: TLine;
  var lineLen: integer; pointB: TPoint): boolean;
function BuildRightLine(point: TPoint; var line: TLine;
  var lineLen: integer; pointB: TPoint): boolean;
function BuildDownLine(point: TPoint; var line: TLine;
  var lineLen: integer; pB: TPoint): boolean;
function BuildLeftLine(point: TPoint; var line: TLine;
  var lineLen: integer; pB: TPoint): boolean;
function ANearToB(a, b: TPoint): boolean;
function GetHint(var a: TPoint; var b: TPoint): boolean;
function LineNotEmpty(line: TLine; lineLen: integer): boolean;
function PointIsInArea(p: TPoint): boolean;
function PointEqualToPoint(a, b: TPoint): boolean;
function PointIsAvailable(p: TPoint): boolean;
function LineIntersectLine(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var point: TPoint): boolean;
function HaveLineBetweenLineAndLineHorizon(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var lineThird: TLine): boolean;
function HaveLineBetweenLineAndLineVertical(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var lineThird: TLine): boolean;
function ReArrangeData(t: TArrangeType): boolean;
function GetStringFromArrangeType(t: TArrangeType): string;
function GetStringFromGameLevel(lv: TGameLevel): string;

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
  i, j, tmp: integer;
begin
  SetLength(data, 0, 0);
  SetLength(data, x, y);
  randomize;
  for i := 1 to (x - 2) div 2 do
    for j := 1 to y - 2 do
    begin
      tmp := random(Total) + 1;
      data[i, j] := tmp;
      data[i + ((x - 2) div 2), j] := tmp;
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

procedure Swap(var a: integer; var b: integer);
var
  tmp: integer;
begin
  tmp := a;
  a := b;
  b := tmp;
end;

procedure ReArrange();
var
  num: integer;
  ax, ay, bx, by: integer;
begin
  randomize();
  for num := 0 to RANDNUM do
  begin
    ax := random(x - 2) + 1;
    ay := random(y - 2) + 1;
    bx := random(x - 2) + 1;
    by := random(y - 2) + 1;
    Swap(data[ax, ay], data[bx, by]);
  end;
end;

procedure RearrangeLeftOverData();
var
  num: integer;
  ax, ay, bx, by: integer;
begin
  randomize();
  for num := 0 to RANDNUM do
  begin
    repeat
      ax := random(x - 2) + 1;
      ay := random(y - 2) + 1;
    until data[ax, ay] <> 0;
    repeat
      bx := random(x - 2) + 1;
      by := random(y - 2) + 1;
    until data[bx, by] <> 0;
    Swap(data[ax, ay], data[bx, by]);
  end;
end;

function GetHint(var a: TPoint; var b: TPoint): boolean;
var
  i, j: integer;
  m, n: integer;
  pA, pB: TPoint;
begin
  result := false;
  for i := 1 to x - 2 do
    for j := 1 to y - 2 do
    begin
      if data[i, j] <> 0 then
      begin
        for m := 1 to x - 2 do
          for n := 1 to y - 2 do
          begin
            if (m = i) and (n = j) then
              continue;
            if (data[m, n] <> 0) then
            begin
              if (data[m, n] = data[i, j]) then
              begin
                pA.x := i;
                pA.y := j;
                pB.x := m;
                pB.y := n;
                if Compare(pA, pB) then
                begin
                  result := true;
                  a := pA;
                  b := pB;
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

function PointIsInArea(p: TPoint): boolean;
begin
  result := true;
  if (p.x < 0) or (p.x > (x - 1)) or (p.y < 0) or
    (p.y > (y - 1)) then
    result := false;
end;

function PointEqualToPoint(a, b: TPoint): boolean;
begin
  result := false;
  if (a.x = b.x) and (a.y = b.y) then
    result := true;
end;

function PointIsAvailable(p: TPoint): boolean;
begin
  result := true;
  if data[p.x, p.y] <> 0 then
    result := false;
end;

function BuildUpLine(point: TPoint; var line: TLine;
  var lineLen: integer; pointB: TPoint): boolean;
var
  p: TPoint;
  i: integer;
begin
  result := false;
  for i := point.y - 1 downto 0 do
  begin
    p.x := point.x;
    p.y := i;
    if PointEqualToPoint(p, pointB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(p) then
    begin
      line[lineLen] := p;
      inc(lineLen);
    end
    else
      break;
  end;
end;

function BuildRightLine(point: TPoint; var line: TLine;
  var lineLen: integer; pointB: TPoint): boolean;
var
  p: TPoint;
  i: integer;
begin
  result := false;
  for i := point.x + 1 to x - 1 do
  begin
    p.x := i;
    p.y := point.y;
    if PointEqualToPoint(p, pointB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(p) then
    begin
      line[lineLen] := p;
      inc(lineLen);
    end
    else
      break;
  end;
end;

function BuildDownLine(point: TPoint; var line: TLine;
  var lineLen: integer; pB: TPoint): boolean;
var
  p: TPoint;
  i: integer;
begin
  result := false;
  for i := point.y + 1 to y - 1 do
  begin
    p.x := point.x;
    p.y := i;
    if PointEqualToPoint(p, pB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(p) then
    begin
      line[lineLen] := p;
      inc(lineLen);
    end
    else
      break;
  end;
end;

function BuildLeftLine(point: TPoint; var line: TLine;
  var lineLen: integer; pB: TPoint): boolean;
var
  p: TPoint;
  i: integer;
begin
  result := false;
  for i := point.x - 1 downto 0 do
  begin
    p.x := i;
    p.y := point.y;
    if PointEqualToPoint(p, pB) then
    begin
      result := true;
      break;
    end;
    if PointIsAvailable(p) then
    begin
      line[lineLen] := p;
      inc(lineLen);
    end
    else
      break;
  end;
end;

function LineNotEmpty(line: TLine; lineLen: integer): boolean;
begin
  result := true;
  if lineLen = 1 then
    result := false;
end;

function LineIntersectLine(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var point: TPoint): boolean;
var
  i, j: integer;
begin
  result := false;
  point.x := -1;
  point.y := -1;
  for i := 1 to lineALen - 1 do
    for j := 1 to lineBLen - 1 do
    begin
      if PointEqualToPoint(lineA[i], lineB[j]) then
      begin
        point := lineA[i];
        result := true;
        exit;
      end;
    end;
end;

procedure InitLine(var line: TLine; var lineLen: integer);
var
  i: integer;
  pZero: TPoint;
begin
  pZero.x := 0;
  pZero.y := 0;
  lineLen := 1;
  for i := 1 to MAX do
    line[i] := pZero;
end;

function HaveLineBetweenLineAndLineHorizon(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var lineThird: TLine): boolean;
var
  line, lineUp, lineDown: TLine;
  lineLen, lineUpLen, lineDownLen, i, j: integer;
  p: TPoint;
begin
  result := false;
  for i := 1 to lineALen - 1 do
  begin
    lineUpLen := 1;
    for j := lineA[i].y downto 0 do
    begin
      p.x := lineA[i].x;
      p.y := j;
      if PointIsInArea(p) and PointIsAvailable(p) then
      begin
        lineUp[lineUpLen] := p;
        inc(lineUpLen);
      end
      else
        break;
    end;
    lineDownLen := 1;
    for j := lineA[i].y + 1 to y - 1 do
    begin
      p.x := lineA[i].x;
      p.y := j;
      if PointIsInArea(p) and PointIsAvailable(p) then
      begin
        lineDown[lineDownLen] := p;
        inc(lineDownLen);
      end
      else
        break;
    end;
    for j := 1 to lineUpLen - 1 do
      line[j] := lineUp[j];
    for j := lineUpLen to lineUpLen + lineDownLen - 1 do
      line[j] := lineDown[j - lineUpLen + 1];
    lineLen := lineUpLen + lineDownLen - 1;
    if LineIntersectLine(line, lineB, lineLen, lineBLen, p)
    then
    begin
      ShareLine[3] := p;
      LineIntersectLine(line, lineA, lineLen, lineALen, p);
      ShareLine[4] := p;
      result := true;
      exit;
    end;
  end;
end;

function HaveLineBetweenLineAndLineVertical(lineA, lineB: TLine;
  lineALen, lineBLen: integer; var lineThird: TLine): boolean;
var
  line, lineLeft, lineRight: TLine;
  lineLen, lineLeftLen, lineRightLen, i, j: integer;
  p: TPoint;
begin
  result := false;
  for i := 1 to lineALen - 1 do
  begin
    lineLeftLen := 1;
    for j := lineA[i].x downto 0 do
    begin
      p.x := j;
      p.y := lineA[i].y;
      if PointIsInArea(p) and PointIsAvailable(p) then
      begin
        lineLeft[lineLeftLen] := p;
        inc(lineLeftLen);
      end
      else
        break;
    end;
    lineRightLen := 1;
    for j := lineA[i].x + 1 to x - 1 do
    begin
      p.x := j;
      p.y := lineA[i].y;
      if PointIsInArea(p) and PointIsAvailable(p) then
      begin
        lineRight[lineRightLen] := p;
        inc(lineRightLen);
      end
      else
        break;
    end;
    for j := 1 to lineLeftLen - 1 do
      line[j] := lineLeft[j];
    for j := lineLeftLen to lineLeftLen + lineRightLen - 1 do
      line[j] := lineRight[j - lineLeftLen + 1];
    lineLen := lineLeftLen + lineRightLen - 1;
    if LineIntersectLine(line, lineB, lineLen, lineBLen, p)
    then
    begin
      ShareLine[3] := p;
      LineIntersectLine(line, lineA, lineLen, lineALen, p);
      ShareLine[4] := p;
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

function ReArrangeData(t: TArrangeType): boolean;
var
  i, j, m, n, StartX, StartY, EndX, EndY: integer;
begin
  result := true;
  StartX := 1;
  StartY := 1;
  EndX := x - 2;
  EndY := y - 2;
  if t = ARRANGETYPE0 then // 第０关 不变化
    exit
  else if t = ARRANGETYPE1 then // 第１关 向下
  begin
    for j := EndY downto StartY do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for n := j - 1 downto StartY do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE2 then // 第２关 向左
  begin
    for i := StartX to EndX do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for m := i + 1 to EndX do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE3 then // 第３关 上下分离
  begin
    // 第一步上半部分向上
    for j := StartY to EndY div 2 do
      for i := StartX to EndX do
      begin
        if data[i, j] = 0 then
        begin
          for n := j + 1 to EndY div 2 do
          begin
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
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
          for n := j - 1 downto EndY div 2 + 1 do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE4 then // 第４关 左右分离
  begin
    // 第一步左半部分向左
    for i := StartX to EndX div 2 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for m := i + 1 to EndX div 2 do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for m := i - 1 downto EndX div 2 + 1 do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE5 then // 第５关 上下集中
  begin
    // 第一步上半部分向中集中
    for i := StartX to EndX do
      for j := EndY div 2 downto StartY do
      begin
        if data[i, j] = 0 then
        begin
          for n := j - 1 downto StartY do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
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
          for n := j + 1 to EndY do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE6 then // 第６关 左右集中
  begin
    // 第一步左半部分向中集中
    for i := EndX div 2 downto StartX do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for m := i - 1 downto StartX do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for m := i + 1 to EndX do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE7 then // 第７关 上左下右
  begin
    // 第一步上半部分向左集中
    for i := StartX to EndX do
      for j := StartY to EndY div 2 do
      begin
        if data[i, j] = 0 then
        begin
          for m := i + 1 to EndX do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for n := j + 1 to EndY div 2 do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
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
          for m := (i - 1) downto StartX do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for n := (j - 1) downto (EndY div 2 + 1) do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE8 then // 第８关 左下右上
  begin
    // 第一步左半部分向左集中
    for i := StartX to EndX div 2 do
      for j := StartY to EndY do
      begin
        if data[i, j] = 0 then
        begin
          for m := i + 1 to EndX div 2 do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for n := j - 1 downto StartY do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
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
          for m := i - 1 downto EndX div 2 + 1 do
            if data[m, j] <> 0 then
            begin
              data[i, j] := data[m, j];
              data[m, j] := 0;
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
          for n := j + 1 to EndY do
            if data[i, n] <> 0 then
            begin
              data[i, j] := data[i, n];
              data[i, n] := 0;
              break;
            end;
        end;
      end;
  end
  else if t = ARRANGETYPE9 then // 第９关 向外扩散
  begin
    ReArrangeData(ARRANGETYPE3);
    ReArrangeData(ARRANGETYPE4);
  end
  else if t = ARRANGETYPE10 then // 第１０关 向内集中
  begin
    ReArrangeData(ARRANGETYPE5);
    ReArrangeData(ARRANGETYPE6);
  end;
end;

function GetStringFromArrangeType(t: TArrangeType): string;
begin
  case t of
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

function GetStringFromGameLevel(lv: TGameLevel): string;
begin
  case lv of
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
