object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = 'Amazon - S3'
  ClientHeight = 315
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 315
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 80
    ExplicitWidth = 559
    ExplicitHeight = 235
    object EdtUrl: TEdit
      Left = 0
      Top = 294
      Width = 742
      Height = 21
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 0
      ExplicitWidth = 559
    end
    object pnlArquivos: TPanel
      Left = 185
      Top = 0
      Width = 557
      Height = 294
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 472
      object lsbArquivos: TListBox
        Left = 0
        Top = 0
        Width = 557
        Height = 194
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lsbArquivosClick
        ExplicitWidth = 472
        ExplicitHeight = 121
      end
      object bttListarArquivos: TButton
        Left = 0
        Top = 269
        Width = 557
        Height = 25
        Align = alBottom
        Caption = 'Listar Arquivos'
        TabOrder = 1
        OnClick = bttListarArquivosClick
        ExplicitLeft = 6
        ExplicitTop = 263
      end
      object bttDownLoad: TButton
        Left = 0
        Top = 219
        Width = 557
        Height = 25
        Align = alBottom
        Caption = 'DownLoad'
        TabOrder = 2
        OnClick = bttDownLoadClick
        ExplicitLeft = 6
        ExplicitTop = 213
      end
      object bttUpLoad: TButton
        Left = 0
        Top = 244
        Width = 557
        Height = 25
        Align = alBottom
        Caption = 'UpLoad'
        TabOrder = 3
        OnClick = bttUpLoadClick
        ExplicitLeft = 6
        ExplicitTop = 238
      end
      object bttExcluir: TButton
        Left = 0
        Top = 194
        Width = 557
        Height = 25
        Align = alBottom
        Caption = 'Excluir'
        TabOrder = 4
        OnClick = bttExcluirClick
        ExplicitTop = 188
      end
    end
    object pnlBuckets: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 294
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 21
      object lsbBuckets: TListBox
        Left = 0
        Top = 0
        Width = 185
        Height = 219
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lsbBucketsClick
        ExplicitHeight = 153
      end
      object bttListarBuckets: TButton
        Left = 0
        Top = 269
        Width = 185
        Height = 25
        Align = alBottom
        Caption = 'Listar Buckets'
        TabOrder = 1
        OnClick = bttListarBucketsClick
        ExplicitLeft = -6
        ExplicitTop = 275
      end
      object bttCriarBucket: TButton
        Left = 0
        Top = 244
        Width = 185
        Height = 25
        Align = alBottom
        Caption = 'Criar Bucket'
        TabOrder = 2
        OnClick = bttCriarBucketClick
        ExplicitLeft = -6
        ExplicitTop = 238
      end
      object bttExcluirBucket: TButton
        Left = 0
        Top = 219
        Width = 185
        Height = 25
        Align = alBottom
        Caption = 'Excluir Bucket'
        TabOrder = 3
        OnClick = bttExcluirBucketClick
        ExplicitLeft = 48
        ExplicitTop = 200
        ExplicitWidth = 75
      end
    end
  end
  object amcConnectionInfo: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Region = amzrSAEast1
    UseDefaultEndpoints = False
    Left = 240
    Top = 40
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 336
    Top = 56
  end
  object OpenDialog: TOpenDialog
    Left = 249
    Top = 129
  end
end
