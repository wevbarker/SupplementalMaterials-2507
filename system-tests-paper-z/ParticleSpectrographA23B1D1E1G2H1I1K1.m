<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]],TheoryName->"A23B1D1E1G2H1I1K1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];