unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg;

type
  TMainForm = class(TForm)
    Bevel: TBevel;  
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboProduct: TComboBox;
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage1: TLabel;
    lblHomepage2: TLabel;
    lblRegCode: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    mRegCode: TMemo;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
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
    '� 2023, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mRegCode.SelectAll;
  mRegCode.CopyToClipboard;
  mRegCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  RegCode: String;
  Result: Integer;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    Result := GenerateRegCode(ProductList[cboProduct.ItemIndex], edtName.Text, RegCode);

    if Result = 0 then
    begin
      mRegCode.Font.Color := clWindowText;
      mRegCode.Text := RegCode;
      btnCopy.Enabled := True;
    end
    else
    begin
      mRegCode.Font.Color := clGrayText;

      case Result of
        1: mRegCode.Text := 'Enter a name...';
        2: mRegCode.Text := 'Name cannot begin or end with spaces!';
        3: mRegCode.Text := 'Name is blacklisted!';
      end;

      btnCopy.Enabled := False;
    end;
  end
  else
    btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtNameChange(Sender: TObject);
begin
  OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  edtName.Text := GetUserName;

  if edtName.Text = '' then
    OnChange(nil);

  lblHomepage1.OnMouseLeave(lblHomepage1);
  lblHomepage2.OnMouseLeave(lblHomepage2);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  btnGenerate.Enabled := Trim(edtName.Text) <> '';

  if not btnGenerate.Enabled then
  begin
    mRegCode.Font.Color := clGrayText;
    mRegCode.Text := 'Enter a name...';
    btnCopy.Enabled := False;
  end
  else
    btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('https://' + (Sender as TLabel).Caption) then
    Application.MessageBox('Cannot open default web browser!', PChar(Caption), MB_ICONWARNING or MB_OK);
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
