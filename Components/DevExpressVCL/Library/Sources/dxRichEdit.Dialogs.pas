﻿{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressRichEditControl                                   }
{                                                                    }
{           Copyright (c) 2000-2019 Developer Express Inc.           }
{           ALL RIGHTS RESERVED                                      }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSRICHEDITCONTROL AND ALL        }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM       }
{   ONLY.                                                            }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit dxRichEdit.Dialogs;

{$I cxVer.inc}
{$I dxRichEditControl.inc}

interface

type
  TdxRichEditDialogs = class abstract
  public
    class function InputBox(const ACaption, APrompt, ADefault: string): string; static;
    class function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean; overload; static;
  end;

implementation

uses
{$IFDEF DELPHIXE2}
  System.UITypes,
{$ENDIF}
  Forms, Controls,
  dxLayoutCommon, dxLayoutContainer,
  dxRichEdit.Dialogs.CustomDialog,
  dxRichEdit.Dialogs.InputBox;

{ TdxRichEditDialogs }

class function TdxRichEditDialogs.InputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  InputQuery(ACaption, APrompt, Result);
end;

class function TdxRichEditDialogs.InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
var
  AForm: TdxRichEditDialogInputBox;
begin
  Result := False;
  AForm := TdxRichEditDialogInputBox.Create(Application);
  try
    AForm.Caption := ACaption;
    AForm.liPrompt.CaptionOptions.Text := APrompt;
    AForm.edtValue.Text := Value;
    AForm.ApplyLocalization;
    if AForm.ShowModal = mrOk then
    begin
      Value := AForm.edtValue.Text;
      Result := True;
    end;
  finally
    AForm.Free;
  end;
end;

end.
