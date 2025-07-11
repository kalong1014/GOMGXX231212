Asphyre Sphinx Framework v3.0.4, dated 14-Sep-2012

---------------------------------------------------------------
This release provides unified support of DirectX 7, DirectX 9,
DirectX 10, DirectX 11, OpenGL 2.1 and OpenGL 1.4 (in legacy
mode).

DirectX 9 implementation uses either Direct3D 9 Ex on Windows
Vista and later, or Direct3D 9 on Windows XP and earlier,
switching automatically.

DirectX 10 implementation uses either Direct3D 10.1, when such
support is available (including Windows WARP software device),
or Direct3D 10.0 on unpatched Windows Vista, switching between
the two automatically.

DirectX 11 implementation uses fallback mechanism to earlier
feature levels, so it should work on hardware that is capable
of Direct3D 9 and later.

OpenGL implementation uses programmable pipeline by default
and uses OpenGL 2.1 features.

This version supports Embarcadero Delphi and FPC/Lazarus. The
limitations for different versions and platforms are the
following:

1) From Delphi 2006 to Delphi XE: No 64-bit platform support
   because their compiler is 32-bit only.

2) FireMonkey v2 in Delphi XE 3 is fully supported on Windows
   and Mac OS X platforms. Delphi XE 2's FireMonkey v1 is not
   supported however. If you need to use Delphi XE 2 with
   FireMonkey v1 and/or iOS platform, you can use earlier 
   version of Asphyre Sphinx 2.x.

3) FreePascal/Lazarus:

    I) Linux and Mac OS: Asphyre tools have not been
       ported to these platforms yet. Please be patient.
       Meanwhile, you can use Wine on Linux and Fusion
       or Parallels on Mac OS to run Asphyre tools.

    II) Mac OS: Only 32-bit platform is supported, which is
        the limitation of compiler and LCL. In addition,
        it is also limited due to usage of Carbon API.

    III) Windows: DirectX 10 does not work due to problems
         in DirectX 10 headers. These headers were made for
         earlier version of FreePascal, but no longer work
         in latest versions. Instead, it is recommended to
         use DirectX 11 provider for FPC/Lazarus.

Installation in Delphi involves adding Asphyre source folder
along with each one of its subfolders in Delphi's library
path. In latest Delphi versions you can locate library
path at the following location:
"Tools – Options – Environment Options – Delphi Options –
Library Path". That is, the line should look like this:
 $(BDS)\lib;$(BDS)\Imports;$(BDS)\Lib\Indy10;c:\Asphyre\Source

In order to use Asphyre documentation, locate "Help" folder and
in this folder find and open "index.html". Alternatively, you
can create a shortcut to this file on your desktop.

In this release, Asphyre tools are divided in two categories:
32-bit and 64-bit versions. You can find them in their
respective sub-folders inside "Tool" folder.

Possible global conditional defines:
 * LegacyGL
     Use legacy OpenGL 1.4 renderers.

 * Vec2ToPxImplicit
     Allow implicit conversion from TPoint2 to TPoint2px,
     which will disable Vec2ToPx function and do the 
     conversion automatically. Since this encourges ambiguous
     behavior, it is not recommended to use this option other
     than to allow compatibility with earlier Asphyre releases.

Remember that Asphyre Sphinx framework is still under
development so keep checking our website at
http://www.afterwarp.net for updates and other important
information.

Also, you can discuss the development of Asphyre Framework on
our forums at:
 http://www.afterwarp.net/forum

Remember that this library and its source code are protected
by Mozilla Public License 1.1. You must agree to use this
package under the terms of Mozilla Public License 1.1 or
permamently remove the package from your hard drive.

---------------------------------------------------------------
Asphyre is copyright (c) 2000 - 2012  Yuriy Kotsarenko

Some of the included artwork was made by Humberto Andrade
and is copyright protected. Any distribution of this artwork
is strictly prohibited.

If you have any inquries, send e-mail to: ykot@inbox.com