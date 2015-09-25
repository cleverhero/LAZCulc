unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, Math, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button10: TButton;
    ButtonCE: TButton;
    ButtonBS: TButton;
    ButtonMul: TButton;
    ButtonShare: TButton;
    ButtonPer: TButton;
    Memory: TLabel;
    negat: TButton;
    Button1: TButton;
    Button0: TButton;
    minus: TButton;
    Output: TEdit;
    BRavno: TButton;
    point: TButton;
    Buttonpm: TButton;
    Bsqrt: TButton;
    ButtonC: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Output1: TEdit;
    plus: TButton;
    procedure BRavnoClick(Sender: TObject);
    procedure ButtonBSClick(Sender: TObject);
    procedure ButtonCClick(Sender: TObject);
    procedure ButtonCEClick(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure ButtonMulClick(Sender: TObject);
    procedure ButtonPerClick(Sender: TObject);
    procedure ButtonpmClick(Sender: TObject);
    procedure ButtonShareClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure minusClick(Sender: TObject);
    procedure Ravno;
    procedure procplus;
    procedure procminus;
    procedure procmul;
    procedure procshare;
    procedure procpersent;
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure negatClick(Sender: TObject);
    procedure plusClick(Sender: TObject);
    procedure pointClick(Sender: TObject);
    procedure Print(ttext: string);
    procedure BsqrtClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

type
  MyStates = (OK, ERROR, AFTER_OPERATION);
  OpStates = (NONE, PLUS, MINUS, MULTIPLY, SHARE);

var
  Form1: TForm1;
  State: MyStates;
  Oper: OpStates;
  s:integer;
  pm, points, per: boolean;
  X: extended;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.ButtonClick(Sender: TObject);
var
  ttext: string;
begin
  Button10.SetFocus;
  ttext := (Sender as TButton).Caption;
  print(ttext);
  form1.Visible := True;
end;

procedure TForm1.ButtonMulClick(Sender: TObject);
begin
  Button10.SetFocus;
  procmul;
end;

procedure TForm1.ButtonPerClick(Sender: TObject);
begin
    procpersent;
end;

procedure TForm1.ButtonCClick(Sender: TObject);
begin
  Button10.SetFocus;
  if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
  state := MyStates.OK;
  Output.Text := '0';
  Output1.Text := '';
  points := False;
  pm := False;
  Oper := OpStates.NONE;
  form1.Visible := True;
end;

procedure TForm1.ButtonCEClick(Sender: TObject);
begin
  if state<>MyStates.ERROR then begin
     output.Text:='0';
     output1.Text:='';
     oper:=OpStates.NONE;
  end;
end;

procedure TForm1.BRavnoClick(Sender: TObject);
begin
  Button10.SetFocus;
  Ravno;
end;

procedure TForm1.ButtonBSClick(Sender: TObject);
begin
  if (state<>MyStates.ERROR) then begin
     if length(Output.Text)>=2 then
        output.Text:=copy(Output.Text, 1, length(Output.Text)-1) else
     if length(Output.Text)=1 then
        output.Text:='0';
  end;
end;

procedure TForm1.ButtonpmClick(Sender: TObject);
begin
  Button10.SetFocus;
  if state = Mystates.OK then
    if Output.Text <> '0' then
    begin
      pm := not pm;
      if pm then
        Output.Text := '-' + Output.Text;
      if not pm then
        Output.Text := copy(Output.Text, 2, length(Output.Text));
    end;

end;

procedure TForm1.ButtonShareClick(Sender: TObject);
begin
  Button10.SetFocus;
  procshare;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  state := MyStates.OK;
  Oper := OpStates.NONE;
end;

procedure TForm1.minusClick(Sender: TObject);
begin
  Button10.SetFocus;
  procminus;
end;

procedure TForm1.Ravno;
begin
  Button10.SetFocus;
  try
  if (state=MyStates.OK) then begin
    if Oper = OpStates.PLUS then
    begin
      output1.Text := '';
      output.Text :=floattostr((x+ strtofloat(output.Text)));
    end;
    if Oper = OpStates.MINUS then
    begin
      output1.Text := '';
      output.Text := floattostr(x - strtofloat(output.Text));
    end;
    if Oper = OpStates.SHARE then
    begin
      output1.Text := '';
      try
        output.Text :=floattostr(x / strtofloat(output.Text));
      except
        Output1.Text := 'Деление на ноль';
        state := MyStates.ERROR;
      end;
    end;
    if Oper = OpStates.MULTIPLY then
    begin
      if x * strtofloat(output.Text)>power(10,15) then begin;
        s:=output.Font.Size;
        output.MaxLength:=21;output.Font.Size:=output.Font.Size-3;
      end;
      output1.Text := '';
      output.Text :=floattostr(x * strtofloat(output.Text));
    end;
    Oper:= OpStates.NONE;
    if state <> MyStates.ERROR then state:=Mystates.AFTER_OPERATION;
    per:=false;
  end;
  except
    Output1.Text := 'Деление на ноль';
    state := MyStates.ERROR;
  end;
end;

procedure TForm1.procplus;
begin
  Button10.SetFocus;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper = OpStates.PLUS))then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' +';
    output.Text :=floattostr((x + strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.PLUS;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper <> OpStates.NONE) and (Oper <> OpStates.PLUS))then
  begin
     output1.Text:=copy(output1.Text,1,length(output1.Text)-1) + '+';
     Oper := OpStates.PLUS;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and
    (Oper = OpStates.NONE) then
  begin
    x := strtofloat(output.Text);
    output1.Text :=output1.Text+ ' ' +  output.Text + ' +';
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.PLUS;
  end;
end;

