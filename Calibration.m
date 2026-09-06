(*===============*)
(*  Calibration  *)
(*===============*)

$ThisDirectory=If[NotebookDirectory[]==$Failed,Directory[],NotebookDirectory[],NotebookDirectory[]];
(*SetOptions[$FrontEndSession, PrintingStyleEnvironment -> "Working"];*)

<<xAct`xPlain`;
$Listings=True;

Title@"Calibration";

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

DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefConstantSymbol[K4,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(4\)]\)"];
DefConstantSymbol[K6,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(6\)]\)"];
DefConstantSymbol[K7,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(7\)]\)"];
DefConstantSymbol[K9,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(9\)]\)"];
DefConstantSymbol[K15,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(15\)]\)"];
DefConstantSymbol[K16,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(16\)]\)"];
DefConstantSymbol[M1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalM]\)\(\*OverscriptBox[\(\[Kappa]\),\((2)\)]\),\(1\)]\)"];
DefConstantSymbol[M2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalM]\)\(\*OverscriptBox[\(\[Kappa]\),\((2)\)]\),\(2\)]\)"];
DefConstantSymbol[M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalM]\)\(\*OverscriptBox[\(\[Kappa]\),\((2)\)]\),\(3\)]\)"];

DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];

ParticleSpectrum[M1*A23Field[-a,-b,-c]*A23Field[b,a,c],TheoryName->"CalibrationABCBAC",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];

ParticleSpectrum[M1*A23Field[-a,-b,-c]*A23Field[a,b,c]+M2*A23Field[a,b,c]*A23Field[-b,-a,-c]+M3*A23Field[a,-a,b]*A23Field[c,-b,-c]+K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]+K4*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]+K6*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]+K7*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]]+K9*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]]+K15*CD[-d][A23Field[-a,-b,-c]]*CD[d][A23Field[a,b,c]]+K16*CD[-d][A23Field[-b,-a,-c]]*CD[d][A23Field[a,b,c]],TheoryName->"CalibrationA23",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];

Supercomment@"This is the end of the calibration.";

Quit[];
