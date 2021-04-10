unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,SysTem.UiTypes,
  dxGDIPlusClasses, Vcl.ExtCtrls, Vcl.StdCtrls, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI, Vcl.ExtDlgs, Vcl.FileCtrl;

type
  TFrmMain = class(TForm)
    pnlMain: TPanel;
    EdtUrl: TEdit;
    amcConnectionInfo: TAmazonConnectionInfo;
    OpenPictureDialog: TOpenPictureDialog;
    pnlArquivos: TPanel;
    lsbArquivos: TListBox;
    bttListarArquivos: TButton;
    pnlBuckets: TPanel;
    lsbBuckets: TListBox;
    bttListarBuckets: TButton;
    bttCriarBucket: TButton;
    OpenDialog: TOpenDialog;
    bttDownLoad: TButton;
    bttUpLoad: TButton;
    bttExcluir: TButton;
    bttExcluirBucket: TButton;
    procedure bttUpLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bttListarBucketsClick(Sender: TObject);
    procedure bttListarArquivosClick(Sender: TObject);
    procedure bttDownLoadClick(Sender: TObject);
    procedure bttExcluirClick(Sender: TObject);
    procedure bttCriarBucketClick(Sender: TObject);
    procedure bttExcluirBucketClick(Sender: TObject);
    procedure lsbBucketsClick(Sender: TObject);
    procedure lsbArquivosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FStorageService : TAmazonStorageService;
    FBucket : String;
    FArquivo : String;
  public
    { Public declarations }

  end;

  const
  AccountKey =  '';
  AccountName = '';
  StorageEndPoint = 's3-sa-east-1.amazonaws.com';

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.bttUpLoadClick(Sender: TObject);
var
  lFileName : String;
  lCloudResponseInfo: TCloudResponseInfo;
  lHeaders,lMetaData : TStringList;
  lStream : TBytesStream;
  lExt : String;
