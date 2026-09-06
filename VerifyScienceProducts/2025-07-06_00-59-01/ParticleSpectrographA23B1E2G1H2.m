<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefConstantSymbol[K4,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(4\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]+K4*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]-K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]-6*K2*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]]-(9*K2*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/2+(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/2+(K4*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/2,TheoryName->"A23B1E2G1H2",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];