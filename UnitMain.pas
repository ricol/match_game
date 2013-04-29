unit UnitMain;

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, StdCtrls, MPlayer, UnitData, UnitShare, UnitStack, MMSystem,
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
    procedure Draw(i, j: integer; num: integer);
    procedure Dark(i, j: integer);
    procedure GetBitmap(var tmpBitmap: TBitmap; tmpNum: integer);
    procedure DrawLine(tmpData: TLine; tmpNum: integer; tmpFlag: boolean);
    procedure SetSelected(tmpX, tmpY: integer);
    procedure ResetSelected(tmpX, tmpY: integer);
    function GetMusic(): string;
    procedure PlaySound(tmpSound: string);
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
  RESOURCEPATH = '.\��Դ';
  TEXTSTART = 50;
  TOTALTIME = 100;
  TEXTSPACE = 70;
  TEXTHEIGHT = 10;
  GAMETIMESPACE = 50;

var
  GBitMap: TBitmap = nil;
  GBitMapNumber: integer = 1;
  GBkGroundNumber: integer = 1;
  GPath: string = '\pic1\';
  GGame: TGameLevel = GAMELEVELLOW;
  GBackGroundColor: TColor = clBlack;
  GHintA, GHintB: TPoint;
  GChangeType: TArrangeType = ARRANGETYPE0;
  GGameRunning: boolean = false;
  GBackGroundImage: TImage = nil;
  GLife: integer = 2;
  GHint: integer = 4;
  GTime: integer = TOTALTIME;
  GModeDebug: boolean = false;

procedure TMainForm.MenuAutoPlayClick(Sender: TObject);
begin
  if not GGameRunning then exit;
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
  s := '����   - ������' + sLineBreak +
    '������ - RICOL' + sLineBreak +
    '�汾   - V4.0' + sLineBreak +
    '��ϵ   - WANGXINGHE1983@GMAIL.COM';
  MessageBox(Self.Handle, PChar(s), '����', MB_OK);
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
  tmpS: string;
begin
  if not GGameRunning then exit;
  try
    tmpS := InputBox('����', '�����뱳����ɫ���(1 - ' + IntToStr(COLORNUM) + '): ', IntToStr(GBkGroundNumber));
  except
    tmpS := IntToStr(GBkGroundNumber);
  end;
  if (StrToInt(tmpS) < 1) or (StrToInt(tmpS) > COLORNUM) then
    tmpS := IntToStr(GBkGroundNumber);
  GBkGroundNumber := StrToInt(tmpS);
  GBackGroundColor := GetColor(GBkGroundNumber);
  PanelMain.Color := GBackGroundColor;
  MainPaintBoxPaint(Sender);
end;

procedure TMainForm.MenuOptionBitmapClick(Sender: TObject);
var
  tmpS: string;
begin
  if not GGameRunning then exit;
  try
    tmpS := InputBox('����', '������ͼ�����(1 - ' + IntToStr(BITMAPNUM) + '): ', IntToStr(GBitMapNumber));
  except
    tmpS := IntToStr(GBitMapNumber);
  end;
  if (StrToInt(tmpS) < 1) or (StrToInt(tmpS) > BITMAPNUM) then
    tmpS := IntToStr(GBitMapNumber);
  GBitMapNumber := StrToInt(tmpS);
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
  if not GGameRunning then exit;
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
  MessageBox(Self.Handle, '�˹�����ʱû�м���.', '��Ϣ', MB_OK or MB_ICONINFORMATION);
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

