<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+9*K2*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]+9*K2*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]-6*K2*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]],TheoryName->"A23B1D4G2I1J2",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];