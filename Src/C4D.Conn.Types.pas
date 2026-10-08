unit C4D.Conn.Types;

interface

type
  {$SCOPEDENUMS ON}
  TComponentConnection = (Empty, FireDac {$IFNDEF LINUX}, Zeos {$ENDIF});
  TDriverConnection = (MySQL, SQLite);
  {$SCOPEDENUMS OFF}

implementation

end.
