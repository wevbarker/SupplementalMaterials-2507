(*========================*)
(*  ParticleSpectroscopy  *)
(*========================*)

$ThisDirectory=If[NotebookDirectory[]==$Failed,Directory[],NotebookDirectory[],NotebookDirectory[]];
(*SetOptions[$FrontEndSession, PrintingStyleEnvironment -> "Working"];*)

<<xAct`xPlain`;
$Listings=True;

Title@"Particle spectroscopy";

Code[<<xAct`PSALTer`;,LineLabel->"LoadPSALTer"];

Get@FileNameJoin@{$ThisDirectory,"ParticleSpectroscopy","SpecialFunctions.m"};

Unprotect[$ProcessorCount];
(*$ProcessorCount=8;*)
Protect[$ProcessorCount];

xAct`PSALTer`Private`$DiagnosticMode=False;
xAct`PSALTer`Private`$Disabled=False;
xAct`PSALTer`Private`$SystemTesting=True;
xAct`PSALTer`Private`$RecomputeEdges=True;
xAct`PSALTer`Private`$RecomputeTable=True;

Get@FileNameJoin@{$ThisDirectory,"ParticleSpectroscopy","FieldKinematics.m"};
(*Get@FileNameJoin@{$ThisDirectory,"ParticleSpectroscopy","A23.m"};*)

Supercomment@"This is the end of the supplemental materials.";

Quit[];
