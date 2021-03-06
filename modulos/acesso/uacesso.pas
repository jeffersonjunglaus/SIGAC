unit uacesso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, jpeg, StdCtrls, inifiles, shellapi,
  ZConnection, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, DBCtrls;

type
  TFacesso = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    prodape: TPanel;
    btnconfirmar: TSpeedButton;
    btnlimpra: TSpeedButton;
    euso: TEdit;
    esenha: TEdit;
    conector: TZConnection;
    q: TZQuery;
    lfantasia1: TLabel;
    lfantasia: TLabel;
    procedure btnconfirmarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnlimpraClick(Sender: TObject);
    procedure esenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure conectorBeforeConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  fecha:boolean;
    { Private declarations }
  public
  controle:integer;
    { Public declarations }
  end;

var
  Facesso: TFacesso;

implementation

{$R *.dfm}

uses funcoes,udm;

procedure TFacesso.btnconfirmarClick(Sender: TObject);
var
  reg: string;
begin
        with q do begin
             sql.Clear;
             sql.Add('select registro,venctodata from tbconfig ');
             open;

             if q['registro'] <> null then reg := q['registro']
             else                          reg := '0';



             if q.FieldByName('venctodata').asstring <> datetostr(now) then
               if Application.MessageBox(pchar('Hoje: ' + datetimetostr(now) + #13+#13+
                                     'A DATA DO SEU MICRO EST� CORRETA? '+#13+#13+
                                     'OBS: Caso n�o esteja, acerte-a antes de continuar.'),
                                     'Verifique a data', 4 + MB_ICONwarning) = idno then begin
                  vf := true;
                  application.terminate;
                  abort;
               end;



             codloc := reg;
             close;
        end;



        //senha master
        if esenha.Text = floattostr((strtofloat(formatdatetime('dd', date)) +
                         strtofloat(formatdatetime('mm', date)) *
                         strtofloat(formatdatetime('yyyy', date)) +
                         strtofloat(formatdatetime('hh', time)) +
                         strtofloat(reg)) * 99 + 3) then begin

           with q do begin
              sql.Clear;
              sql.Add('select chave from tbusuario where nome = "SUPERVISOR"');
              open;

              if RecordCount >0 then
                 usuarioLink := fieldbyname('chave').AsInteger
              else
                 usuarioLink := 1;

              usuario := 'SUPERVISOR';

              close;
           end;

           fecha := true;
           close;

        // se for senha normal
        end else begin

            with q do begin
                 sql.Clear;
                 sql.Add('select * from tbusuario where '+
                         ' (nome = ' + quotedstr(euso.text) +
                         ' or chave = ' + quotedstr(euso.text) +
                         ' ) and senha = ' + quotedstr(esenha.text));
                 open;

                 if RecordCount <=0 then begin

                    close;
                    application.MessageBox('Verifique o usu�rio e a senha.','Logar', 0);
                    abort;

                 end;

                 usuarioLink := fieldbyname('chave').AsInteger;
                 usuario     := euso.Text;
                 atacado := FieldByName('atacado').AsString='S';
                 atacado2 := FieldByName('valor3').AsString='S';


                 close;
            end;

            fecha := true;
            close;

         end;



end;

procedure TFacesso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if (key = 13) or(key = 38) then
           Perform(wm_nextdlgctl, 0,0);
        if (key = 40) then
           Perform(wm_nextdlgctl, 1,0);

        if key = 27 then close;   
end;

procedure TFacesso.btnlimpraClick(Sender: TObject);
begin
        vf := true;
        application.Terminate;
end;

procedure TFacesso.esenhaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if key = 13 then btnconfirmarClick(self);
end;

procedure TFacesso.conectorBeforeConnect(Sender: TObject);
var
ini:tinifile;
dtb:string;
begin
        conector.Disconnect;
        Ini := TInifile.Create(CONF_GLOBAL);
        dtb:= Ini.Readstring('databasename', 'databasename', '');
        if ip = '' then
        ip := Ini.Readstring('Rede', 'Host', '');
        ini.Free;

        if dtb <> '' then begin
           Ini := TInifile.Create(CONF_GLOBAL);
           conf_local := CONF_GLOBAL;
        end else

        Ini := TInifile.Create(conf_local);
        if iprede <> '' then
           conector.HostName := iprede
        else if ip<>'' then  conector.HostName := ip
        else
        conector.HostName := Ini.Readstring('Rede', 'Host', 'localhost');

        conector.User     := Ini.Readstring('Rede', 'user', 'root');
        conector.Password := Crypt('D',Ini.Readstring('Rede', 'Password', ''));
        conector.Database := databasename;
        ini.Free;
end;

procedure TFacesso.FormShow(Sender: TObject);
var
st:string;
ini:tinifile;
begin
  //TestCryptoIni;

  if fileexists(ExtractFilePath(ParamStr(0)) + 'user.txt') then
  begin
     euso.Text   := 'SUPERVISOR';
     esenha.Text := '1';
  end;

  lfantasia.Caption  := application.Title;
  lfantasia1.Caption := lfantasia.Caption;

  if fileexists(PChar(ExtractFilePath(ParamStr(0)) + 'imagem\senha.jpg')) then
    imagepanel('senha',altop,prodape, (PChar(ExtractFilePath(ParamStr(0)) +'imagem\senha.jpg')),nil);

  if fileexists(PChar(ExtractFilePath(ParamStr(0)) + 'imagem\idlg.jpg')) then
    imageform('senha',altop,self, (PChar(ExtractFilePath(ParamStr(0)) +'imagem\idlg.jpg')),nil);

  if responsavel <> '562.668.395-04' then
  begin
      conector.Disconnect;
      vf:=false;
      repeat

            try
               conector.Connect;
            except
               if inputquery('Conectar','Digite o nome do servidor para conectar:',st) then begin
                  ini := TInifile.Create(conf_local);
                  Ini.Writestring('rede', 'host', st);
                  ini.free;
                  conector.Disconnect;

               end else vf := true;
            end;

      until (conector.Connected) or (vf);

      if conector.Connected = false then begin
          application.Terminate;
          vf := true;
      end;
   end;

end;

procedure TFacesso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        if not fecha then application.Terminate;
end;

end.
