<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefConstantSymbol[K7,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(7\)]\)"];
DefConstantSymbol[K15,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(15\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]-K1*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]+6*K15*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]-2*K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]+3*K15*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]-K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]+K7*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]]-(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/2+K15*CD[-d][A23Field[-a,-b,-c]]*CD[d][A23Field[a,b,c]]+K15*CD[-d][A23Field[-b,-a,-c]]*CD[d][A23Field[a,b,c]],TheoryName->"A23B3D2F2H1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];