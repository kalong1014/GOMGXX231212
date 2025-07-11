unit AsphyreXML;
//---------------------------------------------------------------------------
// AsphyreXML.pas                                       Modified: 14-Sep-2012
// Minimalistic Asphyre XML wrapper for loading field values.    Version 1.06
//---------------------------------------------------------------------------
// Note: This component doesn't read or write data parts of XML and is
// primarily used to read nodes and their attributes only, mainly used in
// configuration files.
//---------------------------------------------------------------------------
// Important Notice:
//
// If you modify/use this code or one of its parts either in original or
// modified form, you must comply with Mozilla Public License Version 2.0,
// including section 3, "Responsibilities". Failure to do so will result in
// the license breach, which will be resolved in the court. Remember that
// violating author's rights either accidentally or intentionally is
// considered a serious crime in many countries. Thank you!
//
// !! Please *read* Mozilla Public License 2.0 document located at:
//  http://www.mozilla.org/MPL/
//
// If you require any clarifications about the license, feel free to contact
// us or post your question on our forums at: http://www.afterwarp.net
//---------------------------------------------------------------------------
// The contents of this file are subject to the Mozilla Public License
// Version 2.0 (the "License"); you may not use this file except in
// compliance with the License. You may obtain a copy of the License at
// http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS"
// basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
// License for the specific language governing rights and limitations
// under the License.
//
// The Original Code is AsphyreXML.pas.
//
// The Initial Developer of the Original Code is Yuriy Kotsarenko.
// Portions created by Yuriy Kotsarenko are Copyright (C) 2000 - 2012,
// Yuriy Kotsarenko. All Rights Reserved.
//---------------------------------------------------------------------------
interface

//---------------------------------------------------------------------------
{$include AsphyreConfig.inc}

//---------------------------------------------------------------------------
{$ifdef Delphi2009Up}
{$warn implicit_string_cast off}
{$warn implicit_string_cast_loss off}
{$endif}

//---------------------------------------------------------------------------
uses
 Classes, AspLibXMLParser, AsphyreDef, AsphyreArchives;

//---------------------------------------------------------------------------
type
 PXMLNodeField = ^TXMLNodeField;
 TXMLNodeField = record
  Name : StdString;
  Value: StdString;
 end;

//---------------------------------------------------------------------------
 TXMLNode = class;

//---------------------------------------------------------------------------
 TXMLNodeEnumerator = class
 private
  FNode: TXMLNode;
  Index: Integer;

  function GetCurrent(): TXMLNode;
 public
  property Current: TXMLNode read GetCurrent;

  function MoveNext(): Boolean;
  constructor Create(Node: TXMLNode);
 end;

//---------------------------------------------------------------------------
 TXMLNode = class
 private
  FName : StdString;
  Nodes : array of TXMLNode;
  Fields: array of TXMLNodeField;

  function GetChildCount(): Integer;
  function GetChild(Index: Integer): TXMLNode;
  function GetChildNode(const AName: StdString): TXMLNode;
  function GetFieldCount(): Integer;
  function GetField(Index: Integer): PXMLNodeField;
  function GetFieldValue(const AName: StdString): StdString;
  procedure SetFieldValue(const AName: StdString; const Value: StdString);
  function SubCode(Spacing: Integer): StdString;
 public
  property Name: StdString read FName;

  property ChildCount: Integer read GetChildCount;
  property Child[Index: Integer]: TXMLNode read GetChild;
  property ChildNode[const AName: StdString]: TXMLNode read GetChildNode;

  property FieldCount: Integer read GetFieldCount;
  property Field[Index: Integer]: PXMLNodeField read GetField;
  property FieldValue[const AName: StdString]: StdString read GetFieldValue
   write SetFieldValue;

  function AddChild(const AName: StdString): TXMLNode;
  function FindChildByName(const AName: StdString): Integer;

  function AddField(const AName: StdString;
   const Value: StdString): PXMLNodeField;
  function FindFieldByName(const AName: StdString): Integer;

  function GetCode(): StdString;

  procedure SaveToFile(const FileName: StdString);
  function SaveToStream(OutStream: TStream): Boolean;

  function SaveToArchive(const Key: UniString;
   Archive: TAsphyreArchive): Boolean; overload;
  function SaveToArchive(const Key: UniString;
   const ArchiveName: StdString): Boolean; overload;

  function GetEnumerator(): TXMLNodeEnumerator;

  constructor Create(const AName: StdString);
  destructor Destroy(); override;
 end;