procedure TForm1.procminus;
begin
  Button10.SetFocus;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper = OpStates.MINUS))then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' -';
    output.Text :=floattostr((x - strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MINUS;
  end;
  if (state = MyStates.OK) and (Oper = OpStates.PLUS) then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' -';
    output.Text :=floattostr((x + strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MINUS;
  end;
  if (state = MyStates.OK) and (Oper = OpStates.PLUS) then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' -';
    output.Text :=floattostr((x + strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MINUS;
  end;
  if (state = MyStates.AFTER_OPERATION) and ((Oper <> OpStates.NONE) and (Oper <> OpStates.MINUS)) then
  begin
    output1.Text:=copy(output1.Text,1,length(output1.Text)-1) + '-';
    Oper := OpStates.MINUS;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and
    (Oper = OpStates.NONE) then
  begin
    x := strtofloat(output.Text);
    output1.Text :=output1.Text+ ' ' +  output.Text + ' -';
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MINUS;
  end;
end;

procedure TForm1.procmul;
begin
  Button10.SetFocus;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper = OpStates.MULTIPLY))then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' *';
    output.Text :=floattostr((x * strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MULTIPLY;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper <> OpStates.NONE) and (Oper <> OpStates.MULTIPLY))then
  begin
     output1.Text:=copy(output1.Text,1,length(output1.Text)-1) + '*';
     Oper := OpStates.MULTIPLY;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and
    (Oper = OpStates.NONE) then
  begin
    x := strtofloat(output.Text);
    output1.Text :=output1.Text+ ' ' +  output.Text + ' *';
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.MULTIPLY;
  end;
end;

procedure TForm1.procshare;
begin
   Button10.SetFocus;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper = OpStates.SHARE))then
  begin
    output1.Text :=output1.Text+ ' ' + output.Text + ' /';
    output.Text :=floattostr((x / strtofloat(output.Text)));
    x := strtofloat(output.Text);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.SHARE;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and ((Oper <> OpStates.NONE) and (Oper <> OpStates.MULTIPLY))then
  begin
     output1.Text:=copy(output1.Text,1,length(output1.Text)-1) + '/';
     Oper := OpStates.SHARE;
  end;
  if ((state = MyStates.AFTER_OPERATION) or (state = MyStates.OK)) and
    (Oper = OpStates.NONE) then
  begin
    x := strtofloat(output.Text);
    output1.Text :=output1.Text+ ' ' +  output.Text + ' /';
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
    Oper := OpStates.SHARE;
  end;
end;

procedure TForm1.procpersent;
begin
  if (state<>MyStates.ERROR) and (Oper<>OpStates.NONE) and (output1.Text<>'') and (not per) then begin
     output.Text:=floattostr(strtofloat(output.Text)/100*x);
     output1.Text:=output1.Text + ' ' + output.Text;
     per:=true;
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  Button10.SetFocus;
  if (key >= 48) and (key <= 57) then
    print(IntToStr(key - Ord('0')));
  if key = 8 then
    if (state=MyStates.OK) then begin
      if length(Output.Text)>=2 then
        output.Text:=copy(Output.Text, 1, length(Output.Text)-1);
      if length(Output.Text)=1 then
        output.Text:='0';
    end;
  if key = 107 then
    procplus;
  if key = 106 then
    procmul;
  if (key = 109) or (key = 189) then
    procminus;
  if key = 111 then
    procshare;
  if key = 188 then
  begin
    if state = MyStates.OK then
      if not points then
      begin
        if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
        Output.Text := Output.Text + ',';
        points := True;
      end;
    if state = MyStates.AFTER_OPERATION then
    begin
      if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
      state := MyStates.OK;
      Output.Text := '0,';
      points := True;
    end;
  end;
  if key = 13 then
    Ravno;
end;

procedure TForm1.negatClick(Sender: TObject);
var
  x: extended;
begin
  Button10.SetFocus;
  try
    x := strtofloat(Output.Text);
    output1.Text:=output1.Text+' reciproc(' + floattostr(x) + ' )';
    x := 1 / x;
    Output.Text := floattostr(x);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
  except
    begin
      Output1.Text := 'Деление на ноль';
      state := MyStates.ERROR;
    end;
  end;
end;

procedure TForm1.plusClick(Sender: TObject);
begin
  Button10.SetFocus;
  procplus;
end;

procedure TForm1.pointClick(Sender: TObject);
begin
  Button10.SetFocus;
  if state = MyStates.OK then
    if not points then
    begin
      if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
      Output.Text := Output.Text + ',';
      points := True;
    end;
  if state = MyStates.AFTER_OPERATION then
  begin
    if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
    state := MyStates.OK;
    Output.Text := '0,';
    points := True;
  end;
end;

procedure TForm1.Print(ttext: string);
begin
  Button10.SetFocus;
  if state = MyStates.OK then begin
    if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
    if Output.Text = '0' then
      Output.Text := ttext
    else
      Output.Text := Output.Text + ttext;
  end;
  if state = MyStates.AFTER_OPERATION then
  begin
    if s<>0 then begin output.MaxLength:=15;output.Font.Size:=s; s:=0; end;
    Output.Text := ttext;
    state := MyStates.OK;
  end;
end;

procedure TForm1.BsqrtClick(Sender: TObject);
var
  x: extended;
begin
  Button10.SetFocus;
  try
    x := strtofloat(Output.Text);
    output1.Text:=output1.Text + ' sqrt(' + floattostr(x) + ' )';
    x := sqrt(x);
    Output.Text := floattostr(x);
    state := MyStates.AFTER_OPERATION;
    points := False;
    pm := False;
  except
    on EInvalidOp do
    begin
      Output1.Text := 'Недопустимый ввод';
      state := MyStates.ERROR;
    end;
  end;
end;

end.
