<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K3,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(3\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]-2*K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]-K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]-(K3*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/2,TheoryName->"A23B2D3F1H1J1K1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];