//---------------------------------------------------------------------------
function LoadXMLFromFile(const FileName: StdString): TXMLNode;
function LoadXMLFromStream(InStream: TStream): TXMLNode;
function LoadXMLFromArchive(const Key: UniString;
 Archive: TAsphyreArchive): TXMLNode; overload;
function LoadXMLFromArchive(const Key: UniString;
 const ArchiveName: StdString): TXMLNode; overload;

//---------------------------------------------------------------------------
implementation

//---------------------------------------------------------------------------
uses
 SysUtils, AsphyreAuth;

//---------------------------------------------------------------------------
function Spaces(Count: Integer): StdString;
var
 i: Integer;
begin
 Result:= '';

 for i:= 0 to Count - 1 do
  Result:= Result + ' ';
end;

//---------------------------------------------------------------------------
constructor TXMLNode.Create(const AName: StdString);
begin
 inherited Create();

 FName:= AName;
end;

//---------------------------------------------------------------------------
destructor TXMLNode.Destroy();
var
 i: Integer;
begin
 for i:= 0 to Length(Nodes) - 1 do
  if (Assigned(Nodes[i])) then FreeAndNil(Nodes[i]);
   
 SetLength(Nodes, 0);

 inherited;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChildCount(): Integer;
begin
 Result:= Length(Nodes);
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChild(Index: Integer): TXMLNode;
begin
 if (Index >= 0)and(Index < Length(Nodes)) then
  Result:= Nodes[Index]
   else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.FindChildByName(const AName: StdString): Integer;
var
 i: Integer;
begin
 Result:= -1;
 for i:= 0 to Length(Nodes) - 1 do
  if (SameText(Nodes[i].Name, AName)) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetChildNode(const AName: StdString): TXMLNode;
var
 Index: Integer;
begin
 Index:= FindChildByName(AName);
 if (Index <> -1) then Result:= Nodes[Index]
  else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetFieldCount(): Integer;
begin
 Result:= Length(Fields);
end;

//---------------------------------------------------------------------------
function TXMLNode.GetField(Index: Integer): PXMLNodeField;
begin
 if (Index >= 0)and(Index < Length(Fields)) then
  Result:= @Fields[Index]
   else Result:= nil;
end;

//---------------------------------------------------------------------------
function TXMLNode.FindFieldByName(const AName: StdString): Integer;
var
 i: Integer;
begin
 Result:= -1;

 for i:= 0 to Length(Fields) - 1 do
  if (SameText(Fields[i].Name, AName)) then
   begin
    Result:= i;
    Break;
   end;
end;

//---------------------------------------------------------------------------
function TXMLNode.GetFieldValue(const AName: StdString): StdString;
var
 Index: Integer;
begin
 Index:= FindFieldByName(AName);

 if (Index <> -1) then
  Result:= Fields[Index].Value
   else Result:= '';
end;

//---------------------------------------------------------------------------
procedure TXMLNode.SetFieldValue(const AName: StdString;
 const Value: StdString);
var
 Index: Integer;
begin
 Index:= FindFieldByName(AName);

 if (Index <> -1) then
  Fields[Index].Value:= Value
   else AddField(AName, Value);
end;

//---------------------------------------------------------------------------
function TXMLNode.AddChild(const AName: StdString): TXMLNode;
var
 Index: Integer;
begin
 Index:= Length(Nodes);
 SetLength(Nodes, Index + 1);

 Nodes[Index]:= TXMLNode.Create(AName);
 Result:= Nodes[Index];
end;

//---------------------------------------------------------------------------
function TXMLNode.AddField(const AName: StdString;
 const Value: StdString): PXMLNodeField;
var
 Index: Integer;
begin
 Index:= Length(Fields);
 SetLength(Fields, Index + 1);

 Fields[Index].Name := AName;
 Fields[Index].Value:= Value;
 Result:= @Fields[Index];
end;

//---------------------------------------------------------------------------
function TXMLNode.SubCode(Spacing: Integer): StdString;
var
 st: StdString;
 i: Integer;
