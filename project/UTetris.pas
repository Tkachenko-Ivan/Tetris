unit UTetris;

interface

uses Classes;

type
 TMyEvent = procedure (Sender:TObject; count:byte) of Object;
   TFigure=class
     private
       fx,fy: byte;
       ff:byte;
       fp:byte;
       flag2:boolean; //Признак успешного завершения смещения
       flag3:boolean; //Признак успешного завершения ротации
       
       fOnIzmOk:TNotifyEvent; //Произошёл спуск
       fOnEndSp:TMyEvent; //Удаление строк

       procedure SetX(NewX:byte); //Процедура смещения
       procedure SetY(NewY:byte); //Процедура спуска

     public
       flag:boolean; //Признак успешного завершения спуска
       left:boolean; //Смещение произошло влево?
       fMatr: array of array of byte; //матрица

       constructor Create;
       procedure Smeshenie; //Применение результата смещения
       procedure Spusk; //Применение результата спуска
       procedure Rout; //Ротация
       procedure RoutProv; //Применение результата ротации
       procedure NewFig(n:byte); //Создание новой фигуры
       procedure CorrectMatr;

       property f: byte read ff write ff; //Номер фигуры
       property x: byte read fx write SetX; //Координат верхнего
       property y: byte read fy write SetY;           // левого угла
       property p: byte read fp write fp; //Положение фигуры: Вертикальное/Горизонтальное

       property OnIzmOk: TNotifyEvent read fOnIzmOk write fOnIzmOk;
       property OnEndSp: TMyEvent read fOnEndSp write fOnEndSp;
     end;


implementation

  procedure TFigure.CorrectMatr;
  var i,j,k,i2,count,st,m:byte;
   begin
    count:=0;
    case f of
     1,2,5,6,7: if (p=1)or(p=3) then m:=2 else m:=1;
     3: if p=1 then m:=3 else m:=0;
     4: m:=1;
    end;
    for i:=y to y+m do
     begin
      k:=0;
      for j:=1 to 10 do
       if fMatr[i][j]>4 then k:=k+1;
      if k=10 then
       begin
        count:=count+1;
        st:=i;
        for i2:=i downto 5 do
         for j:=1 to 10 do
          fMatr[i2][j]:=fMatr[i2-1][j]
       end
     end;
    if count>0 then
    if assigned(fOnEndSp) then OnEndSp(Self,count);
   end;

