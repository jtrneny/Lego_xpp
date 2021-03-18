unit dm;

interface

uses
{$IFDEF WIN32}
  Windows, Messages, Forms,
{$ENDIF}
  SysUtils, Classes, adscnnct, Db, adsdata, adsfunc, adstable;

type
  Tdm1 = class(TDataModule)
    DataConn: TAdsConnection;
    tblInput: TAdsTable;
    tblOutput: TAdsTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

end.
