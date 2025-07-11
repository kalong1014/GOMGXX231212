{$B-} { Complete Boolean Evaluation }
{$R-} { Range-Checking }
{$T-} { Typed @ operator }
{$X+} { Extended syntax }
{$P+} { Open string params }
{$J+} { Writeable structured consts }
{$H+} { Use long strings by default }
{$Q-} { Overflow checking }
{$Z1} { Minimum enum size }

{$IFNDEF CLR}
  {$IFNDEF DONTUSEJPEGIMAGE}
    {$DEFINE USEJPEGIMAGE}
  {$ENDIF}
{$ENDIF}

// Keep commented out to avoid C++Builder compilation errors
// {$WEAKLINKRTTI ON}
// {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}

{$SCOPEDENUMS OFF}
{$DEFINE DXREGISTERPNGIMAGE}
{$DEFINE VCL}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
    {$DEFINE DELPHI3} { Borland Delphi 3.0 }
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER110} { Borland C++Builder 3.0 }
  {$DEFINE CBUILDER3}
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER120} { Borland Delphi 4.0 }
  {$DEFINE DELPHI4}
{$ENDIF}

{$IFDEF VER125} { Borland C++Builder 4.0 }
  {$DEFINE CBUILDER3}
  {$DEFINE DELPHI4}
  {$DEFINE CBUILDER4}
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER130} { Borland Delphi 5.0 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$IFDEF BCB}  { Borland C++Builder 5.0 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER140} { Borland Delphi 6.0 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$IFDEF BCB}  { Borland C++Builder 6.0 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER150} { Borland Delphi 7.0 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
{$ENDIF}

// obsolete
{.$IFNDEF DELPHI6}
  {.$DEFINE MSWINDOWS}
{.$ENDIF}
{.$IFDEF LINUX}
  {.$UNDEF MSWINDOWS}
{.$ENDIF}

{$IFDEF LINUX}
  {$DEFINE KYLIX1}     { Borland Kylix 1 }
  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF CompilerVersion >= 14}
      {$DEFINE KYLIX2} { Borland Kylix 2 }
    {$IFEND}
    {$IF CompilerVersion >= 14.50}
      {$DEFINE KYLIX3} { Borland Kylix 3 }
    {$IFEND}
  {$ENDIF}
{$ENDIF}

{$IFDEF CLR} { Borland Delphi.Net }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
{$ENDIF}