begin
 st:= Spaces(Spacing) + '<' + FName;
 if (Length(Fields) > 0) then
  begin
   st:= st + ' ';
   for i:= 0 to Length(Fields) - 1 do
    begin
     st:= st + Fields[i].Name + '="' + Fields[i].Value + '"';
     if (i < Length(Fields) - 1) then st:= st + ' ';
    end;
  end;

 if (Length(Nodes) > 0) then
  begin
   st:= st + '>'#13#10;
   for i:= 0 to Length(Nodes) - 1 do
    st:= st + Nodes[i].SubCode(Spacing + 1);
   st:= st + Spaces(Spacing) + '</' + FName + '>'#13#10; 
  end else st:= st + ' />'#13#10;

 Result:= st; 
end;

//---------------------------------------------------------------------------
function TXMLNode.GetCode(): StdString;
begin
 Result:= SubCode(0);
end;

//---------------------------------------------------------------------------
procedure TXMLNode.SaveToFile(const FileName: StdString);
var
 Strings: TStrings;
begin
 Strings:= TStringList.Create();
 Strings.Text:= GetCode();

 try
  Strings.SaveToFile(FileName);
 finally
  FreeAndNil(Strings);
 end;
end;

//---------------------------------------------------------------------------
function TXMLNode.SaveToStream(OutStream: TStream): Boolean;
var
 Strings: TStrings;
begin
 Strings:= TStringList.Create();
 Strings.Text:= GetCode();

 Result:= True;
 try
  try
   Strings.SaveToStream(OutStream);
  except
   Result:= False;
  end;
 finally
  FreeAndNil(Strings);
 end;
end;

//---------------------------------------------------------------------------
function TXMLNode.SaveToArchive(const Key: UniString;
 Archive: TAsphyreArchive): Boolean;
var
 Stream: TMemoryStream;
begin
 if (not Assigned(Archive)) then
  begin
   Result:= False;
   Exit;
  end;

 Stream:= TMemoryStream.Create();

 Result:= SaveToStream(Stream);
 if (not Result) then
  begin
   FreeAndNil(Stream);
   Exit;
  end;

 Auth.Authorize(Self, Archive);

 Result:= Archive.WriteRecord(Key, Stream.Memory, Stream.Size);

 Auth.Unauthorize();

 FreeAndNil(Stream);
end;

//---------------------------------------------------------------------------
function TXMLNode.SaveToArchive(const Key: UniString;
 const ArchiveName: StdString): Boolean;
var
 Archive: TAsphyreArchive;
begin
 Archive:= TAsphyreArchive.Create();

 Result:= Archive.OpenFile(ArchiveName);
 if (not Result) then
  begin
   FreeAndNil(Archive);
   Exit;
  end;

 Result:= SaveToArchive(Key, Archive);

 FreeAndNil(Archive);
end;

//---------------------------------------------------------------------------
function TXMLNode.GetEnumerator(): TXMLNodeEnumerator;
begin
 Result:= TXMLNodeEnumerator.Create(Self);
end;

//---------------------------------------------------------------------------
constructor TXMLNodeEnumerator.Create(Node: TXMLNode);
begin
 inherited Create();

 FNode:= Node;
 Index:= -1;
end;

//---------------------------------------------------------------------------
function TXMLNodeEnumerator.GetCurrent(): TXMLNode;
begin
 Result:= FNode.Child[Index];
end;

//---------------------------------------------------------------------------
function TXMLNodeEnumerator.MoveNext(): Boolean;
begin
 Result:= Index < FNode.ChildCount - 1;
 if (Result) then Inc(Index);
end;

//--------------------------------------------------------------------------
function LoadEmptyRootNode(Parser: TXMLParser): TXMLNode;
var
 i: Integer;
begin
 Result:= TXMLNode.Create(Parser.CurName);

 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   Result.AddField(Name(i), Value(i));
end;

//---------------------------------------------------------------------------
procedure LoadNodeBody(TopNode: TXMLNode; Parser: TXMLParser);
var
 Aux: TXMLNode;
 i: Integer;
