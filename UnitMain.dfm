object MainForm: TMainForm
  Left = 151
  Top = 172
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #36830#36830#30475' - RICOL '#21046#20316
  ClientHeight = 430
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 600
    Height = 430
    Align = alClient
    BevelOuter = bvLowered
    Color = clBlack
    ParentBackground = False
    TabOrder = 0
    object MainPaintBox: TPaintBox
      Left = 1
      Top = 1
      Width = 598
      Height = 428
      Align = alClient
      Color = clBlack
      ParentColor = False
      OnMouseDown = MainPaintBoxMouseDown
      OnPaint = MainPaintBoxPaint
      ExplicitLeft = 0
      ExplicitTop = 2
    end
  end
  object MediaPlayer1: TMediaPlayer
    Left = 8
    Top = 26
    Width = 253
    Height = 30
    Visible = False
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 312
    Top = 64
    object MenuGame: TMenuItem
      AutoHotkeys = maManual
      Caption = #28216#25103
      object MenuGameLow: TMenuItem
        AutoCheck = True
        AutoHotkeys = maAutomatic
        Caption = #21021#32423' - F1'
        Checked = True
        RadioItem = True
        OnClick = MenuGameLowClick
      end
      object MenuGameMedium: TMenuItem
        AutoCheck = True
        Caption = #20013#32423' - F2'
        RadioItem = True
        OnClick = MenuGameMediumClick
      end
      object MenuGameHigh: TMenuItem
        AutoCheck = True
        Caption = #39640#32423' - F3'
        RadioItem = True
        OnClick = MenuGameHighClick
      end
      object MenuGameSpecial: TMenuItem
        AutoCheck = True
        Caption = #29305#32423' - F4'
        RadioItem = True
        OnClick = MenuGameSpecialClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object MenuGamePause: TMenuItem
        Caption = #26242#20572' - F8'
        OnClick = MenuGamePauseClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MenuGameAbandon: TMenuItem
        Caption = #25918#24323' - ESC'
        Enabled = False
        OnClick = MenuGameAbandonClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MenuTop: TMenuItem
        Caption = #25490#34892#27036
        OnClick = MenuTopClick
      end
      object MenuGameSeperator: TMenuItem
        Caption = '-'
      end
      object MenuGameExit: TMenuItem
        Caption = #36864#20986
        OnClick = MenuGameExitClick
      end
    end
    object N1: TMenuItem
      AutoHotkeys = maManual
      Caption = #36873#39033
      object MenuOptionGetHint: TMenuItem
        Caption = #25552#31034' - F5'
        Enabled = False
        OnClick = MenuOptionGetHintClick
      end
      object MenuOptionRearrange: TMenuItem
        Caption = #37325#25490' - F6'
        Enabled = False
        OnClick = MenuOptionRearrangeClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MenuOptionBitmap: TMenuItem
        Caption = #22270#26696
        Enabled = False
        OnClick = MenuOptionBitmapClick
      end
      object MenuOptionSound: TMenuItem
        Caption = #38899#25928
        Checked = True
        OnClick = MenuOptionSoundClick
      end
      object MenuOptionMusic: TMenuItem
        Caption = #38899#20048
        OnClick = MenuOptionMusicClick
      end
      object MenuOptionBackGround: TMenuItem
        Caption = #32972#26223
        Enabled = False
        OnClick = MenuOptionBackGroundClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MenuChange: TMenuItem
        Caption = #21464#21270
        Enabled = False
        object MenuNoChange: TMenuItem
          AutoCheck = True
          Caption = #22266#23450
          Checked = True
          RadioItem = True
          OnClick = MenuNoChangeClick
        end
        object MenuToDown: TMenuItem
          AutoCheck = True
          Caption = #21521#19979
          RadioItem = True
          OnClick = MenuToDownClick
        end
        object MenuToLeft: TMenuItem
          AutoCheck = True
          Caption = #21521#24038
          RadioItem = True
          OnClick = MenuToLeftClick
        end
        object MenuUpDownSeperate: TMenuItem
          AutoCheck = True
          Caption = #19978#19979#20998#31163
          RadioItem = True
          OnClick = MenuUpDownSeperateClick
        end
        object MenuLeftRightSeperate: TMenuItem
          AutoCheck = True
          Caption = #24038#21491#20998#31163
          RadioItem = True
          OnClick = MenuLeftRightSeperateClick
        end
        object MenuUpDownCollect: TMenuItem
          AutoCheck = True
          Caption = #19978#19979#38598#20013
          RadioItem = True
          OnClick = MenuUpDownCollectClick
        end
        object MenuLeftRightCollect: TMenuItem
          AutoCheck = True
          Caption = #24038#21491#38598#20013
          RadioItem = True
          OnClick = MenuLeftRightCollectClick
        end
        object MenuLeftUpRightDown: TMenuItem
          AutoCheck = True
          Caption = #19978#24038#19979#21491
          RadioItem = True
          OnClick = MenuLeftUpRightDownClick
        end
        object MenuLeftDownRightUp: TMenuItem
          AutoCheck = True
          Caption = #24038#19979#21491#19978
          RadioItem = True
          OnClick = MenuLeftDownRightUpClick
        end
        object MenuUpDownLeftRightSeperate: TMenuItem
          AutoCheck = True
          Caption = #21521#22806#25193#25955
          RadioItem = True
          OnClick = MenuUpDownLeftRightSeperateClick
        end
        object MenuUpDownLeftRightCollect: TMenuItem
          AutoCheck = True
          Caption = #21521#20869#38598#20013
          RadioItem = True
          OnClick = MenuUpDownLeftRightCollectClick
        end
      end
    end
    object MenuHelp: TMenuItem
      AutoHotkeys = maManual
      Caption = #24110#21161
      object MenuGameAbout: TMenuItem
        Caption = #20851#20110#36830#36830#30475
        OnClick = MenuGameAboutClick
      end
      object MenuAutoPlay: TMenuItem
        Caption = #33258#21160#25805#20316' - F7'
        Enabled = False
        OnClick = MenuAutoPlayClick
      end
    end
  end
  object TimerGuard: TTimer
    Enabled = False
    OnTimer = TimerGuardTimer
    Left = 248
    Top = 64
  end
  object TimerAutoPlay: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerAutoPlayTimer
    Left = 96
    Top = 64
  end
  object TimerGameDelay: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = TimerGameDelayTimer
    Left = 168
    Top = 64
  end
  object ApplicationEvents1: TApplicationEvents
    OnMinimize = ApplicationEvents1Minimize
    OnRestore = ApplicationEvents1Restore
    Left = 24
    Top = 64
  end
end
