<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefConstantSymbol[K15,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(15\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[2*K15*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]-4*K15*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]-2*K15*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]-K15*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]]+K15*CD[-d][A23Field[-a,-b,-c]]*CD[d][A23Field[a,b,c]]-2*K15*CD[-d][A23Field[-b,-a,-c]]*CD[d][A23Field[a,b,c]],TheoryName->"A23B2C1E2G2H1I1K2",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];