procedure TMainForm.PlaySound(tmpSound: string);
begin
  if tmpSound <> 'NULL' then
  begin
    if MainForm.MenuOptionSound.Checked then
      sndPlaySound(PChar(RESOURCEPATH + '\Sound\' + tmpSound + '.wav'), SND_ASYNC);
  end
  else
    sndPlaySound(nil, SND_ASYNC);
end;

procedure TMainForm.ResetSelected(tmpX, tmpY: integer);
var
  Num: integer;
begin
  Num := data[tmpX, tmpY];
  GetBitmap(GBitmap, Num);
  MainPaintBox.Canvas.Draw(IToX(tmpX), JToY(tmpY), GBitmap);
end;

procedure TMainForm.SetSelected(tmpX, tmpY: integer);
var
  Num: integer;
begin
  Num := data[tmpX, tmpY];
  GetBitmap(GBitmap, 0);
  MainPaintBox.Canvas.Draw(IToX(tmpX), JToY(tmpY), GBitmap);
  GetBitmap(GBitmap, Num);
  MainPaintBox.Canvas.Draw(IToX(tmpX), JToY(tmpY), GBitmap, OPACITY);
end;

procedure TMainForm.ShowArray;
var
  i, j: integer;
begin
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
      Draw(i, j, data[i][j]);
end;

procedure TMainForm.MenuOptionGetHintClick(Sender: TObject);
begin
  if not GGameRunning then exit;
  if GHint > 0 then
    Dec(GHint)
  else
    exit;
  MainPaintBoxPaint(Sender);
  if (GHintA.X <> 0) and (GHintA.Y <> 0) and (GHintB.X <> 0) and (GHintB.Y <> 0) then
  begin
    SetSelected(GHintA.X, GHintA.Y);
    SetSelected(GHintB.X, GHintB.Y);
  end
  else
    MessageBox(Self.Handle, '��Ҫ��ʣ�µĿ�Ƭ�������ţ�', '��Ϣ', MB_OK);
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
  tmpA, tmpB: TPoint;
  tmpAX, tmpAY, tmpBX, tmpBY: integer;
  tmpShiftState: TShiftState;
begin
  if not GGameRunning then
  begin
    TimerAutoPlay.Enabled := false;
    exit;
  end;
  if not GetHint(tmpA, tmpB) then exit;
  tmpAX := IToX(tmpA.X);
  tmpAY := JToY(tmpA.Y);
  tmpBX := IToX(tmpB.X);
  tmpBY := JToY(tmpB.Y);
  MainPaintBoxMouseDown(Sender, mbLeft, tmpShiftState, tmpAX, tmpAY);
  Sleep(MYSLEEPTIME);
  MainPaintBoxMouseDown(Sender, mbLeft, tmpShiftState, tmpBX, tmpBY);
  Sleep(MYSLEEPTIME);
end;

procedure TMainForm.TimerGameDelayTimer(Sender: TObject);
begin
  dec(GTime);
  DrawGameTime();
  if GTime <= 0 then
  begin
    TimerGameDelay.Enabled := false;
    MessageBox(MainForm.Handle, '��Ϸ����!', '��Ϣ', MB_OK or MB_ICONINFORMATION);
    GameOver();
    exit;
  end;
end;

procedure TMainForm.ApplicationEvents1Minimize(Sender: TObject);
begin
  if not GGameRunning then exit;
  TimerGameDelay.Enabled := false;
  Beep();
  Application.Title := strCAPTION + ' - ��ͣ';
end;

procedure TMainForm.ApplicationEvents1Restore(Sender: TObject);
begin
  if not GGameRunning then exit;
  TimerGameDelay.Enabled := true;
  Beep;
  Application.Title := strCAPTION;
end;

procedure TMainForm.Dark(i, j: integer);
begin
  data[i][j] := 0;
  Draw(i, j, 0);
end;

procedure TMainForm.Draw(i, j, num: integer);
begin
  GetBitmap(GBitmap, num);
  MainForm.MainPaintBox.Canvas.Draw(IToX(i), JToY(j), GBitMap);
end;

procedure TMainForm.DrawGameRunningData;
begin
  if not GGameRunning then exit;
  with MainPaintBox do
  begin
    Canvas.Font.Color := clYellow;
    Canvas.Font.Size := 10;
    SetBkColor(Canvas.Handle, GBackGroundColor);
    Canvas.TextOut(TEXTSTART, TEXTHEIGHT, '�Ѷȣ�                 ');
    Canvas.TextOut(TEXTSTART, TEXTHEIGHT, '�Ѷȣ�' + GetStringFromGameLevel(GGame));
    Canvas.TextOut(TEXTSTART + TEXTSPACE + 20, TEXTHEIGHT, '�ؿ���                         ');
    Canvas.TextOut(TEXTSTART + TEXTSPACE + 20, TEXTHEIGHT, '�ؿ���' + GetStringFromArrangeType(GChangeType));
    Canvas.TextOut(TEXTSTART + 3 * TEXTSPACE, TEXTHEIGHT, '������     ');
    Canvas.TextOut(TEXTSTART + 3 * TEXTSPACE, TEXTHEIGHT, '������' + IntToStr(GLife));
    Canvas.TextOut(TEXTSTART + 4 * TEXTSPACE, TEXTHEIGHT, '��ʾ��     ');
    Canvas.TextOut(TEXTSTART + 4 * TEXTSPACE, TEXTHEIGHT, '��ʾ��' + IntToStr(GHint));
    Canvas.TextOut(TEXTSTART + 5 * TEXTSPACE, TEXTHEIGHT, 'ʱ�䣺');
  end;
end;

procedure TMainForm.DrawGameTime;
begin
  with MainPaintBox do
  begin
    Canvas.Pen.Color := clYellow;
    Canvas.Brush.Color := GBackGroundColor;
    Canvas.Pen.Width := 1;
    Canvas.Rectangle(TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE, TEXTHEIGHT, TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + TOTALTIME * (integer(GGame) + 1), TEXTHEIGHT + 20);
    Canvas.Pen.Color := clRed;
    Canvas.Brush.Color := clRed;
    Canvas.Rectangle(TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + 1, TEXTHEIGHT + 1, TEXTSTART + 5 * TEXTSPACE + GAMETIMESPACE + GTime * (integer(GGame) + 1) - 1, TEXTHEIGHT + 20 - 1);
  end;
end;

procedure TMainForm.DrawLine(tmpData: TLine; tmpNum: integer;
  tmpFlag: boolean);
begin
  if tmpFlag then
  begin
    with MainForm.MainPaintBox do
    begin
      Canvas.Pen.Color := clRed;
      Canvas.Pen.Width := 5;
      if tmpNum = 3 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].X) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].X) + R div 2, JToY(tmpData[2].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[3].X) + R div 2, JToY(tmpData[3].Y) + R div 2);
      end
      else if tmpNum = 2 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].X) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].X) + R div 2, JToY(tmpData[2].Y) + R div 2);
      end
      else if tmpNum = 4 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].x) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[4].x) + R div 2, JToY(tmpData[4].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[3].x) + R div 2, JToY(tmpData[3].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].x) + R div 2, JToY(tmpData[2].Y) + R div 2);
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
      if tmpNum = 3 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].X) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].X) + R div 2, JToY(tmpData[2].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[3].X) + R div 2, JToY(tmpData[3].Y) + R div 2);
      end
      else if tmpNum = 2 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].X) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].X) + R div 2, JToY(tmpData[2].Y) + R div 2);
      end
      else if tmpNum = 4 then
      begin
        Canvas.MoveTo(IToX(tmpData[1].x) + R div 2, JToY(tmpData[1].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[4].x) + R div 2, JToY(tmpData[4].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[3].x) + R div 2, JToY(tmpData[3].Y) + R div 2);
        Canvas.LineTo(IToX(tmpData[2].x) + R div 2, JToY(tmpData[2].Y) + R div 2);
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
    GBackGroundImage.Picture.Bitmap.LoadFromFile(RESOURCEPATH + '\BackGround\Start.bmp');
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PanelMain.Color := clBlack;
  DrawStartBitmap();
  GBitmap := TBitmap.Create;
  randomize;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if GBitmap <> nil then
  begin
    GBitmap.Free;
    GBitmap := nil;
  end;
  if GBackGroundImage <> nil then
  begin
    GBackGroundImage.Free;
    GBackGroundImage := nil;
  end;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
