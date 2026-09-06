$ThisDirectory=If[NotebookDirectory[]==$Failed,Directory[],NotebookDirectory[],NotebookDirectory[]];

<<xAct`xPlain`;
$Listings=True;

Title@"Avdeev Chizov";

Code[<<xAct`PSALTer`;,LineLabel->"LoadPSALTer"];

DefField[TField[-a,-b],Antisymmetric[{-a,-b}],
	PrintAs->"\[ScriptCapitalT]",PrintSourceAs->"\[Sigma]"];
DefConstantSymbol[AlphaCoupling,PrintAs->"\[Alpha]"];
DefConstantSymbol[BetaCoupling,PrintAs->"\[Beta]"];
lag=AlphaCoupling*(CD[r]@TField[m,n]*CD[-r]@TField[-m,-n]-4*CD[-r]@TField[r,n]*CD[-s]@TField[s,-n]);
ParticleSpectrum[lag,TheoryName->"AvdeevChizov",
	MaxLaurentDepth->3,Method->"Hard"];