begin
  if(FBucket <> EmptyStr) then
  begin
    if(OpenDialog.Execute) then
    begin
      lFileName := ExtractFileName(OpenDialog.FileName);
      lExt := LowerCase(ExtractFileExt(lFileName));
      lCloudResponseInfo := TCloudResponseInfo.Create;
      lStream := TBytesStream.Create;
      lStream.LoadFromFile(OpenDialog.FileName);
      lMetaData := TStringList.Create;
      lMetaData.Values['exemplo'] := 'posso mandar qualquer coisa aqui';

      lHeaders := TStringList.Create;

      if(lExt = '.xml') then
      begin
        lHeaders.Values['Content-Type'] := 'text/xml';
      end
      else
      if(lExt = '.pdf') then
      begin
        lHeaders.Values['Content-Type'] := 'application/pdf';
      end
      else   //TRATAR OUTROS TIPOS AQUI
      begin
        lHeaders.Values['Content-Type'] := 'image/jpeg';
      end;


      try
        try
          if( FStorageService.UploadObject(FBucket,
                                      lFileName,
                                      lStream.Bytes,
                                      True,
                                      lMetaData,
                                      lHeaders,
                                      amzbaPublicRead,
                                      lCloudResponseInfo) ) then
          begin
            ShowMessage('Arquivo Enviado!!!');
            EdtUrl.Text := 'https://' + FBucket+'.'+StorageEndPoint+'/'+lFileName;
          end
          else
          begin
            ShowMessage('ERRO: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
          end;
        except
          on E: Exception do
            ShowMessage(E.Message);
        end;
      finally
        lHeaders.Free;
        lMetaData.Free;
        lStream.Free;
        lCloudResponseInfo.Free;
      end;
    end;
  end
  else
  begin
    ShowMessage('Ops! Selecione um Bucket.');
  end;
end;

procedure TFrmMain.bttExcluirBucketClick(Sender: TObject);
var
  lCloudResponseInfo: TCloudResponseInfo;
begin
  if(FBucket <> EmptyStr) then
  begin
    if( MessageDlg('Deseja excluir o Bucket ' + FBucket +'?',mtInformation,[mbYes,mbNo],0) = mrYes) then
    begin

       lCloudResponseInfo := TCloudResponseInfo.Create;
      try
        try
          if(FStorageService.DeleteBucket(FBucket,lCloudResponseInfo)) then
          begin
            ShowMessage('SUCESSO!');
          end
          else
          begin
            ShowMessage('Erro: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
          end;
        except
          on E: Exception do
          begin
            ShowMessage(e.Message);
          end;
        end;
      finally
        FreeAndNil(lCloudResponseInfo);
        FBucket := EmptyStr;
      end;
    end;
  end
  else
  begin
    ShowMessage('Ops! Selecione um Bucket.');
  end;
end;

procedure TFrmMain.bttCriarBucketClick(Sender: TObject);
var
  lCloudResponseInfo: TCloudResponseInfo;
begin
  lCloudResponseInfo := TCloudResponseInfo.Create;
  try
    try
      if(FStorageService.CreateBucket(IntToStr(Random(999999)),
                                    TAmazonACLType.amzbaPublicReadWrite,
                                    TAmazonRegion.amzrSAEast1,
                                    lCloudResponseInfo) ) then
      begin
        ShowMessage('SUCESSO!');
      end
      else
      begin
        ShowMessage('Erro: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
      end;

    except
      on E: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
  finally
    FreeAndNil(lCloudResponseInfo);
  end;
end;

procedure TFrmMain.bttDownLoadClick(Sender: TObject);
var
  lDir : String;
  lCloudResponseInfo: TCloudResponseInfo;
  lStream : TBytesStream;
begin
  if(FArquivo <> EmptyStr) then
  begin
    lStream := TBytesStream.Create;
    lCloudResponseInfo := TCloudResponseInfo.Create;
    try
      try
        if( FStorageService.GetObject(FBucket,
                                    FArquivo,
                                    lStream,
                                    lCloudResponseInfo) ) then
        begin
          lDir := ExtractFilePath(ParamStr(0));
          if(SelectDirectory('Salvar em: ', 'C:\',lDir)) then
          begin
            TMemoryStream(lStream).SaveToFile(lDir+PathDelim+FArquivo);
            ShowMessage('SUCESSO!');
          end;
        end
        else
        begin
          ShowMessage('ERRO: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
        end;
      except
        on E: Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
    finally
      lStream.Free;
      lCloudResponseInfo.Free;
      FArquivo := EmptyStr;
    end;
  end
  else
  begin
    ShowMessage('Ops! Selecione um arquivo.');
  end;
end;

procedure TFrmMain.bttExcluirClick(Sender: TObject);
var
 lCloudResponseInfo: TCloudResponseInfo;
begin
  if(FArquivo <> EmptyStr) then
  begin
    if( MessageDlg('Deseja excluir o arquivo ' + FArquivo+'?',mtInformation,[mbYes,mbNo],0) = mrYes) then
    begin
      lCloudResponseInfo := TCloudResponseInfo.Create;
      try
        try
          if( FStorageService.DeleteObject(lsbBuckets.Items[lsbBuckets.ItemIndex],FArquivo,lCloudResponseInfo) ) then
          begin
            ShowMessage('SUCESSO!');
          end
          else
          begin
            ShowMessage('ERRO: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
          end;
        except
          on E: Exception do
          begin
           ShowMessage(e.Message);
          end;
        end;
      finally
        FreeAndNil(lCloudResponseInfo);
      end;
    end;
  end
  else
  begin
    ShowMessage('Ops! Selecione um arquivo.');
  end;
end;

procedure TFrmMain.bttListarArquivosClick(Sender: TObject);
var
  lBucketResult : TAmazonBucketResult;
  lObjectResult: TAmazonObjectResult;
  lCloudResponseInfo: TCloudResponseInfo;
begin
  if(FBucket <> EmptyStr) then
  begin
    lCloudResponseInfo := TCloudResponseInfo.Create;

    try
      try
        lsbArquivos.Items.Clear;
        lBucketResult := FStorageService.GetBucket(FBucket,nil,lCloudResponseInfo);
        if(lCloudResponseInfo.StatusCode = 200) then
        begin
          for lObjectResult in lBucketResult.Objects do
          begin
            lsbArquivos.Items.Add(lObjectResult.Name);
          end;
          ShowMessage('SUCESSO!');
        end
        else
        begin
          ShowMessage('Erro: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
        end;
      except on
        E: Exception do
        begin
          ShowMessage(e.Message);
        end;
      end;
    finally
      FreeAndNil(lCloudResponseInfo);
      FreeAndNil(lBucketResult);
    end;
  end
  else
  begin
    ShowMessage('Ops! Selecione um Bucket.');
  end;
end;

procedure TFrmMain.bttListarBucketsClick(Sender: TObject);
var
  lCloudResponseInfo: TCloudResponseInfo;
  lBuckets : TStrings;
  I : Integer;
begin
  lCloudResponseInfo := TCloudResponseInfo.Create;

  try
    try
      lsbBuckets.Items.Clear;
      lBuckets := FStorageService.ListBuckets(lCloudResponseInfo);
      if(lCloudResponseInfo.StatusCode = 200) then
      begin
        if(lBuckets.Count) > 0 then
        begin
          for I := 0 to Pred(lBuckets.Count) do
          begin
            lsbBuckets.Items.Add(lBuckets.Names[I]);
          end;
        end
        else
        begin
          ShowMessage('Nenhum Bucket encontrado.');
        end;
      end
      else
      begin
        ShowMessage('Erro: ' + lCloudResponseInfo.StatusCode.ToString + ' ' + lCloudResponseInfo.StatusMessage);
      end;
    except on
      E: Exception do
      begin
        ShowMessage(e.Message);
      end;
    end;
  finally
    FreeAndNil(lCloudResponseInfo);
    FreeAndNil(lBuckets);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  amcConnectionInfo.AccountName := AccountName;
  amcConnectionInfo.AccountKey := AccountKey;
  FStorageService := TAmazonStorageService.Create(amcConnectionInfo);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStorageService);
end;

procedure TFrmMain.lsbArquivosClick(Sender: TObject);
begin
  if(lsbArquivos.Items.Count > 0) then
  begin
    FArquivo := lsbArquivos.Items[lsbArquivos.ItemIndex];
  end;
end;

procedure TFrmMain.lsbBucketsClick(Sender: TObject);
begin
  if(lsbBuckets.Items.Count > 0) then
  begin
    FBucket := lsbBuckets.Items[lsbBuckets.ItemIndex];
  end;
end;

initialization
 ReportMemoryLeaksOnShutdown := True;


end.
