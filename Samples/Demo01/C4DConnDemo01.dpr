program C4DConnDemo01;

uses
  Vcl.Forms,
  C4DConnDemo01.View.Main in 'Src\View\C4DConnDemo01.View.Main.pas' {C4DConnDemo01ViewMain};

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TC4DConnDemo01ViewMain, C4DConnDemo01ViewMain);
  Application.Run;

end.
