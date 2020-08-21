unit main;

{
  CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, MPlayer, Common, Share,
  Stack, MMSystem,
  AppEvnts;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuGame: TMenuItem;
    MenuGameLow: TMenuItem;
    MenuGameMedium: TMenuItem;
    MenuGameHigh: TMenuItem;
    MenuGameSeperator: TMenuItem;
    MenuGameExit: TMenuItem;
    MenuHelp: TMenuItem;
    MenuGameAbout: TMenuItem;
    PanelMain: TPanel;
    MainPaintBox: TPaintBox;
    N1: TMenuItem;
    MenuOptionBitmap: TMenuItem;
    MenuOptionSound: TMenuItem;
    MenuOptionMusic: TMenuItem;
    N2: TMenuItem;
    MenuTop: TMenuItem;
    MenuGameSpecial: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    TimerGuard: TTimer;
    MenuOptionBackGround: TMenuItem;
    N4: TMenuItem;
    MenuOptionGetHint: TMenuItem;
    MenuOptionRearrange: TMenuItem;
    MenuAutoPlay: TMenuItem;
    TimerAutoPlay: TTimer;
    N3: TMenuItem;
    MenuChange: TMenuItem;
    MenuNoChange: TMenuItem;
    MenuToDown: TMenuItem;
    MenuToLeft: TMenuItem;
    MenuUpDownSeperate: TMenuItem;
    MenuLeftRightSeperate: TMenuItem;
    MenuUpDownCollect: TMenuItem;
    MenuLeftRightCollect: TMenuItem;
    MenuLeftUpRightDown: TMenuItem;
    MenuLeftDownRightUp: TMenuItem;
    MenuUpDownLeftRightSeperate: TMenuItem;
    MenuUpDownLeftRightCollect: TMenuItem;
    MenuGameAbandon: TMenuItem;
    TimerGameDelay: TTimer;
    N7: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    N5: TMenuItem;
    MenuGamePause: TMenuItem;
    procedure MenuGameExitClick(Sender: TObject);
    procedure MenuGameLowClick(Sender: TObject);
    procedure MenuGameMediumClick(Sender: TObject);
    procedure MenuGameHighClick(Sender: TObject);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MainPaintBoxPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuGameAboutClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuOptionBitmapClick(Sender: TObject);
    procedure MenuGameSpecialClick(Sender: TObject);
    procedure MenuOptionMusicClick(Sender: TObject);
    procedure MenuOptionSoundClick(Sender: TObject);
    procedure TimerGuardTimer(Sender: TObject);
    procedure MenuOptionBackGroundClick(Sender: TObject);
    procedure MenuTopClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuOptionGetHintClick(Sender: TObject);
    procedure MenuOptionRearrangeClick(Sender: TObject);
    procedure MenuAutoPlayClick(Sender: TObject);
    procedure TimerAutoPlayTimer(Sender: TObject);
    procedure MenuNoChangeClick(Sender: TObject);
    procedure MenuToDownClick(Sender: TObject);
    procedure MenuToLeftClick(Sender: TObject);
    procedure MenuUpDownSeperateClick(Sender: TObject);
    procedure MenuLeftRightSeperateClick(Sender: TObject);
    procedure MenuUpDownCollectClick(Sender: TObject);
    procedure MenuLeftRightCollectClick(Sender: TObject);
    procedure MenuLeftUpRightDownClick(Sender: TObject);
    procedure MenuLeftDownRightUpClick(Sender: TObject);
    procedure MenuUpDownLeftRightSeperateClick(Sender: TObject);
    procedure MenuUpDownLeftRightCollectClick(Sender: TObject);
    procedure MenuGameAbandonClick(Sender: TObject);
    procedure TimerGameDelayTimer(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure ApplicationEvents1Restore(Sender: TObject);
    procedure MenuGamePauseClick(Sender: TObject);
  private
    procedure DrawStartBitmap();
    procedure DrawGameRunningData();
    procedure GameStart();
    procedure GameContinue();
    procedure GameOver();
    procedure ShowArray();
    function GameCheck(): boolean;
    procedure Draw(i, j: Integer; num: Integer);
    procedure Dark(i, j: Integer);
    procedure GetBitmap(var tmpBitmap: TBitmap; tmpNum: Integer);
    procedure DrawLine(line: TLine; num: Integer; flag: boolean);
    procedure SetSelected(x, y: Integer);
    procedure ResetSelected(x, y: Integer);
    function GetMusic(): string;
    procedure PlaySound(sound: string);
    procedure DrawGameTime();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  OPACITY = 140;
  SELECTEDNUM = 0;
  SLEEPTIME = 200;
  MUSICNUM = 15;
  BITMAPNUM = 25;
  COLORNUM = 15;
  RESOURCEPATH = '.\资源';
  TEXTSTART = 50;
  TOTALTIME = 100;
  TEXTSPACE = 70;
  TEXTHEIGHT = 10;
  GAMETIMESPACE = 50;

var
  GBitMap: TBitmap = nil;
  GBitMapNumber: Integer = 1;
  GBkGroundNumber: Integer = 1;
  GPath: string = '\pic1\';
  GGame: TGameLevel = GAMELEVELLOW;
  GBackGroundColor: TColor = clBlack;
  GHintA, GHintB: TPoint;
  GChangeType: TArrangeType = ARRANGETYPE0;
  GGameRunning: boolean = false;
  GBackGroundImage: TImage = nil;
  GLife: Integer = 2;
  GHint: Integer = 4;
  GTime: Integer = TOTALTIME;
  GModeDebug: boolean = false;

procedure TMainForm.MenuAutoPlayClick(Sender: TObject);
begin
  if not GGameRunning then
    exit;
  MenuAutoPlay.Checked := not MenuAutoPlay.Checked;
  TimerAutoPlay.Enabled := MenuAutoPlay.Checked;
end;

procedure TMainForm.MenuGameAbandonClick(Sender: TObject);
begin
  GGameRunning := false;
  MainForm.MenuGameAbandon.Enabled := false;
  MainForm.MenuOptionGetHint.Enabled := false;
  MainForm.MenuOptionRearrange.Enabled := false;
  MainForm.MenuOptionBackGround.Enabled := false;
  MainForm.MenuOptionSound.Enabled := false;
  MainForm.MenuOptionBitmap.Enabled := false;
  MainForm.MenuChange.Enabled := false;
  MainForm.MenuAutoPlay.Enabled := false;
  MainForm.MenuGameLow.Enabled := true;
  MainForm.MenuGameMedium.Enabled := true;
  MainForm.MenuGameHigh.Enabled := true;
  MainForm.MenuGameSpecial.Enabled := true;
  TimerGameDelay.Enabled := false;
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuGameAboutClick(Sender: TObject);
var
  s: string;
begin
  s := '名称   - 连连看' + sLineBreak + '开发者 - RICOL' + sLineBreak + '版本   - V4.0' +
    sLineBreak + '联系   - WANGXINGHE1983@GMAIL.COM';
  MessageBox(Self.Handle, PChar(s), '关于', MB_OK);
end;

procedure TMainForm.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MenuGameLowClick(Sender: TObject);
begin
  GGame := GAMELEVELLOW;
  GameStart();
end;

procedure TMainForm.MenuGameMediumClick(Sender: TObject);
begin
  GGame := GAMELEVELMEDIUM;
  GameStart();
end;

procedure TMainForm.MenuGamePauseClick(Sender: TObject);
begin
  SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TMainForm.MenuGameHighClick(Sender: TObject);
begin
  GGame := GAMELEVELHIGH;
  GameStart();
end;

procedure TMainForm.MenuGameSpecialClick(Sender: TObject);
begin
  GGame := GAMELEVELSPECIAL;
  GameStart();
end;

procedure TMainForm.MenuLeftDownRightUpClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE8;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuLeftRightCollectClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE6;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuLeftRightSeperateClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE4;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuLeftUpRightDownClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE7;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuNoChangeClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE0;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuOptionBackGroundClick(Sender: TObject);
var
  s: string;
begin
  if not GGameRunning then
    exit;
  try
    s := InputBox('输入', '请输入背景颜色编号(1 - ' + IntToStr(COLORNUM) + '): ',
      IntToStr(GBkGroundNumber));
  except
    s := IntToStr(GBkGroundNumber);
  end;
  if (StrToInt(s) < 1) or (StrToInt(s) > COLORNUM) then
    s := IntToStr(GBkGroundNumber);
  GBkGroundNumber := StrToInt(s);
  GBackGroundColor := GetColor(GBkGroundNumber);
  PanelMain.Color := GBackGroundColor;
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuOptionBitmapClick(Sender: TObject);
var
  s: string;
begin
  if not GGameRunning then
    exit;
  try
    s := InputBox('输入', '请输入图案编号(1 - ' + IntToStr(BITMAPNUM) + '): ',
      IntToStr(GBitMapNumber));
  except
    s := IntToStr(GBitMapNumber);
  end;
  if (StrToInt(s) < 1) or (StrToInt(s) > BITMAPNUM) then
    s := IntToStr(GBitMapNumber);
  GBitMapNumber := StrToInt(s);
  GPath := '\pic' + IntToStr(GBitMapNumber) + '\';
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuOptionMusicClick(Sender: TObject);
begin
  MenuOptionMusic.Checked := not MenuOptionMusic.Checked;
  TimerGuard.Enabled := MenuOptionMusic.Checked;
  if MenuOptionMusic.Checked then
  begin
    PlaySound('NULL');
    MediaPlayer1.DeviceType := dtAutoSelect;
    MediaPlayer1.FileName := GetMusic();
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end
  else
    MediaPlayer1.Stop;
end;

procedure TMainForm.MenuOptionRearrangeClick(Sender: TObject);
begin
  if not GGameRunning then
    exit;
  if GLife > 0 then
    Dec(GLife)
  else
    exit;
  MainPaintBoxPaint(Sender);
  PlaySound('REARRANGE');
  repeat
    RearrangeLeftOverData();
  until GetHint(GHintA, GHintB);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuOptionSoundClick(Sender: TObject);
begin
  MenuOptionSound.Checked := not MenuOptionSound.Checked;
end;

procedure TMainForm.MenuToDownClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE1;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuToLeftClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE2;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuTopClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '此功能暂时没有加入.', '信息', MB_OK or MB_ICONINFORMATION);
end;

procedure TMainForm.MenuUpDownCollectClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE5;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuUpDownLeftRightCollectClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE10;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuUpDownLeftRightSeperateClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE9;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuUpDownSeperateClick(Sender: TObject);
begin
  GChangeType := ARRANGETYPE3;
  ReArrangeData(GChangeType);
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.PlaySound(sound: string);
begin
  if sound <> 'NULL' then
  begin
    if MainForm.MenuOptionSound.Checked then
      sndPlaySound(PChar(RESOURCEPATH + '\Sound\' + sound + '.wav'),
        SND_ASYNC);
  end
  else
    sndPlaySound(nil, SND_ASYNC);
end;

procedure TMainForm.ResetSelected(x, y: Integer);
var
  num: Integer;
begin
  num := data[x, y];
  GetBitmap(GBitMap, num);
  MainPaintBox.Canvas.Draw(IToX(x), JToY(y), GBitMap);
end;

procedure TMainForm.SetSelected(x, y: Integer);
var
  num: Integer;
begin
  num := data[x, y];
  GetBitmap(GBitMap, 0);
  MainPaintBox.Canvas.Draw(IToX(x), JToY(y), GBitMap);
  GetBitmap(GBitMap, num);
  MainPaintBox.Canvas.Draw(IToX(x), JToY(y), GBitMap, OPACITY);
end;

procedure TMainForm.ShowArray;
var
  i, j: Integer;
begin
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
      Draw(i, j, data[i][j]);
end;

procedure TMainForm.MenuOptionGetHintClick(Sender: TObject);
begin
  if not GGameRunning then
    exit;
  if GHint > 0 then
    Dec(GHint)
  else
    exit;
  MainPaintBoxPaint(Sender);
  if (GHintA.X <> 0) and (GHintA.Y <> 0) and (GHintB.X <> 0) and (GHintB.Y <> 0)
  then
  begin
    SetSelected(GHintA.X, GHintA.Y);
    SetSelected(GHintB.X, GHintB.Y);
  end
  else
    MessageBox(Self.Handle, '需要对剩下的卡片进行重排！', '信息', MB_OK);
end;

procedure TMainForm.TimerGuardTimer(Sender: TObject);
begin
  if MediaPlayer1.Position >= MediaPlayer1.Length then
  begin
    MediaPlayer1.FileName := GetMusic();
    MediaPlayer1.Open;
    MediaPlayer1.Play;
  end;
end;

procedure TMainForm.TimerAutoPlayTimer(Sender: TObject);
var
  a, b: TPoint;
  ax, ay, bx, by: Integer;
  shiftState: TShiftState;
begin
  if not GGameRunning then
  begin
    TimerAutoPlay.Enabled := false;
    exit;
  end;
  if not GetHint(a, b) then
    exit;
  ax := IToX(a.X);
  ay := JToY(a.Y);
  bx := IToX(b.X);
  by := JToY(b.Y);
  MainPaintBoxMouseDown(Sender, mbLeft, shiftState, ax, ay);
  Sleep(MYSLEEPTIME);
  MainPaintBoxMouseDown(Sender, mbLeft, shiftState, bx, by);
  Sleep(MYSLEEPTIME);
end;

procedure TMainForm.TimerGameDelayTimer(Sender: TObject);
begin
  Dec(GTime);
  DrawGameTime();
  if GTime <= 0 then
  begin
    TimerGameDelay.Enabled := false;
    MessageBox(MainForm.Handle, '游戏结束!', '信息', MB_OK or MB_ICONINFORMATION);
    GameOver();
    exit;
  end;
end;

procedure TMainForm.ApplicationEvents1Minimize(Sender: TObject);
begin
  if not GGameRunning then
    exit;
  TimerGameDelay.Enabled := false;
  Beep();
  Application.Title := strCAPTION + ' - 暂停';
end;

procedure TMainForm.ApplicationEvents1Restore(Sender: TObject);
begin
  if not GGameRunning then
    exit;
  TimerGameDelay.Enabled := true;
  Beep;
  Application.Title := strCAPTION;
end;

procedure TMainForm.Dark(i, j: Integer);
begin
  data[i][j] := 0;
  Draw(i, j, 0);
end;

procedure TMainForm.Draw(i, j, num: Integer);
begin
  GetBitmap(GBitMap, num);
  MainForm.MainPaintBox.Canvas.Draw(IToX(i), JToY(j), GBitMap);
end;

procedure TMainForm.DrawGameRunningData;
begin
  if not GGameRunning then
    exit;
  with MainPaintBox do
  begin
    Canvas.Font.Color := clYellow;
    Canvas.Font.Size := 10;
    SetBkColor(Canvas.Handle, GBackGroundColor);
    Canvas.TextOut(TEXTSTART, TEXTHEIGHT, '难度：                 ');
    Canvas.TextOut(TEXTSTART, TEXTHEIGHT,
      '难度：' + GetStringFromGameLevel(GGame));
    Canvas.TextOut(TEXTSTART + TEXTSPACE + 20, TEXTHEIGHT,
      '关卡：                         ');
    Canvas.TextOut(TEXTSTART + TEXTSPACE + 20, TEXTHEIGHT,
      '关卡：' + GetStringFromArrangeType(GChangeType));
    Canvas.TextOut(TEXTSTART + 3 * TEXTSPACE, TEXTHEIGHT, '生命：     ');
    Canvas.TextOut(TEXTSTART + 3 * TEXTSPACE, TEXTHEIGHT,
      '生命：' + IntToStr(GLife));
    Canvas.TextOut(TEXTSTART + 4 * TEXTSPACE, TEXTHEIGHT, '提示：     ');
    Canvas.TextOut(TEXTSTART + 4 * TEXTSPACE, TEXTHEIGHT,
      '提示：' + IntToStr(GHint));
    Canvas.TextOut(TEXTSTART + 5 * TEXTSPACE, TEXTHEIGHT, '时间：');
  end;
end;

procedure TMainForm.DrawGameTime;
begin
  with MainPaintBox do
  begin
    Canvas.Pen.Color := clYellow;
    Canvas.Brush.Color := GBackGroundColor;
    Canvas.Pen.Width := 1;
    Canvas.Rectangle(TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE, TEXTHEIGHT,
      TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + TOTALTIME *
      (Integer(GGame) + 1), TEXTHEIGHT + 20);
    Canvas.Pen.Color := clRed;
    Canvas.Brush.Color := clRed;
    Canvas.Rectangle(TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + 1,
      TEXTHEIGHT + 1, TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + GTime *
      (Integer(GGame) + 1) - 1, TEXTHEIGHT + 20 - 1);
  end;
end;

procedure TMainForm.DrawLine(line: TLine; num: Integer; flag: boolean);
begin
  if flag then
  begin
    with MainForm.MainPaintBox do
    begin
      Canvas.Pen.Color := clRed;
      Canvas.Pen.Width := 5;
      if num = 3 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
        Canvas.LineTo(IToX(line[3].X) + R div 2,
          JToY(line[3].Y) + R div 2);
      end
      else if num = 2 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
      end
      else if num = 4 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[4].X) + R div 2,
          JToY(line[4].Y) + R div 2);
        Canvas.LineTo(IToX(line[3].X) + R div 2,
          JToY(line[3].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
      end;
    end;
  end
  else
  begin
    with MainForm.MainPaintBox do
    begin
      MainForm.PanelMain.Color := GBackGroundColor;
      Canvas.Pen.Color := GBackGroundColor;
      Canvas.Pen.Width := 5;
      if num = 3 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
        Canvas.LineTo(IToX(line[3].X) + R div 2,
          JToY(line[3].Y) + R div 2);
      end
      else if num = 2 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
      end
      else if num = 4 then
      begin
        Canvas.MoveTo(IToX(line[1].X) + R div 2,
          JToY(line[1].Y) + R div 2);
        Canvas.LineTo(IToX(line[4].X) + R div 2,
          JToY(line[4].Y) + R div 2);
        Canvas.LineTo(IToX(line[3].X) + R div 2,
          JToY(line[3].Y) + R div 2);
        Canvas.LineTo(IToX(line[2].X) + R div 2,
          JToY(line[2].Y) + R div 2);
      end;
    end;
  end;
end;

procedure TMainForm.DrawStartBitmap;
begin
  if GBackGroundImage = nil then
  begin
    GBackGroundImage := TImage.Create(PanelMain);
    GBackGroundImage.Parent := PanelMain;
    GBackGroundImage.Align := alClient;
    GBackGroundImage.Visible := true;
    GBackGroundImage.Stretch := true;
    GBackGroundImage.Picture.Bitmap.LoadFromFile
      (RESOURCEPATH + '\BackGround\Start.bmp');
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PanelMain.Color := clBlack;
  DrawStartBitmap();
  GBitMap := TBitmap.Create;
  randomize;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if GBitMap <> nil then
  begin
    GBitMap.Free;
    GBitMap := nil;
  end;
  if GBackGroundImage <> nil then
  begin
    GBackGroundImage.Free;
    GBackGroundImage := nil;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    MenuOptionGetHintClick(Sender)
  else if Key = VK_F6 then
    MenuOptionRearrangeClick(Sender)
  else if Key = VK_F1 then
    MenuGameLowClick(Sender)
  else if Key = VK_F2 then
    MenuGameMediumClick(Sender)
  else if Key = VK_F3 then
    MenuGameHighClick(Sender)
  else if Key = VK_F4 then
    MenuGameSpecialClick(Sender)
  else if Key = VK_F7 then
    MenuAutoPlayClick(Sender)
  else if Key = VK_F8 then
    MenuGamePauseClick(Sender)
  else if Key = VK_ESCAPE then
    MenuGameAbandonClick(Sender);
  // else if Key = VK_RETURN then
  // SetGamePause(true);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if GGameRunning then
  begin
    Self.ClientWidth := (X - 1) * MulX + AddX;
    Self.ClientHeight := (Y - 1) * MulY + AddY;
  end;
end;

function TMainForm.GameCheck: boolean;
var
  i, j: Integer;
begin
  result := true;
  for i := 1 to X - 2 do
    for j := 1 to Y - 2 do
    begin
      if data[i, j] <> 0 then
      begin
        result := false;
        break;
      end;
    end;
end;

procedure TMainForm.GameContinue;
begin
  GTime := 100;
  GGameRunning := true;
  if GBackGroundImage <> nil then
  begin
    GBackGroundImage.Free;
    GBackGroundImage := nil;
  end;
  MenuGameAbandon.Enabled := true;
  MenuOptionGetHint.Enabled := true;
  MenuOptionRearrange.Enabled := true;
  MenuOptionBackGround.Enabled := true;
  MenuOptionSound.Enabled := true;
  MenuOptionBitmap.Enabled := true;
  MenuChange.Enabled := true;
  MenuAutoPlay.Enabled := true;
  MenuGameLow.Enabled := false;
  MenuGameMedium.Enabled := false;
  MenuGameHigh.Enabled := false;
  MenuGameSpecial.Enabled := false;
  InitData();
  InitStack();
  while not GetHint(GHintA, GHintB) do
    RearrangeLeftOverData();
  FormResize(nil);
  TimerGameDelay.Enabled := true;
  MainPaintBoxPaint(nil);
end;

procedure TMainForm.GameOver;
begin
  GGameRunning := false;
  TimerGameDelay.Enabled := false;
  MainForm.MainPaintBoxPaint(nil);
end;

procedure TMainForm.GameStart;
begin
  GTime := 100;
  if GGame = GAMELEVELLOW then
  begin
    Total := 25;
    X := 12;
    Y := 8;
    GLife := 2;
    GHint := 4;
    MenuGameLow.Checked := true;
  end
  else if GGame = GAMELEVELMEDIUM then
  begin
    Total := 30;
    X := 14;
    Y := 9;
    GLife := 3;
    GHint := 6;
    MenuGameMedium.Checked := true;
  end
  else if GGame = GAMELEVELHIGH then
  begin
    Total := 35;
    X := 16;
    Y := 10;
    GLife := 4;
    GHint := 8;
    MenuGameHigh.Checked := true;
  end
  else if GGame = GAMELEVELSPECIAL then
  begin
    Total := 45;
    X := 18;
    Y := 11;
    GLife := 5;
    GHint := 10;
    MenuGameSpecial.Checked := true;
  end
  else
  begin
    Total := 25;
    X := 12;
    Y := 8;
    GLife := 2;
    GHint := 4;
    GGame := GAMELEVELLOW;
  end;
  GGameRunning := true;
  if GBackGroundImage <> nil then
  begin
    GBackGroundImage.Free;
    GBackGroundImage := nil;
  end;
  MenuGameAbandon.Enabled := true;
  MenuOptionGetHint.Enabled := true;
  MenuOptionRearrange.Enabled := true;
  MenuOptionBackGround.Enabled := true;
  MenuOptionSound.Enabled := true;
  MenuOptionBitmap.Enabled := true;
  MenuChange.Enabled := true;
  MenuAutoPlay.Enabled := true;
  MenuGameLow.Enabled := false;
  MenuGameMedium.Enabled := false;
  MenuGameHigh.Enabled := false;
  MenuGameSpecial.Enabled := false;
  InitData();
  InitStack();
  while not GetHint(GHintA, GHintB) do
    RearrangeLeftOverData();
  FormResize(nil);
  GChangeType := ARRANGETYPE0;
  TimerGameDelay.Enabled := true;
  MainPaintBoxPaint(nil);
end;

procedure TMainForm.GetBitmap(var tmpBitmap: TBitmap; tmpNum: Integer);
var
  path: string;
begin
  if tmpNum = 0 then
  begin
    path := RESOURCEPATH + '\BackGround\' +
      IntToStr(ColorToNum(GBackGroundColor)) + '.bmp';
  end
  else
    path := RESOURCEPATH + GPath + IntToStr(tmpNum) + '.bmp';
  if tmpBitmap <> nil then
    tmpBitmap.Free;
  tmpBitmap := TBitmap.Create;
  tmpBitmap.LoadFromFile(path);
end;

function TMainForm.GetMusic: string;
var
  num: Integer;
  s: string;
begin
  num := random(MUSICNUM) + 1;
  s := RESOURCEPATH + '\midi\music' + IntToStr(num) + '.mid';
  result := s;
end;

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
  res: boolean;
begin
  p.X := XToI(X);
  p.Y := YToJ(Y);
  if data[p.X, p.Y] = 0 then
    exit;
  if StackIsEmpty() then
  begin
    p.X := XToI(X);
    p.Y := YToJ(Y);
    Push(p);
    PlaySound('Select');
    SetSelected(p.X, p.Y);
  end
  else
  begin
    p.X := XToI(X);
    p.Y := YToJ(Y);
    if (p.X = GetTop().X) and (p.Y = GetTop().Y) then
      exit;
    SetSelected(p.X, p.Y);
    if data[GetTop().X, GetTop().Y] <> data[p.X, p.Y] then
    begin
      PlaySound('NotTheSame');
      ResetSelected(p.X, p.Y);
      ResetSelected(GetTop().X, GetTop().Y);
      MainPaintBoxPaint(Sender);
      pop();
      exit;
    end
    else
      res := Compare(GetTop(), p);
    if GModeDebug then
      res := true;
    if res then
    begin
      PlaySound('Delete');
      if bIntersect then
      begin
        DrawLine(ShareLine, 3, true);
        Sleep(SLEEPTIME);
        DrawLine(ShareLine, 3, false);
      end
      else if bNear or bDirect then
      begin
        DrawLine(ShareLine, 2, true);
        Sleep(SLEEPTIME);
        DrawLine(ShareLine, 2, false);
      end
      else if bOther then
      begin
        DrawLine(ShareLine, 4, true);
        Sleep(SLEEPTIME);
        DrawLine(ShareLine, 4, false);
      end;
      Dark(p.X, p.Y);
      Dark(GetTop().X, GetTop().Y);
      pop();
      Inc(GTime, 3);
      if GTime > TOTALTIME then
        GTime := TOTALTIME;
      DrawGameTime();
      if GameCheck() then
      begin
        TimerGameDelay.Enabled := false;
        if GChangeType <> ARRANGETYPE10 then
        begin
          if not TimerAutoPlay.Enabled then
            MessageBox(Self.Handle, '过关!', '信息', MB_OK);
          Inc(GChangeType);
          Inc(GLife, 2);
          Inc(GHint, 3);
          GChangeType := TArrangeType(GChangeType);
          GameContinue();
          exit;
        end
        else
        begin
          PlaySound('GameWin');
          MessageBox(Self.Handle, '通关!', '信息', MB_OK);
          GChangeType := TArrangeType(0);
          GameStart();
          exit;
        end;
      end
      else
      begin
        ReArrangeData(GChangeType);
        MainPaintBoxPaint(Sender);
        if not GetHint(GHintA, GHintB) then
        begin
          GHintA.X := 0;
          GHintA.Y := 0;
          GHintB.X := 0;
          GHintB.Y := 0;
          if GLife <= 0 then
          begin
            GameOver();
            GLife := 0;
            PlaySound('GameOver');
            MessageBox(MainForm.Handle, '游戏结束!', '信息',
              MB_OK or MB_ICONINFORMATION);
            exit;
          end;
          MenuOptionRearrangeClick(Sender);
        end;
      end;
    end
    else
    begin
      PlaySound('Reset');
      ResetSelected(p.X, p.Y);
      ResetSelected(GetTop().X, GetTop().Y);
      MainPaintBoxPaint(Sender);
      pop();
    end;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
begin
  if GGameRunning then
  begin
    ShowArray();
    DrawGameRunningData();
    FormResize(Sender);
    DrawGameTime();
  end
  else
    DrawStartBitmap();
end;

end.
