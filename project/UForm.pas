unit UForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, UTetris, StdCtrls, Buttons, Menus{, qt};

type
  TForm2 = class(TForm)
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    PaintBox2: TPaintBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Bv(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
  private
    BitMap1:TBitMap;
    BitMap2:TBitMap;
    BitMap3:TBitMap;
  public
   procedure Sravnenie;
   procedure NextPaint;
   procedure IzmOk(Sender: TObject);
   procedure EndSp(Sender: TObject; count:byte);
  end;

var
  Form2: TForm2;
  Figure: TFigure;
  Nex: array[1..5,1..5] of byte;
  fn,fnex:byte;
  Level,balls:integer;
  first:boolean;
implementation

uses About;

{$R *.dfm}
procedure TForm2.Sravnenie;
var i,j:byte;
Ap: array of TPoint;
begin
 SetLength(AP,12);
 for i:=4 to 23 do
  for j:=1 to 10 do
   if (Figure.fMatr[i][j]=0) then
    BitMap1.Canvas.CopyRect(Rect(25*(j-1),25*(i-4),25*j,25*(i-3)),BitMap2.Canvas,Rect(25*(j-1),25*(i-4),25*j,25*(i-3)));
 BitMap1.Canvas.Pen.Width:=2;
 for i:=23 downto 4 do
  for j:=1 to 10 do
    if (Figure.fMatr[i][j]=1)or(Figure.fMatr[i][j]>4) then
     begin
      if (Figure.fMatr[i][j]=1) then
       case Figure.f of
        1:BitMap1.Canvas.Brush.Color:=clRed;
        2:BitMap1.Canvas.Brush.Color:=clLime;
        3:BitMap1.Canvas.Brush.Color:=clYellow;
        4:BitMap1.Canvas.Brush.Color:=clAqua;
        5:BitMap1.Canvas.Brush.Color:=clFuchsia;
        6:BitMap1.Canvas.Brush.Color:=clBlue;
        7:BitMap1.Canvas.Brush.Color:=clGreen;
       end;
      if (Figure.fMatr[i][j]>4) then
       case Figure.fMatr[i][j] of
        5:BitMap1.Canvas.Brush.Color:=clRed;
        6:BitMap1.Canvas.Brush.Color:=clLime;
        7:BitMap1.Canvas.Brush.Color:=clYellow;
        8:BitMap1.Canvas.Brush.Color:=clAqua;
        9:BitMap1.Canvas.Brush.Color:=clFuchsia;
        10:BitMap1.Canvas.Brush.Color:=clBlue;
        11:BitMap1.Canvas.Brush.Color:=clGreen;
       end;
       Ap[0].X:=25*(j-1);      Ap[0].Y:=25*(i-4);
       Ap[1].X:=25*(j-1)+25;   Ap[1].Y:=25*(i-4);
       Ap[2].X:=25*j;          Ap[2].Y:=25*(i-3);
       Ap[3].X:=25*(j-1);      Ap[3].Y:=25*(i-3);
       Ap[4].X:=25*(j-1);      Ap[4].Y:=25*(i-4);
       Ap[5].X:=25*(j-1)+12;   Ap[5].Y:=25*(i-4)-12;
       Ap[6].X:=25*(j-1)+37;   Ap[6].Y:=25*(i-4)-12;
       Ap[7].X:=25*(j-1)+25;   Ap[7].Y:=25*(i-4);
       Ap[8].X:=25*j;          Ap[8].Y:=25*(i-3);
       Ap[9].X:=25*j+12;       Ap[9].Y:=25*(i-3)-12;
       Ap[10].X:=25*(j-1)+37;  Ap[10].Y:=25*(i-4)-12;
       Ap[11].X:=25*(j-1)+25;  Ap[11].Y:=25*(i-4);
      BitMap1.Canvas.Polygon (AP);
     end;
 PaintBox1.Canvas.CopyRect(Rect(0,0,250,500),BitMap1.Canvas,Rect(0,0,250,500));
end;

procedure TForm2.NextPaint;
var i,j:byte;
Ap: array of TPoint;
begin
 for i:=1 to 5 do
  for j:=1 to 4 do
   Nex[i,j]:=0;
 SetLength(AP,12);
 BitMap3.Canvas.Brush.Color:=clInfoBk;
 BitMap3.Canvas.FillRect(Rect(0,0,100,125));
 BitMap3.Canvas.Pen.Width:=2;
 
 case fnex of
  1: begin Nex[2,2]:=1; Nex[3,2]:=1; Nex[4,2]:=1; Nex[4,3]:=1; BitMap3.Canvas.Brush.Color:=clRed; end;
  2: begin Nex[2,3]:=1; Nex[3,3]:=1; Nex[4,3]:=1; Nex[4,2]:=1; BitMap3.Canvas.Brush.Color:=clLime; end;
  3: begin Nex[2,2]:=1; Nex[3,2]:=1; Nex[4,2]:=1; Nex[5,2]:=1; BitMap3.Canvas.Brush.Color:=clYellow; end;
  4: begin Nex[3,2]:=1; Nex[3,3]:=1; Nex[4,2]:=1; Nex[4,3]:=1; BitMap3.Canvas.Brush.Color:=clAqua; end;
  5: begin Nex[2,3]:=1; Nex[3,2]:=1; Nex[3,3]:=1; Nex[4,2]:=1; BitMap3.Canvas.Brush.Color:=clFuchsia; end;
  6: begin Nex[2,2]:=1; Nex[3,2]:=1; Nex[3,3]:=1; Nex[4,3]:=1; BitMap3.Canvas.Brush.Color:=clBlue; end;
  7: begin Nex[2,2]:=1; Nex[3,2]:=1; Nex[3,3]:=1; Nex[4,2]:=1; BitMap3.Canvas.Brush.Color:=clGreen; end;
 end;

  for i:=5 downto 1 do
   for j:=1 to 4 do
    if nex[i,j]=1 then
     begin
       Ap[0].X:=25*(j-1);     Ap[0].Y:=25*(i-1);
       Ap[1].X:=25*(j-1)+25;     Ap[1].Y:=25*(i-1);
       Ap[2].X:=25*j;        Ap[2].Y:=25*(i);
       Ap[3].X:=25*(j-1);     Ap[3].Y:=25*(i);
       Ap[4].X:=25*(j-1);           Ap[4].Y:=25*(i-1);
       Ap[5].X:=25*(j-1)+12;         Ap[5].Y:=25*(i-1)-12;
       Ap[6].X:=25*(j-1)+37;     Ap[6].Y:=25*(i-1)-12;
       Ap[7].X:=25*(j-1)+25;     Ap[7].Y:=25*(i-1);
       Ap[8].X:=25*j;        Ap[8].Y:=25*(i);
       Ap[9].X:=25*j+12;        Ap[9].Y:=25*(i)-12;
       Ap[10].X:=25*(j-1)+37;           Ap[10].Y:=25*(i-1)-12;
       Ap[11].X:=25*(j-1)+25;       Ap[11].Y:=25*(i-1);
       BitMap3.Canvas.Polygon (AP);
     end;
  PaintBox2.Canvas.CopyRect(Rect(0,0,100,125),BitMap3.Canvas,Rect(0,0,100,125));
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 level:=1;
 balls:=0;
 Figure:=TFigure.Create;
 Figure.OnEndSp:=EndSp;
 Figure.OnIzmOk:=IzmOk;
 first:=false;
 Timer1.Interval:=400;
 BitMap1:=TBitMap.Create;
 BitMap1.Height:=500;
 BitMap1.Width:=250;
 BitMap2:=TBitMap.Create;
 BitMap2.LoadFromFile('Fon.bmp');
 BitMap3:=TBitMap.Create;
 BitMap3.Height:=125;
 BitMap3.Width:=100;
 randomize;
 fn:=random(7)+1;
end;

procedure TForm2.EndSp(Sender: TObject; count:byte);
begin
 Sravnenie;
 case count of
  1:Balls:=Balls+100;
  2:Balls:=Balls+250;
  3:Balls:=Balls+500;
  4:Balls:=Balls+1000;
 end;
 if balls>level*750 then level:=level+1;
 if level<9 then Timer1.Interval:=400-((level-1)*50);
 Label3.Caption:=IntToStr(Level);
 Label4.Caption:=IntToStr(Balls);
end;

procedure TForm2.IzmOk(Sender: TObject);
var i,j,j2,m,l:byte;
begin
 Sravnenie;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
var k,j:byte;
begin
 k:=0;
 if Figure.flag then
  begin
   Figure.y:=Figure.y+1;
   Figure.Spusk;
  end
                else
  begin
   for j:=1 to 10 do
    if Figure.fMatr[4][j]>3 then k:=k+1;
   if k=0 then Form2.Bv(Sender) else Timer1.Enabled:=false;
  end;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
  32: if Timer1.Enabled=false then N3Click(Sender) else N4Click(Sender);
  37,65: if Timer1.Enabled=true then begin Figure.x:= Figure.x-1; Figure.Smeshenie end;
  39,68: if Timer1.Enabled=true then begin Figure.x:= Figure.x+1; Figure.Smeshenie; end;
  38,87: if Timer1.Enabled=true then begin Figure.Rout; Figure.RoutProv; exit end;
  40,83: if Figure.flag and Timer1.Enabled=true then begin Figure.y:= Figure.y+1; Figure.Spusk; exit end;
  112: Form2.N6Click(Sender);
  else exit;
 end;
end;

procedure TForm2.N2Click(Sender: TObject);
begin
 Form2.FormCreate(Sender);
 Form2.Bv(Sender);
 Timer1.Enabled:=true;
 N3.Enabled:=false;
 N4.Enabled:=true;
end;

procedure TForm2.N3Click(Sender: TObject);
begin
 Timer1.Enabled:=true;
 N3.Enabled:=false;
 N4.Enabled:=true;
end;

procedure TForm2.N4Click(Sender: TObject);
begin
 Timer1.Enabled:=false;
 N3.Enabled:=true;
 N4.Enabled:=false;
end;

procedure TForm2.N6Click(Sender: TObject);
begin
  N4Click(Sender);
  winhelp(Form2.Handle, 'help.hlp', HELP_CONTEXT, 1)
end;

procedure TForm2.N7Click(Sender: TObject);
begin
 Form2.N4Click(Sender);
 AboutForm.ShowModal;
end;

procedure TForm2.Bv(Sender: TObject);
var f:byte;
begin
 Figure.NewFig(fn);
 fnex:=random(7)+1;
 NextPaint;
 fn:=fnex;
 Sravnenie;
 Timer1.Enabled:=true;
 Label3.Caption:=IntToStr(Level);
 Label4.Caption:=IntToStr(Balls);
end;

procedure TForm2.FormPaint(Sender: TObject);
begin
 if not first then begin Sravnenie; first:=true end;
 NextPaint;
end;

end.