{$IFDEF VER170} { Borland Delphi 9.0 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
{$ENDIF}

{$IFDEF VER180} { Borland Delphi 10 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$IFDEF BCB}  { Borland C++Builder 10 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER185} { Borland Delphi 11 //CodeGear}
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$IFDEF BCB}  { Borland C++Builder 11 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER200} { Borland Delphi 12 //CodeGear/Tiburon}
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$IFDEF BCB}  { Borland C++Builder 12 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER210} { Borland Delphi 14 //CodeGear/Weaver}
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$IFDEF BCB}  { Borland C++Builder 14 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER220} { Embarcadero Delphi 15 XE }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHIXE}
  {$IFDEF BCB}  { Embarcadero C++Builder 15 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDERXE}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER230} { Embarcadero Delphi 16 XE2 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$IFDEF BCB}  { Embarcadero C++Builder 16 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER240} { Embarcadero Delphi 17 XE3 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$IFDEF BCB}  { Embarcadero C++Builder 17 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER250} { Embarcadero Delphi 18 XE4 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$IFDEF BCB}  { Embarcadero C++Builder 18 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER260} { Embarcadero Delphi 19 XE5 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$IFDEF BCB}  { Embarcadero C++Builder 19 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER270} { Embarcadero Delphi 20 XE6 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$IFDEF BCB}  { Embarcadero C++Builder 20 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER280} { Embarcadero Delphi 21 XE7 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$IFDEF BCB}  { Embarcadero C++Builder 21 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER290} { Embarcadero Delphi 22 XE8 }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$IFDEF BCB}  { Embarcadero C++Builder 22 }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER300} { Embarcadero Delphi 10 Seattle }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$DEFINE DELPHI10SEATTLE}
  {$IFDEF BCB}  { Embarcadero C++Builder 10 Seattle }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$DEFINE CBUILDER10SEATTLE}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER310} { Embarcadero Delphi Berlin }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$DEFINE DELPHI10SEATTLE}
  {$DEFINE DELPHI101BERLIN}
  {$DEFINE DELPHIBERLIN}
  {$IFDEF BCB}  { Embarcadero C++Builder Berlin }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$DEFINE CBUILDER10SEATTLE}
    {$DEFINE CBUILDER101BERLIN}
    {$DEFINE CBUILDERBERLIN}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER320} { Embarcadero Delphi Tokyo }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$DEFINE DELPHI10SEATTLE}
  {$DEFINE DELPHI101BERLIN}
  {$DEFINE DELPHI102TOKYO}
  {$DEFINE DELPHIBERLIN}
  {$IFDEF BCB}  { Embarcadero C++Builder Tokyo }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$DEFINE CBUILDER10SEATTLE}
    {$DEFINE CBUILDER101BERLIN}
    {$DEFINE CBUILDERBERLIN}
    {$DEFINE CBUILDER102TOKYO}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER330} { Embarcadero Delphi Rio }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$DEFINE DELPHI10SEATTLE}
  {$DEFINE DELPHI101BERLIN}
  {$DEFINE DELPHI102TOKYO}
  {$DEFINE DELPHIBERLIN}
  {$DEFINE DELPHI103}
  {$DEFINE DELPHI103RIO}
  {$IFDEF BCB}  { Embarcadero C++Builder Rio }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$DEFINE CBUILDER10SEATTLE}
    {$DEFINE CBUILDER101BERLIN}
    {$DEFINE CBUILDERBERLIN}
    {$DEFINE CBUILDER102TOKYO}
    {$DEFINE CBUILDER103}
    {$DEFINE CBUILDER103RIO}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER340} { Embarcadero Delphi Sydney }
  {$DEFINE DELPHI4}
  {$DEFINE DELPHI5}
  {$DEFINE DELPHI6}
  {$DEFINE DELPHI7}
  {$DEFINE DELPHI8}
  {$DEFINE DELPHI9}
  {$DEFINE DELPHI10}
  {$DEFINE DELPHI11}
  {$DEFINE DELPHI12}
  {$DEFINE DELPHI14}
  {$DEFINE DELPHI15}
  {$DEFINE DELPHI16}
  {$DEFINE DELPHI17}
  {$DEFINE DELPHI18}
  {$DEFINE DELPHI19}
  {$DEFINE DELPHI20}
  {$DEFINE DELPHI21}
  {$DEFINE DELPHI22}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
  {$DEFINE DELPHIXE8}
  {$DEFINE DELPHI10SEATTLE}
  {$DEFINE DELPHI101BERLIN}
  {$DEFINE DELPHI102TOKYO}
  {$DEFINE DELPHIBERLIN}
  {$DEFINE DELPHI103}
  {$DEFINE DELPHI103RIO}
  {$DEFINE DELPHI104}
  {$DEFINE DELPHI104SYDNEY}
  {$IFDEF BCB}  { Embarcadero C++Builder Sydney }
    {$DEFINE CBUILDER3}
    {$DEFINE CBUILDER4}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER6}
    {$DEFINE CBUILDER10}
    {$DEFINE CBUILDER11}
    {$DEFINE CBUILDER12}
    {$DEFINE CBUILDER14}
    {$DEFINE CBUILDER15}
    {$DEFINE CBUILDER16}
    {$DEFINE CBUILDER17}
    {$DEFINE CBUILDER18}
    {$DEFINE CBUILDER19}
    {$DEFINE CBUILDER20}
    {$DEFINE CBUILDER21}
    {$DEFINE CBUILDER22}
    {$DEFINE CBUILDERXE}
    {$DEFINE CBUILDERXE2}
    {$DEFINE CBUILDERXE3}
    {$DEFINE CBUILDERXE4}
    {$DEFINE CBUILDERXE5}
    {$DEFINE CBUILDERXE6}
    {$DEFINE CBUILDERXE7}
    {$DEFINE CBUILDERXE8}
    {$DEFINE CBUILDER10SEATTLE}
    {$DEFINE CBUILDER101BERLIN}
    {$DEFINE CBUILDERBERLIN}
    {$DEFINE CBUILDER102TOKYO}
    {$DEFINE CBUILDER103}
    {$DEFINE CBUILDER103RIO}
    {$DEFINE CBUILDER104}
    {$DEFINE CBUILDER104SYDNEY}
    {$ObjExportAll On}
  {$ENDIF}
{$ENDIF}

