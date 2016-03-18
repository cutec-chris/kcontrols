{ @abstract(This unit contains HTML reader and writer for TKMemo control)
  @author(Christian Ulrich (christian@cu-tec.de))
  @created(16 Feb 2016)
  @lastmod(16 Feb 2016)

  Copyright © Christian Ulrich (christian@cu-tec.de)<BR><BR>

  <B>License:</B><BR>
  This code is distributed as a freeware. You are free to use it as part
  of your application for any purpose including freeware, commercial and
  shareware applications. The origin of this source code must not be
  misrepresented; you must not claim your authorship. All redistributions
  of the original or modified source code must retain the original copyright
  notice. The Author accepts no liability for any damage that may result
  from using this code.
}

unit kmemohtm; // lowercase name because of Lazarus/Linux

{$include kcontrols.inc}
{$WEAKPACKAGEUNIT ON}

interface

uses
  Classes, Contnrs, Graphics, Controls, Types,
  KControls, KFunctions, KGraphics, KMemo,kmemortf;

type
  { Specifies the HTML reader. }

  { TKMemoHTMLReader }

  TKMemoHTMLReader = class(TKMemoRTFReader)
  private
    function GetChar: AnsiChar;
  protected
    procedure ReadStream; override;
  public
    constructor Create(AMemo: TKCustomMemo); override;
    destructor Destroy; override;
    procedure LoadFromStream(AStream: TStream; AtIndex: Integer = -1; AActiveBlocks: TKMemoBlocks = nil); override;
  end;

implementation

uses
  Math, SysUtils, KHexEditor, KRes
{$IFDEF FPC}
  , LCLIntf, LCLProc, LConvEncoding, LCLType
{$ELSE}
  , JPeg, Windows
{$ENDIF}
  ;
resourcestring
  // KMemoRTF texts
  sErrMemoLoadFromHTML = 'Error while reading HTML file.';
  sErrMemoLoadImageFromHTML = 'Error while loading image from HTML file.';
  sErrMemoSaveToHTML = 'Error while saving HTML file.';

function TKMemoHTMLReader.GetChar: AnsiChar;
begin
  Result := Char(FStream.ReadByte);
end;

procedure TKMemoHTMLReader.ReadStream;
begin
  //https://dev.w3.org/html5/spec-preview/parsing.html
  //detect encoding
end;

constructor TKMemoHTMLReader.Create(AMemo: TKCustomMemo);
begin
  inherited Create(AMemo);
end;

destructor TKMemoHTMLReader.Destroy;
begin
  inherited Destroy;
end;

procedure TKMemoHTMLReader.LoadFromStream(AStream: TStream; AtIndex: Integer;
  AActiveBlocks: TKMemoBlocks);
begin
  try
    if AActiveBlocks <> nil then
    begin
      FActiveBlocks := AActiveBlocks
    end
    else if FMemo <> nil then
    begin
      if AtIndex < 0 then
      begin
        FMemo.Clear;
        FMemo.Blocks.Clear; // delete everything
        FActiveBlocks := FMemo.Blocks;
        FAtIndex := 0; // just append new blocks to active blocks
      end;
    end;
    if FActiveBlocks <> nil then
    begin
      FActiveBlocks.LockUpdate;
      try
        FActiveColor := nil;
        FActiveContainer := nil;
        FActiveFont := nil;
        FActiveImage := nil;
        FActiveImageClass := nil;
        FActiveList := nil;
        FActiveListLevel := nil;
        FActiveListOverride := nil;
        FActiveParaBorder := alNone;
        FActiveShape := nil;
        FActiveState := TKMemoRTFState.Create;
        FActiveState.Group := rgUnknown; // we wait for file header
        if FMemo <> nil then
        begin
          FActiveState.ParaStyle.Assign(FMemo.ParaStyle);
          FActiveState.TextStyle.Assign(FMemo.TextStyle);
        end;
        FActiveString := '';
        FActiveTable := nil;
        FActiveTableBorder := alNone;
        FActiveTableCell := nil;
        FActiveTableCol := -1;
        FActiveTableColCount := 0;
        FActiveTableRow := nil;
        FActiveText := nil;
        FColorTable.Clear;
        FDefaultFontIndex := 0;
        FIgnoreChars := 0;
        FStream := AStream;
        ReadStream;
      finally
        FlushText;
        FlushShape;
        FlushImage;
        FlushTable;
        FActiveState.Free;
        if FMemo <> nil then
          FListTable.AssignToListTable(FMemo.ListTable, FFontTable);
        FActiveBlocks.ConcatEqualBlocks;
        FActiveBlocks.FixEmptyBlocks;
        FActiveBlocks.UnlockUpdate;
      end;
    end;
  except
    KFunctions.Error(sErrMemoLoadFromHTML);
  end;
end;


end.


