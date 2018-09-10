unit uException;

interface
 uses
  System.SysUtils, Forms, System.Classes;

type
    TException = class
      private
        FLogFile : string;
      public
        constructor Create;
        procedure TrataException(Sender: TObject; E : Exception);
        procedure GravarLog(value : string);

    end;
implementation

{ TException }

constructor TException.Create;
begin
   FLogFile := ChangeFileExt(ParamStr(0),'.log');
   Application.OnException := TrataException;
end;

procedure TException.GravarLog(value: string);
var
  txtLog : TextFile;
begin
  AssignFile(txtLog,FLogFile);
  if FileExists(FLogFile) then
     Append(txtLog)
  else
     Rewrite(txtLog);

  Writeln(txtLog,FormatDateTime('dd/mm/yy hh:nn:ss',Now) +  value);
  CloseFile(txtLog);
end;

procedure TException.TrataException(Sender: TObject; E: Exception);
begin
   GravarLog('  ======================================================');
   if TComponent(Sender) is TForm then
   begin
      GravarLog('  Form   : ' + TForm(Sender).Name);
      GravarLog('  Caption: ' + TForm(Sender).Caption);
      GravarLog('  Erro   : ' + E.ClassName);
      GravarLog('  Erro   : ' + E.Message);
   end
   else
   begin
      GravarLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
      GravarLog('Caption: ' + TForm(TComponent(Sender).Owner).caption);
      GravarLog('Erro: ' + E.ClassName);
      GravarLog('Erro: ' + E.Message);
   end;
end;

var
  MinhaException : TException;

initialization
  MinhaException := TException.create;

finalization
  MinhaException.free;
end.