begin
 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   TopNode.AddField(Name(i), Value(i));

 while (Parser.Scan()) do
  case Parser.CurPartType of
   ptEndTag:
    Break;

   ptEmptyTag:
    begin
     Aux:= TopNode.AddChild(Parser.CurName);

     with Parser.CurAttr do
      for i:= 0 to Count - 1 do
       Aux.AddField(Name(i), Value(i));
    end;

   ptStartTag:
    begin
     Aux:= TopNode.AddChild(Parser.CurName);
     LoadNodeBody(Aux, Parser);
    end;
  end;
end;

//---------------------------------------------------------------------------
function LoadRootNode(Parser: TXMLParser): TXMLNode;
var
 Aux: TXMLNode;
 i: Integer;
begin
 Result:= TXMLNode.Create(Parser.CurName);

 // -> read attributes of root node
 with Parser.CurAttr do
  for i:= 0 to Count - 1 do
   Result.AddField(Name(i), Value(i));

 // -> parse body
 while (Parser.Scan()) do
  case Parser.CurPartType of
   // exit out of root node
   ptEndTag:
    Break;

   // empty node inside of root node
   ptEmptyTag:
    begin
     Aux:= Result.AddChild(Parser.CurName);

     with Parser.CurAttr do
      for i:= 0 to Count - 1 do
       Aux.AddField(Name(i), Value(i));
    end;

   // new node owned by root node
   ptStartTag:
    begin
     Aux:= Result.AddChild(Parser.CurName);
     LoadNodeBody(Aux, Parser);
    end;
  end;
end;

//---------------------------------------------------------------------------
function LoadXMLFromFile(const FileName: StdString): TXMLNode;
var
 Parser: TXMLParser;
begin
 Result:= nil;

 Parser:= TXMLParser.Create();
 try
  Parser.LoadFromFile(FileName);

  Parser.Normalize:= False;
  Parser.StartScan();

  while (Parser.Scan()) do
   case Parser.CurPartType of
    ptEmptyTag:
     begin
      Result:= LoadEmptyRootNode(Parser);
      Break;
     end;

    ptStartTag:
     begin
      Result:= LoadRootNode(Parser);
      Break;
     end;
   end;

 finally
  FreeAndNil(Parser);
 end;
end;

//---------------------------------------------------------------------------
function LoadXMLFromStream(InStream: TStream): TXMLNode;
var
 Strings: TStrings;
 Parser : TXMLParser;
 Text   : AnsiString;
begin
 Result:= nil;

 Strings:= TStringList.Create();
 Parser:= TXMLParser.Create();
 try
  try
   Strings.LoadFromStream(InStream);

   Text:= Strings.Text;
   Parser.LoadFromBuffer(PAnsiChar(Text));

   Parser.Normalize:= False;
   Parser.StartScan();

   while (Parser.Scan()) do
    case Parser.CurPartType of
     ptEmptyTag:
      begin
       Result:= LoadEmptyRootNode(Parser);
       Break;
      end;

     ptStartTag:
      begin
       Result:= LoadRootNode(Parser);
       Break;
      end;
    end;
  except
   FreeAndNil(Result);
  end;

 finally
  FreeAndNil(Strings);
  FreeAndNil(Parser);
 end;
end;

//---------------------------------------------------------------------------
function LoadXMLFromArchive(const Key: UniString;
 Archive: TAsphyreArchive): TXMLNode; overload;
var
 Stream: TMemoryStream;
begin
 Result:= nil;
 if (not Assigned(Archive)) then Exit;

 Stream:= TMemoryStream.Create();

 Auth.Authorize(nil, Archive);

 if (not Archive.ReadStream(Key, Stream)) then
  begin
   FreeAndNil(Stream);
   Exit;
  end;

 Auth.Unauthorize();

 Stream.Seek(0, soFromBeginning);

 Result:= LoadXMLFromStream(Stream);

 FreeAndNil(Stream);
end;

//---------------------------------------------------------------------------
function LoadXMLFromArchive(const Key: UniString;
 const ArchiveName: StdString): TXMLNode; overload;
var
 Archive: TAsphyreArchive;
begin
 Archive:= TAsphyreArchive.Create();
 Archive.OpenMode:= aomReadOnly;

 if (not Archive.OpenFile(ArchiveName)) then
  begin
   Result:= nil;
   Exit;
  end;

 Result:= LoadXMLFromArchive(Key, Archive);
 FreeAndNil(Archive);
end;

//---------------------------------------------------------------------------
end.

