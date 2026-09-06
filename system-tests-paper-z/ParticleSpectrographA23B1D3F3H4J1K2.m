<<xAct`PSALTer`;
DefConstantSymbol[K1,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(1\)]\)"];
DefConstantSymbol[K2,PrintAs->"\!\(\*SubscriptBox[\(\[ScriptCapitalK]\)\(\*OverscriptBox[\(\[Kappa]\),\((4)\)]\),\(2\)]\)"];
DefField[A23Field[-a,-b,-c],Antisymmetric[{-b,-c}],PrintAs->"\[ScriptCapitalK]",PrintSourceAs->"\[ScriptCapitalJ]"];
ParticleSpectrum[K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]-(K1*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]])/7-(9*K1*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]])/7-(9*K1*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]])/7+(6*K1*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]])/7,TheoryName->"A23B1D3F3H4J1K2",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
Quit[];