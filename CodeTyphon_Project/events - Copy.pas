unit Events;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PythonEngine;

type
 TArrayInfo = record
  Length : Integer;
  Max : Byte;
  Min : Byte;
  Mean : Double;
  Median : Double;
  Mode : Byte;
 end;

 TCompareInfo = record
  Length : Integer;
 end;

 THistoValues = array[0..255] of Integer;

procedure EncoderInput(Input : TBytes);
procedure EncoderOutput(Output : TBytes);
procedure DecoderInput(Input : TBytes);
procedure DecoderOutput(Output : TBytes);

procedure QuickSort(var A : TBytes; Li, Hi : Integer);

function GetArrayMax(A : TBytes) : Byte;
function GetArrayMin(A : TBytes) : Byte;
function GetArrayMean(A : TBytes) : Double;
function GetArrayMedian(A : TBytes) : Double;
function GetArrayHisto(A : TBytes) : THistoValues;
function GetArrayMode(A : TBytes) : Byte;

var
 Engine : TPythonEngine;

implementation

procedure EncoderInput(Input : TBytes);
begin

end;

procedure EncoderOutput(Output: TBytes);
begin

end;

procedure DecoderInput(Input: TBytes);
begin

end;

procedure DecoderOutput(Output: TBytes);
begin

end;

function GetArrayMax(A : TBytes) : Byte;
var
 I : Integer;
begin
 Result := 0;
 if Length(A) < 1 then
  Exit;

 Result := A[Low(A)];
 for I := Low(A) to High(A) do
  begin
   if A[I] > Result then
    Result := A[I];
  end;
end;

function GetArrayMin(A : TBytes) : Byte;
var
 I : Integer;
begin
 Result := 0;
 if Length(A) < 1 then
  Exit;

 Result := A[Low(A)];
 for I := Low(A) to High(A) do
  begin
   if A[I] < Result then
    Result := A[I];
  end;
end;

procedure QuickSort(var A : TBytes; Li, Hi : Integer);
var
 L, H, C, Temp : Integer;
begin
 L := Low(A);
 H := High(A);

 C := A[(L + H) div 2];

 repeat
  while A[L] < C do Inc(L);
  while A[H] > C do Dec(H);
   if L <= H then
    begin
     Temp := A[L];
     A[L] := A[H];
     A[H] := Temp;

     Inc(L);
     Dec(H);
    end;
 until L > H;

 if H > Li then QuickSort(A, Li, H);
 if L < Hi then QuickSort(A, L, Hi);
end;

function GetArrayMean(A : TBytes) : Double;
var
 I, S : Integer;
begin
 Result := 0;
 if Length(A) < 1 then
  Exit;

 for I := Low(A) to High(A) do
  S := S + A[I];

 Result := S / Length(A);
end;

function GetArrayMedian(A : TBytes) : Double;
var
 M1, M2 : Integer;
begin
 Result := 0;
 if Length(A) < 1 then
  Exit;

 QuickSort(A, Low(A), High(A));

 case (Length(A) div 2) of
  0 : begin
       M1 := A[Trunc((Low(A) + High(A)) div 2)];
       M2 := A[Trunc((Low(A) + High(A)) div 2) + 1];
       Result := (M1 + M2) / 2;
      end;

  1 : Result := A[((Low(A) + High(A)) div 2) + 1];
 end;
end;

function GetArrayHisto(A : TBytes) : THistoValues;
var
 I : Integer;
begin
 for I := 0 to 255 do
  Result[I] := 0;

 if Length(A) < 1 then
  Exit;

 for I := Low(A) to High(A) do
  Result[A[I]] := Result[A[I]] + 1;
end;

function GetArrayMode(A : TBytes) : Byte;
var
 H : THistoValues;
 I : Integer;
begin
 Result := 0;
 if Length(A) < 1 then
  Exit;

 for I := 0 to 255 do
  H[I] := 0;

 H := GetArrayHisto(A);

 Result := 0;
 for I := 1 to 255 do
  begin
   if H[I] > H[Result] then
    Result := I;
  end;
end;

initialization

finalization

end.

