{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit KControlsLaz;

{$warn 5023 off : no warning about unused units}
interface

uses
  kgraphics, kcontrols, kdialogs, keditcommon, kgrids, khexeditor, kicon, 
  kprintpreview, kprintsetup, kwidewinprocs, kcontrolsdesign, kdbgrids, 
  kedits, kmessagebox, klog, kprogress, klabels, kmemo, kbuttons, 
  kmemodlghyperlink, kmemodlgparastyle, kmemodlgtextstyle, kmemofrm, kmemortf, 
  kpagecontrol, kmemodlgcontainer, kmemodlgimage, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('kcontrolsdesign', @kcontrolsdesign.Register);
end;

initialization
  RegisterPackage('KControlsLaz', @Register);
end.