constructor TFigure.Create;
  var i,j:byte;
   begin
    SetLength(fMatr,27);
    for i:=0 to 26 do
     SetLength(fMatr[i],12);
    for j:=0 to 11 do
     begin
      fMatr[24][j]:=4;
      fMatr[25][j]:=4;
      fMatr[26][j]:=4;
     end;
    for i:=0 to 24 do
     begin
      fMatr[i][0]:=4;
      fMatr[i][11]:=4;
     end
   end;

  procedure TFigure.SetX(NewX:byte); //Процедура смещения
  var j,i,m,l:byte;
   begin
    flag2:=true;
    case f of
     1,2,5,6,7: if (p=1)or(p=3) then begin l:=1; m:=2 end else begin l:=2; m:=1 end;
     3: if p=1 then begin l:=0; m:=3 end else begin l:=3; m:=0 end;
     4: begin l:=1; m:=1 end;
    end;

    if fx<NewX then
     begin
      left:=false;
      for i:=x+l downto x do
       for j:=y to y+m do
        if fMatr[j][i]=1 then
         if (fMatr[j][i+1]<4)then
          if fMatr[j][i+1]=1 then fMatr[j][i+1]:=3 else fMatr[j][i+1]:=2
         else begin flag2:=false; exit end;
     end
               else
     begin
      left:=true;
      for i:=x to x+l do
       for j:=y to y+m do
        if fMatr[j][i]=1 then
         if (fMatr[j][i-1]<4)and(i<>0) then
          if fMatr[j][i-1]=1 then fMatr[j][i-1]:=3 else fMatr[j][i-1]:=2
         else begin flag2:=false; exit end;
     end;
    fx:=NewX;
   end;

  procedure TFigure.SetY(NewY:byte); //Процедура спуска
  var j,i,m,l:byte;
   begin
    flag:=true;

    case f of
     1,2,5,6,7: if (p=1)or(p=3) then begin l:=1; m:=2 end else begin l:=2; m:=1 end;
     3: if p=1 then begin l:=0; m:=3 end else begin l:=3; m:=0 end;
     4: begin l:=1; m:=1 end;
    end;

    for j:=y+m downto y do
     for i:=x to x+l do
      if fMatr[j][i]=1 then
       if fMatr[j+1][i]<4 then
        if fMatr[j+1][i]=1 then fMatr[j+1][i]:=3 else fMatr[j+1][i]:=2
       else begin flag:=false; exit end;
    fy:=NewY;
   end;

  procedure TFigure.Smeshenie; //Применение результата смещения
  var i,j,j2,m,l:byte;
   begin

    case f of
     1,2,5,6,7: if (p=1)or(p=3) then begin l:=1; m:=2 end else begin l:=2; m:=1 end;
     3: if p=1 then begin l:=0; m:=3 end else begin l:=3; m:=0 end;
     4: begin l:=1; m:=1 end;
    end;

    if left then j2:=x else j2:=x-1;

    for i:=y to y+m do
     for j:=j2-1 to j2+l+2 do
      begin
       if not flag2 then //Смещение не удалось
        begin
         if fMatr[i][j]=2 then fMatr[i][j]:=0;
         if (fMatr[i][j]=1)or(fMatr[i][j]=3) then fMatr[i][j]:=1;
        end
                   else
        begin
         if fMatr[i][j]=1 then fMatr[i][j]:=0;
         if (fMatr[i][j]=2)or(fMatr[i][j]=3) then fMatr[i][j]:=1;
         if assigned(fOnIzmOk) then OnIzmOk(Self);
        end;
      end;
   end;

  procedure TFigure.Spusk; //Применение результата спуска
  var i,j,l,m:byte;
   begin
    case f of
     1,2,5,6,7: if (p=1)or(p=3) then begin l:=1; m:=2 end else begin l:=2; m:=1 end;
     3: if p=1 then begin l:=0; m:=3 end else begin l:=3; m:=0 end;
     4: begin l:=1; m:=1 end;
    end;

    for i:=y-1 to y+m do
     for j:=x-1 to x+l+1 do
      begin
       if not flag then //Спуск не удался
        begin
         if fMatr[i][j]=2 then fMatr[i][j]:=0;
         if (fMatr[i][j]=1)or(fMatr[i][j]=3) then fMatr[i][j]:=4+f;
        end
                   else
        begin
         if fMatr[i][j]=1 then fMatr[i][j]:=0;
         if (fMatr[i][j]=2)or(fMatr[i][j]=3) then fMatr[i][j]:=1;
         if assigned(fOnIzmOk) then OnIzmOk(Self);
        end;
      end;
     if not flag then CorrectMatr;
   end;

  procedure TFigure.Rout; //Ротация
   begin
    flag3:=true;
    if f=4 then begin flag3:=false; exit end
           else
      if (f=5)or(f=6)or(f=3) then
      begin
       if p=1 then
        begin
         if f=3 then
          begin
           if fMatr[y+1][x-1]<4 then fMatr[y+1][x-1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
           fx:=x-1;
           fy:=y+1;
          end;
         if f=5 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
          end;
         if f=6 then
          begin
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+2]<4 then fMatr[y][x+2]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
          end;
         p:=2; exit;
        end;
       if p=2 then
        begin
         if f=3 then
          begin
           if fMatr[y-1][x+1]<4 then fMatr[y-1][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+2][x+1]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
           fx:=x+1;
           fy:=y-1;
          end;
         if f=5 then
          begin
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+2][x]<4 then fMatr[y+2][x]:=2 else begin flag3:=false; exit end;
          end;
         if f=6 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+2][x+1]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
          end;
         p:=1; exit;
        end
      end

                            else

      begin
       if p=1 then
        begin
         if f=1 then
          begin
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+2]<4 then fMatr[y][x+2]:=2 else begin flag3:=false; exit end;
          end;
         if f=2 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y][x+2]<4 then fMatr[y][x+2]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
          end;
         if f=7 then
          begin
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
          end;
         p:=2; exit;
        end;
       if p=2 then
        begin
         if f=1 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+2][x+1]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
          end;
         if f=2 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+2][x]<4 then fMatr[y+2][x]:=2 else begin flag3:=false; exit end;
          end;
         if f=7 then
          begin
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
          end;
         p:=3; exit;
        end;
       if p=3 then
        begin
         if f=1 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y][x+2]<4 then fMatr[y][x+2]:=2 else begin flag3:=false; exit end;
          end;
         if f=2 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+2]<4 then fMatr[y+1][x+2]:=2 else begin flag3:=false; exit end;
          end;
         if f=7 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y][x+2]<4 then fMatr[y][x+2]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
          end;
         p:=4; exit;
        end;
       if p=4 then
        begin
         if f=1 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+2][x]<4 then fMatr[y+2][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+2][x+1]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
          end;
         if f=2 then
          begin
           if fMatr[y][x+1]<4 then fMatr[y][x+1]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
           if fMatr[y+2][x]<4 then fMatr[y+2][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+2][x+1]<4 then fMatr[y+2][x+1]:=2 else begin flag3:=false; exit end;
          end;
         if f=7 then
          begin
           if fMatr[y][x]<4 then fMatr[y][x]:=3 else begin flag3:=false; exit end;
           if fMatr[y+1][x]<4 then fMatr[y+1][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+2][x]<4 then fMatr[y+2][x]:=2 else begin flag3:=false; exit end;
           if fMatr[y+1][x+1]<4 then fMatr[y+1][x+1]:=3 else begin flag3:=false; exit end;
          end;
         p:=1; exit;
        end;
      end;
   end;

  procedure TFigure.RoutProv; //Применение результата ротации
  var i,j,m,l,k:byte;
   begin
    l:=y;
    k:=x;
    case f of
     1,2,5,6,7: m:=2;
     3: begin m:=4; l:=y-1; k:=x-1 end;
     4: m:=1;
    end;

    for i:=l to l+m do
     for j:=k to k+m do
      begin
       if not flag3 then //Ротация не удалась
        begin
         if fMatr[i][j]=2 then fMatr[i][j]:=0;
         if (fMatr[i][j]=1)or(fMatr[i][j]=3) then fMatr[i][j]:=1;
        end
                   else
        begin
         if fMatr[i][j]=1 then fMatr[i][j]:=0;
         if (fMatr[i][j]=2)or(fMatr[i][j]=3) then fMatr[i][j]:=1;
         if assigned(fOnIzmOk) then OnIzmOk(Self);
        end;
      end;
   end;

  procedure TFigure.NewFig(n:byte);
   begin
   flag:=true;
   f:=n;
   p:=1;
   fx:=5; fy:=0;

   if f=3 then fMatr[3][5]:=1;
   if(f=1)or(f=3)or(f=7)then
    begin
      fMatr[2][5]:=1;
      fMatr[1][5]:=1;
      fMatr[0][5]:=1;
    end;
   if(f=1)or(f=6)or(f=2)then fMatr[2][6]:=1;
   if(f=2)or(f=5)then fMatr[2][5]:=1;
   if(f=4)or(f=5)or(f=6)then
    begin
     fMatr[1][5]:=1;
     fMatr[1][6]:=1;
    end;
    if(f=7)or(f=2)then fMatr[1][6]:=1;
    if(f=4)or(f=5)or(f=2)then fMatr[0][6]:=1;
    if(f=4)or(f=6)then fMatr[0][5]:=1;
   end;

end.
