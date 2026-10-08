unit C4D.Conn.Types;

interface

type
  {$SCOPEDENUMS ON}
  TComponentConnection = (Empty, FireDac {$IFNDEF LINUX}, Zeos {$ENDIF});
  {$SCOPEDENUMS OFF}

implementation

end.
