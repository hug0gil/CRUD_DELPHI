unit MenuUbicaciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, FIBDataSet, pFIBDataSet, FIBDatabase,
  pFIBDatabase, Grids, DBGrids, DBCtrls, ModuloDatos;

type
  TFormMenuUbicaciones = class(TForm)
    pnl1: TPanel;
    DBNavigator: TDBNavigator;
    dbgrd1: TDBGrid;
    dsTable: TDataSource;
    pfbdtstTable: TpFIBDataSet;
    pFIBTransaction1: TpFIBTransaction;
    rgGroupOrden1: TRadioGroup;
    fbntgrfldTableNCODIGO: TFIBIntegerField;
    fbstrngfldTableCCOD_ARTICULO: TFIBStringField;
    fbsmlntfldTableNPASILLO: TFIBSmallIntField;
    fbsmlntfldTableNSECCION: TFIBSmallIntField;
    fbsmlntfldTableNFILA: TFIBSmallIntField;
    fbcdfldTableNCANTIDAD: TFIBBCDField;
    fbdtmfldTableDFECHA_MOVIMIENTO: TFIBDateTimeField;
    fbntgrfldTableNCOD_ALB_COMPRA: TFIBIntegerField;
    fbntgrfldTableNCOD_ALB_VENTA: TFIBIntegerField;
    rgGroupOrden: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure rgGroupOrdenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFormMenuUbicaciones.FormCreate(Sender: TObject);
begin
  pFIBTransaction1.StartTransaction;
  pfbdtstTable.Open;
end;

procedure TFormMenuUbicaciones.rgGroupOrdenClick(Sender: TObject);
begin
  case rgGroupOrden.ItemIndex of
    0:
      begin
        pfbdtstTable.Close;
        case rgGroupOrden1.ItemIndex of
          0:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES WHERE NCOD_ALB_COMPRA IS NOT NULL ORDER BY NCODIGO';
              dbgrd1.Columns[7].Visible := True;
              dbgrd1.Columns[8].Visible := False;
            end;
          1:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES WHERE NCOD_ALB_VENTA IS NOT NULL ORDER BY NCODIGO';
              dbgrd1.Columns[7].Visible := False;
              dbgrd1.Columns[8].Visible := True;
            end;
          2:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES ORDER BY NCODIGO';
              dbgrd1.Columns[7].Visible := True;
              dbgrd1.Columns[8].Visible := True;
            end;
        end;
        pfbdtstTable.Open;
      end;

    1:
      begin
        pfbdtstTable.Close;
        case rgGroupOrden1.ItemIndex of
          0:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES WHERE NCOD_ALB_COMPRA IS NOT NULL ORDER BY DFECHA_MOVIMIENTO DESC';
            end;
          1:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES WHERE NCOD_ALB_VENTA IS NOT NULL ORDER BY DFECHA_MOVIMIENTO DESC';
            end;
          2:
            begin
              pfbdtstTable.SQLs.SelectSQL.Text :=
                'SELECT * FROM MOV_UBICACIONES ORDER BY DFECHA_MOVIMIENTO DESC';
            end;
        end;
        pfbdtstTable.Open;
      end;
  end;

end;

end.
