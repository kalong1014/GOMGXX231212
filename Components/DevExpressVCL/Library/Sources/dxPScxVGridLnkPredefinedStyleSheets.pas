﻿{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressPrinting System                                   }
{                                                                    }
{           Copyright (C) 1998-2019 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSPRINTING SYSTEM AND            }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN                      }
{   EXECUTABLE PROGRAM ONLY.                                         }
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

unit dxPScxVGridLnkPredefinedStyleSheets;

interface

{$I cxVer.inc}

uses
  Classes, Forms, cxClasses, cxStyles, dxPScxVGridLnk, dxPScxCommon;

type
  TcxdmPScxVGridLnkPredefinedStyles = class(TDataModule)
    StyleRepository: TcxStyleRepository;
    styleGrayCategory: TcxStyle;
    styleProfessionalCategory: TcxStyle;
    styleGrayHeader: TcxStyle;
    styleProfessionalHeader: TcxStyle;
    styleNoneContent: TcxStyle;
    ssProfessional: TcxVerticalGridReportLinkStyleSheet;
    ssGray: TcxVerticalGridReportLinkStyleSheet;
    ssTransparent: TcxVerticalGridReportLinkStyleSheet;
    styleTransparentCategory: TcxStyle;
    styleTransparentHeader: TcxStyle;
    styleTransparentContent: TcxStyle;
  end;

implementation

{$R *.dfm}

uses
  cxStyleSheetsLoad;

type
  TcxPScxVGridLnkPredefinedStyleSheets = class(TcxPredefinedStyleSheets)
  private
    FDataModule: TcxdmPScxVGridLnkPredefinedStyles;
  protected
    procedure AddStyleSheets; override;
    property DataModule: TcxdmPScxVGridLnkPredefinedStyles read FDataModule;
  public
    constructor Create; override;
    destructor Destroy; override;

    class procedure Register;
    class procedure Unregister;
  end;

constructor TcxPScxVGridLnkPredefinedStyleSheets.Create;
begin
  inherited;
  FDataModule := TcxdmPScxVGridLnkPredefinedStyles.Create(nil);
  AddStyleSheets;
end;

destructor TcxPScxVGridLnkPredefinedStyleSheets.Destroy;
begin
  FDataModule.Free;
  inherited;
end;

class procedure TcxPScxVGridLnkPredefinedStyleSheets.Register;
begin
  cxStyleSheetsLoad.RegisterPredefinedStyleSheets(Self);
end;

class procedure TcxPScxVGridLnkPredefinedStyleSheets.Unregister;
begin
  cxStyleSheetsLoad.UnregisterPredefinedStyleSheets(Self);
end;

procedure TcxPScxVGridLnkPredefinedStyleSheets.AddStyleSheets;
var
  I: Integer;
begin
  with DataModule.StyleRepository do
    for I := 0 to StyleSheetCount - 1 do
      AddStyleSheet(StyleSheets[I]);
end;

initialization
  TcxPScxVGridLnkPredefinedStyleSheets.Register;

finalization
  TcxPScxVGridLnkPredefinedStyleSheets.Unregister;

end.
