<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]-(4*K1*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]])/3+(2*K1*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]])/3-(5*K1*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]])/3-(K1*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]])/3,TheoryName->"A23B1D3F3H4J1K1",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];