unit Main;

interface

uses
{$IFDEF FPC}
  LCLIntf, LCLType, LMessages,
{$ELSE}
  Windows,
{$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KMemoFrm, KMemo,kmemohtm;

type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FFrame: TKMemoFrame;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

procedure TMainForm.FormCreate(Sender: TObject);
var
  Reader: TKMemoHTMLReader;
begin
  FFrame := TKMemoFrame.Create(Self);
  FFrame.Align := alClient;
  FFrame.Parent := Self;
  //FFrame.OpenFile('kmemo_manual.rtf');
  Reader := TKMemoHTMLReader.Create(FFrame.Editor);
  try
    Reader.LoadFromFile('kmemo_test.htm');
  finally
    Reader.Free;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FFrame.SaveFile(False, True);
end;

end.
