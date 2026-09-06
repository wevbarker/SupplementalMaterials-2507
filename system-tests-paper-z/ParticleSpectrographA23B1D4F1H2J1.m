<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]-(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]])/2+(5*K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]])/4+(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/4,TheoryName->"A23B1D4F1H2J1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];