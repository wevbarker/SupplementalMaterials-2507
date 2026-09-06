<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefConstantSymbol[M3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalM]\)\(\*OverscriptBox[\(\[Kappa]\),\((2)\)]\),\(3\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[M3*A23Field[a,-a,b]*A23Field[c,-b,-c]+K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]-(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]])/2+(5*K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]])/4+(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/4,TheoryName->"A23B1D4F1H2",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];