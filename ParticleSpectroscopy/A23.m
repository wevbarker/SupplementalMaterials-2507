(*=======*)
(*  A23  *)
(*=======*)

Comment@"Here is the most general Lagrangian for the pair-antisymmetric field.";
LagrangianDensity=M1*A23Field[-a,-b,-c]*A23Field[a,b,c]+M2*A23Field[a,b,c]*A23Field[-b,-a,-c]+M3*A23Field[a,-a,b]*A23Field[c,-b,-c]+K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]]+K2*CD[-c][A23Field[d,-b,-d]]*CD[c][A23Field[a,-a,b]]+K3*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-a,-c,d]]+K4*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[-b,-c,d]]+K6*CD[-b][A23Field[a,b,c]]*CD[-d][A23Field[-c,-a,d]]+K7*CD[c][A23Field[a,-a,b]]*CD[-d][A23Field[-c,-b,d]]+K9*CD[-a][A23Field[a,b,c]]*CD[-d][A23Field[d,-b,-c]]+K15*CD[-d][A23Field[-a,-b,-c]]*CD[d][A23Field[a,b,c]]+K16*CD[-d][A23Field[-b,-a,-c]]*CD[d][A23Field[a,b,c]];
DisplayExpression[LagrangianDensity,EqnLabel->"A23RootTheory"];

Comment@{"Now we take",Cref@"A23RootTheory"," and we perform the survey:"};
Code[LagrangianDensity,
	MakeSurvey[LagrangianDensity, 
		TheoryName->"A23",
		ImageSize->1000,
		VertexSize->0.9,
		Magnification->1.6
	];
];

Quit[];