{$IFNDEF BCB}
  {$IFDEF DELPHI6}
    {$DEFINE REGISTERSHELLCTRLS}
  {$ENDIF}
{$ENDIF}

{$IFDEF REGISTERSHELLCTRLS}
  {$DEFINE REGISTERCXSHELLCTRLS}
{$ENDIF}

{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
{$ENDIF}

{$IFDEF DELPHI7}
  {$WARN UNSAFE_CAST OFF}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

{$IFDEF DELPHI102TOKYO}
  {$IFNDEF CXTEST}
    {$WARN EXPLICIT_STRING_CAST OFF}        // W1059
    {$WARN EXPLICIT_STRING_CAST_LOSS OFF}   // W1060
    {$WARN IMPLICIT_INTEGER_CAST_LOSS OFF}  // W1071
    {$WARN IMPLICIT_CONVERSION_LOSS OFF}    // W1072
    {$WARN COMBINING_SIGNED_UNSIGNED64 OFF} // W1073
    {$IFDEF WIN64}
      {$WARN LOST_EXTENDED_PRECISION OFF}   // W1066
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IF defined(BCB) or defined(DELPHI10)}
  {$DEFINE BCBCOMPATIBLE}
{$IFEND}

{$IFDEF DELPHI12}
  {$DEFINE VCLGLASSPAINT}
{$ENDIF}
{$DEFINE USENATIVELOOKANDFEELASDEFAULT}
{$DEFINE USETOUCHSCROLLUIMODEASDEFAULT}
{Begin Of Platform Defines}
{$IF defined(VER330)}
  {$DEFINE EXPRESSCORE}
  {$DEFINE EXPRESSTHEME}
  {$DEFINE EXPRESSGDIPLUS}
  {$DEFINE EXPRESSCOMMON}
  {$DEFINE EXPRESSLIBRARY}
  {$DEFINE EXPRESSDATACONTROLLER}
  {$DEFINE EXPRESSPAGECONTROL}
  {$DEFINE EXPRESSOFFICECORE}
  {$DEFINE EXPRESSEDITORS}
  {$DEFINE EXPRESSWIZARDCONTROL}
  {$DEFINE EXPRESSLAYOUTCONTROL}
  {$DEFINE EXPRESSDOCKINGLIBRARY}
  {$DEFINE EXPRESSSPREADSHEETCORE}
  {$DEFINE EXPRESSSPREADSHEET}
  {$DEFINE EXPRESSEXPORT}
  {$DEFINE EXPRESSTREELIST}
  {$DEFINE EXPRESSBARS}
  {$DEFINE EXPRESSVERTICALGRID}
  {$DEFINE EXPRESSMEMDATA}
  {$DEFINE EXPRESSSPELLCHECKER}
  {$DEFINE EXPRESSTILECONTROL}
  {$DEFINE EXPRESSNAVBAR}
  {$DEFINE EXPRESSSKINS}
  {$DEFINE EXPRESSPRINTINGSYSTEM}
  {$DEFINE EXPRESSPIVOTGRID}
  {$DEFINE EXPRESSDBTREEVIEW}
  {$DEFINE EXPRESSORGCHART}
  {$DEFINE EXPRESSFLOWCHART}
  {$DEFINE EXPRESSMAPCONTROL}
  {$DEFINE EXPRESSGRID}
  {$DEFINE EXPRESSSCHEDULER}
  {$DEFINE EXPRESSRICHEDITCONTROL}
  {$DEFINE EXPRESSGAUGECONTROL}
  {$DEFINE EXPRESSPDFVIEWER}
  {$DEFINE EXPRESSEMF}
{$IFEND}
{End Of Platform Defines}
