﻿{********************************************************************}
{                                                                    }
{           Developer Express Visual Component Library               }
{           ExpressMapControl                                        }
{                                                                    }
{           Copyright (c) 2013-2019 Developer Express Inc.           }
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
{   LICENSED TO DISTRIBUTE THE EXPRESSMAPCONTROL AND ALL             }
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

unit dxMapControlHttpRequest;

interface

{$I cxVer.inc}

uses
  Classes, IdHTTPHeaderInfo, dxHttpRequest, dxHttpIndyRequest;

type
  TdxMapControlHttpRequestMode = TdxHttpRequestMode;
  TdxMapControlHttpRequestEvent = TdxHttpRequestEvent;

  TdxMapControlHttpRequest = class(TdxHttpIndyRequest);

function GetContent(const AUri: string; AResponseContent: TStream): Boolean;
function dxParamsEncode(const ASrc: string): string;
function dxMapControlHttpDefaultProxyInfo: TIdProxyConnectionInfo;

implementation

function dxMapControlHttpDefaultProxyInfo: TIdProxyConnectionInfo;
begin
  Result := dxHttpIndyDefaultProxyInfo;
end;

function GetContent(const AUri: string; AResponseContent: TStream): Boolean;
begin
  Result := dxHttpIndyRequest.GetContent(AUri, AResponseContent);
end;

function dxParamsEncode(const ASrc: string): string;
begin
  Result := dxHttpIndyRequest.dxParamsEncode(ASrc);
end;

end.
