object Form2: TForm2
  Left = 321
  Top = 199
  BorderStyle = bsSingle
  Caption = #1058#1077#1090#1088#1048#1057#1058
  ClientHeight = 545
  ClientWidth = 386
  Color = clInfoBk
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 8
    Top = 8
    Width = 250
    Height = 500
  end
  object PaintBox2: TPaintBox
    Left = 272
    Top = 8
    Width = 100
    Height = 126
  end
  object Label1: TLabel
    Left = 272
    Top = 179
    Width = 100
    Height = 30
    AutoSize = False
    Caption = #1059#1088#1086#1074#1077#1085#1100':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 272
    Top = 259
    Width = 100
    Height = 30
    AutoSize = False
    Caption = #1041#1072#1083#1083#1099':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 272
    Top = 231
    Width = 100
    Height = 18
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 272
    Top = 311
    Width = 100
    Height = 18
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 400
    OnTimer = Timer1Timer
    Left = 264
    Top = 472
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 432
    object N1: TMenuItem
      Caption = #1048#1075#1088#1072
      object N2: TMenuItem
        Caption = #1053#1086#1074#1072#1103
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
        Enabled = False
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = #1055#1072#1091#1079#1072
        Enabled = False
        OnClick = N4Click
      end
    end
    object N5: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N6: TMenuItem
        Caption = #1055#1086#1084#1086#1097#1100
        OnClick = N6Click
      end
      object N7: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N7Click
      end
    end
  end
end