//  else if Key = VK_RETURN then
//    SetGamePause(true);
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
  i, j: integer;
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
    y := 9;
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

procedure TMainForm.GetBitmap(var tmpBitmap: TBitmap; tmpNum: integer);
var
  path: string;
begin
  if tmpNum = 0 then
  begin
    path := RESOURCEPATH + '\BackGround\' + IntToStr(ColorToNum(GBackGroundColor)) + '.bmp';
  end
  else
    path := RESOURCEPATH + GPath + IntToStr(tmpNum) + '.bmp';
  if tmpBitmap <> nil then tmpBitmap.Free;
  tmpBitmap := TBitmap.Create;
  tmpBitmap.LoadFromFile(path);
end;

function TMainForm.GetMusic: string;
var
  tmpNum: integer;
  tmpS: string;
begin
  tmpNum := random(MUSICNUM) + 1;
  tmpS := RESOURCEPATH + '\midi\music' + IntToStr(tmpNum) + '.mid';
  result := tmpS;
end;

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  temp: TPoint;
  tempResult: boolean;
begin
  temp.X := XToI(X);
  temp.Y := YToJ(Y);
  if data[temp.X, temp.Y] = 0 then exit;
  if StackIsEmpty() then
  begin
    temp.x := XToI(X);
    temp.y := YToJ(Y);
    Push(temp);
    PlaySound('Select');
    SetSelected(temp.X, temp.Y);
  end
  else
  begin
    temp.x := XToi(X);
    temp.y := YToj(Y);
    if (temp.x = GetTop().x) and (temp.y = GetTop().y) then exit;
    SetSelected(temp.X, temp.Y);
    if data[GetTop().X, GetTop().Y] <> data[temp.X, temp.Y] then
    begin
      PlaySound('NotTheSame');
      ResetSelected(temp.X, temp.Y);
      ResetSelected(GetTop().X, GetTop().Y);
      MainPaintBoxPaint(Sender);
      pop();
      exit;
    end
    else
      tempResult := Compare(GetTop(), temp);
    if GModeDebug then
      tempResult := true;
    if tempResult then
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
      Dark(temp.x, temp.y);
      Dark(GetTop().x, GetTop().y);
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
            MessageBox(Self.Handle, '����!', '��Ϣ', MB_OK);
          inc(GChangeType);
          inc(GLife, 2);
          inc(GHint, 3);
          GChangeType := TArrangeType(GChangeType);
          GameContinue();
          exit;
        end
        else
        begin
          PlaySound('GameWin');
          MessageBox(Self.Handle, 'ͨ��!', '��Ϣ', MB_OK);
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
            MessageBox(MainForm.Handle, '��Ϸ����!', '��Ϣ', MB_OK or MB_ICONINFORMATION);
            exit;
          end;
          MenuOptionRearrangeClick(Sender);
        end;
      end;
    end
    else
    begin
      PlaySound('Reset');
      ResetSelected(temp.X, temp.Y);
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
