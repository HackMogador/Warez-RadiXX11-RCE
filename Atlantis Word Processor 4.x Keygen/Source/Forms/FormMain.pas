unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;  
    btnAbout: TButton;
    btnCopy: TButton;
    edtEMail: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblRegCode: TLabel;
    lblEMail: TLabel;
    mRegCode: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure OnLinkClick(Sender: TObject);
    procedure OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnLinkMouseEnter(Sender: TObject);
    procedure OnLinkMouseLeave(Sender: TObject);
    procedure OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  ShellAPI,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '� 2020, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mRegCode.SelectAll;
  mRegCode.CopyToClipboard;
  mRegCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  lblHomepage.OnMouseLeave(lblHomepage);
  OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtEMail.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  if Trim(edtEMail.Text) <> '' then
  begin
    mRegCode.Font.Color := clWindowText;
    mRegCode.Text := GenerateRegCode(edtEMail.Text);
    btnCopy.Enabled := True;
  end
  else
  begin
    mRegCode.Font.Color := clGrayText;
    mRegCode.Text := 'Enter an email (or anything you want)...';
    btnCopy.Enabled := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('https://www.atlantiswordprocessor.com') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

end.
