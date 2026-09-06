<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefConstantSymbol[M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalM]\)\(\*OverscriptBox[\(\[Kappa]\),\((2)\)]\),\(3\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[M3*A23Field[a,-a,b]*A23Field[c,-b,-c]+K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]],TheoryName->"A23B1D1E1G2H1I1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];