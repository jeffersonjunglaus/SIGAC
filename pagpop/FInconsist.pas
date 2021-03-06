unit FInconsist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TFrmInconsist = class(TForm)
    Label1: TLabel;
    stgDados: TStringGrid;
    btnInserir: TBitBtn;
    btnUpdate: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    FNomeLocal: String;
    FCPFLocal: String;
    FNomeWeb: String;
    FRGWeb: String;
    FCPFWeb: String;
    FRGLocal: String;
    FNewRecord: Boolean;
    procedure SetCPFLocal(const Value: String);
    procedure SetCPFWeb(const Value: String);
    procedure SetNomeLocal(const Value: String);
    procedure SetNomeWeb(const Value: String);
    procedure SetRGLocal(const Value: String);
    procedure SetRGWeb(const Value: String);
    procedure SetNewRecord(const Value: Boolean);
    { Private declarations }
  public
    property NomeLocal : String read FNomeLocal write SetNomeLocal;
    property NomeWeb   : String read FNomeWeb   write SetNomeWeb;
    property RGLocal   : String read FRGLocal   write SetRGLocal;
    property RGWeb     : String read FRGWeb     write SetRGWeb;
    property CPFLocal  : String read FCPFLocal  write SetCPFLocal;
    property CPFWeb    : String read FCPFWeb    write SetCPFWeb;
    property NewRecord : Boolean read FNewRecord write SetNewRecord;
    { Public declarations }
  end;

var
  FrmInconsist: TFrmInconsist;

implementation

{$R *.dfm}

{ TForm1 }

procedure TFrmInconsist.SetCPFLocal(const Value: String);
begin
  FCPFLocal := Value;
end;

procedure TFrmInconsist.SetCPFWeb(const Value: String);
begin
  FCPFWeb := Value;
end;

procedure TFrmInconsist.SetNomeLocal(const Value: String);
begin
  FNomeLocal := Value;
end;

procedure TFrmInconsist.SetNomeWeb(const Value: String);
begin
  FNomeWeb := Value;
end;

procedure TFrmInconsist.SetRGLocal(const Value: String);
begin
  FRGLocal := Value;
end;

procedure TFrmInconsist.SetRGWeb(const Value: String);
begin
  FRGWeb := Value;
end;

procedure TFrmInconsist.SetNewRecord(const Value: Boolean);
begin
  FNewRecord := Value;
end;

procedure TFrmInconsist.FormShow(Sender: TObject);
begin
  // Cabeçalhos
  stgDados.Cells[1,0] := 'Base Web';
  stgDados.Cells[2,0] := 'Base Local';
  stgDados.Cells[0,1] := 'Nome';
  stgDados.Cells[0,2] := 'RG';
  stgDados.Cells[0,3] := 'CPF';

  // Dados inconsistentes
  stgDados.Cells[1,1] := FNomeWeb;
  stgDados.Cells[2,1] := FNomeLocal;
  stgDados.Cells[1,2] := FRGWeb;
  stgDados.Cells[2,2] := FRGLocal;
  stgDados.Cells[1,3] := FCPFWeb;
  stgDados.Cells[2,3] := FCPFLocal;
end;

procedure TFrmInconsist.btnInserirClick(Sender: TObject);
begin
  FNewRecord := True;
  Close;
end;

procedure TFrmInconsist.btnUpdateClick(Sender: TObject);
begin
  FNewRecord := False;
  Close;
end;

end.
