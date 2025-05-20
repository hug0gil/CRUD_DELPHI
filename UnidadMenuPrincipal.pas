unit UnidadMenuPrincipal;
interface
uses
  Windows, SysUtils, Forms, Dialogs, Graphics, StdCtrls,
  ExtCtrls, Classes, Controls, printers,
  Qrctrls, QuickRpt, shellapi;
const
  EAN_izqA : array[0..9] of
  PChar=('0001101','0011001','0010011','0111101','0100011',
       '0110001','0101111','0111011','0110111','0001011');
  EAN_izqB : array[0..9] of
  PChar=('0100111','0110011','0011011','0100001','0011101',
       '0111001','0000101','0010001','0001001','0010111');
  EAN_dcha : array[0..9] of
  PChar=('1110010','1100110','1101100','1000010','1011100',
       '1001110','1010000','1000100','1001000','1110100');
  CodificaIzq : array[0..9] of
  PChar=('AAAAA','ABABB','ABBAB','ABBBA','BAABB','BBAAB',
       'BBBAA','BABAB','BABBA','BBABA');
type
  TformMenuPrincipal = class(TForm)
    Panel1: TPanel;
    Grafico: TImage;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Button2: TButton;
    Button3: TButton;
    LImpresion: TQuickRep;
    TitleBand1: TQRBand;
    LImagen: TQRImage;
    Button4: TButton;
    LWEB: TLabel;
    SaveDialog1: TSaveDialog;
  procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure LWEBClick3(Sender: TObject);
  private
  { Private declarations }
  public
  { Public declarations }
  // procedimiento que codifica el número en un nº binario
  procedure Codifica(num : string);
  // procedimiento para dibujar el cód. de barras a partir del nº binario
  procedure Dibujar(matrix : string);
  // procedimiento para validar-corregir los códigos
  procedure EANCorrecto(var num : string);
end;

var
  formMenuPrincipal: TformMenuPrincipal;

implementation

{$R *.DFM}
procedure TformMenuPrincipal.EANCorrecto(var num : string);
var
  i,N : byte;
  sum : integer;
  flag : byte;
begin
  sum:=0;
  N:=Length(num)-1;
  for i:=1 to N do
  begin
    if (i mod 2)=0 then
    begin
      if N=12 then
        sum:=sum+StrToInt(num[i])*3
      else
        sum:=sum+StrToInt(num[i]);
    end
    else
    begin
      if N=12 then
        sum:=sum+StrToInt(num[i])
      else
        sum:=sum+StrToInt(num[i])*3;
    end;
  end;
  if sum>99 then
    Flag:=10-(sum mod 100)
  else
    Flag:=10-(sum mod 10);
  if Flag=10 then Flag:=0;
  if not(StrToInt(num[N+1])=flag) then
  begin
    ShowMessage('El dígito de control no es válido y será cambiado'+#13+
    'El dígito correcto es '+IntToStr(Flag));
    num:=copy(num,1,length(num)-1)+IntToStr(Flag);
  end;
end;


procedure TformMenuPrincipal.Codifica(num : string);
var
  matrix : string;
  i : integer;
begin
  num:=Edit1.Text;
  matrix:='';
  case Length(num) of
  13: begin
    EANCorrecto(num);
    Edit1.Text:=num;
    matrix:=matrix+'x0x'; // barra inicio
    matrix:=matrix+EAN_izqA[StrToInt(num[2])];
    for i:=3 to 7 do
      if CodificaIzq[StrToInt(num[1])][i-3]='A' then
        matrix:=matrix+EAN_izqA[StrToInt(num[i])]
      else
        matrix:=matrix+EAN_izqB[StrToInt(num[i])];
    matrix:=matrix+'0x0x0'; // barra central
    matrix:=matrix+EAN_dcha[StrToInt(num[8])];
    matrix:=matrix+EAN_dcha[StrToInt(num[9])];
    matrix:=matrix+EAN_dcha[StrToInt(num[10])];
    matrix:=matrix+EAN_dcha[StrToInt(num[11])];
    matrix:=matrix+EAN_dcha[StrToInt(num[12])];
    matrix:=matrix+EAN_dcha[StrToInt(num[13])];
    matrix:=matrix+'x0x'; // barra final
    Dibujar(Matrix);
  end;
  8: begin
    EANCorrecto(num);
    Edit1.Text:=num;
    matrix:=matrix+'x0x';
    matrix:=matrix+EAN_izqA[StrToInt(num[1])];
    matrix:=matrix+EAN_izqA[StrToInt(num[2])];
    matrix:=matrix+EAN_izqA[StrToInt(num[3])];
    matrix:=matrix+EAN_izqA[StrToInt(num[4])];
    matrix:=matrix+'0x0x0';
    matrix:=matrix+EAN_dcha[StrToInt(num[5])];
    matrix:=matrix+EAN_dcha[StrToInt(num[6])];
    matrix:=matrix+EAN_dcha[StrToInt(num[7])];
    matrix:=matrix+EAN_dcha[StrToInt(num[8])];
    matrix:=matrix+'x0x';
    Dibujar(Matrix);
  end
  else
    ShowMessage('LONGITUD DE CODIGO NO VALIDA');
  end;
end;

procedure TformMenuPrincipal.Dibujar(matrix : string);
var
  i : integer;
begin
  Grafico.Canvas.Brush.Color:=clWhite;
  Grafico.Canvas.FillRect(Rect(0,0,Grafico.Width,Grafico.Height));
  Grafico.Canvas.Pen.Color:=clBlack;
  for i:=1 to Length(Matrix) do
    if matrix[i]='1' then
      Grafico.Canvas.PolyLine([Point(10+i,10),Point(10+i,50)])
    else
      if matrix[i]='x' then
        Grafico.Canvas.PolyLine([Point(10+i,10),Point(10+i,55)]);
      if Length(Edit1.Text)=13 then
      begin
        Grafico.Canvas.TextOut(3,50,Edit1.Text[1]);
        Grafico.Canvas.TextOut(17,50,copy(Edit1.Text,2,6));
        Grafico.Canvas.TextOut(63,50,copy(Edit1.Text,8,6));
      end
      else
      if Length(Edit1.Text)=8 then
      begin
        Grafico.Canvas.TextOut(16,50,copy(Edit1.Text,1,4));
        Grafico.Canvas.TextOut(48,50,copy(Edit1.Text,5,4));
      end;
end;

procedure TformMenuPrincipal.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Codifica(Edit1.Text);
    Edit1.SelectAll;
  end;
end;
procedure TformMenuPrincipal.Button1Click(Sender: TObject);
begin
  Codifica(Edit1.Text);
  Edit1.SelectAll;
end;

procedure TformMenuPrincipal.Button3Click(Sender: TObject);
begin
  close;
end;

procedure TformMenuPrincipal.Button2Click(Sender: TObject);
begin
  LImagen.Picture := grafico.Picture;
  LImpresion.Preview;
end;

procedure TformMenuPrincipal.Button4Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Grafico.Picture.SaveToFile(SaveDialog1.FileName);
end;

procedure TformMenuPrincipal.LWEBClick3(Sender: TObject);
begin
  ShellExecute(Handle, Nil, PChar(LWEB.CAPTION),
      Nil, Nil, SW_SHOWNORMAL);
end;

end.

