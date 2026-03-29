object MonacoBrowserForm: TMonacoBrowserForm
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  ClientHeight = 324
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BrowserWindow: TWVWindowParent
    Left = 0
    Top = 0
    Width = 461
    Height = 324
    Align = alClient
    TabOrder = 0
    Browser = Browser
  end
  object BrowserTimer: TTimer
    Enabled = False
    Interval = 300
    Left = 136
    Top = 32
  end
  object Browser: TWVBrowser
    TargetCompatibleBrowserVersion = '146.0.3856.49'
    AllowSingleSignOnUsingOSPrimaryAccount = False
    OnAfterCreated = BrowserAfterCreated
    OnNavigationCompleted = BrowserNavigationCompleted
    OnNewWindowRequested = BrowserNewWindowRequested
    OnPermissionRequested = BrowserPermissionRequested
    OnWebMessageReceived = BrowserWebMessageReceived
    Left = 48
    Top = 32
  end
end
