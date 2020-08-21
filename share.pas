unit share;

interface

type
  TPoint = record
    X, Y: integer;
  end;

  TColor = -$7FFFFFFF - 1 .. $7FFFFFFF;

const
  clBlack = TColor($000000);
  clMaroon = TColor($000080);
  clGreen = TColor($008000);
  clOlive = TColor($008080);
  clNavy = TColor($800000);
  clPurple = TColor($800080);
  clTeal = TColor($808000);
  clGray = TColor($808080);
  clSilver = TColor($C0C0C0);
  clRed = TColor($0000FF);
  clLime = TColor($00FF00);
  clYellow = TColor($00FFFF);
  clBlue = TColor($FF0000);
  clFuchsia = TColor($FF00FF);
  clAqua = TColor($FFFF00);
  strCAPTION = 'Á¬Á¬¿´';
  MYSLEEPTIME = 200;

var
  X, Y: integer;

function GetColor(num: integer): TColor;

function ColorToNum(color: TColor): integer;

implementation

function ColorToNum(color: TColor): integer;
begin
  case color of
    clBlack:
      result := 1;
    clMaroon:
      result := 2;
    clGreen:
      result := 3;
    clOlive:
      result := 4;
    clNavy:
      result := 5;
    clPurple:
      result := 6;
    clTeal:
      result := 7;
    clGray:
      result := 8;
    clSilver:
      result := 9;
    clRed:
      result := 10;
    clLime:
      result := 11;
    clYellow:
      result := 12;
    clBlue:
      result := 13;
    clFuchsia:
      result := 14;
    clAqua:
      result := 15;
  else
    result := 1;
  end;
end;

function GetColor(num: integer): TColor;
begin
  case num of
    1:
      result := clBlack;
    2:
      result := clMaroon;
    3:
      result := clGreen;
    4:
      result := clOlive;
    5:
      result := clNavy;
    6:
      result := clPurple;
    7:
      result := clTeal;
    8:
      result := clGray;
    9:
      result := clSilver;
    10:
      result := clRed;
    11:
      result := clLime;
    12:
      result := clYellow;
    13:
      result := clBlue;
    14:
      result := clFuchsia;
    15:
      result := clAqua;
  else
    result := clBlack;
  end;
end;

end.
