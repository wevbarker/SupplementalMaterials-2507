$ThisDirectory=If[NotebookDirectory[]==$Failed,Directory[],NotebookDirectory[],NotebookDirectory[]];
(*SetOptions[$FrontEndSession, PrintingStyleEnvironment -> "Working"];*)

<<xAct`xPlain`;
$Listings=True;

Code[<<xAct`PSALTer`;,LineLabel->"LoadPSALTer"];

Comment@"We want to test the various symmetries.";

(*DefField[Phi[-m],PrintAs->"\[Phi]",PrintSourceAs->"J"];
DefField[B[-m,-n],Antisymmetric[{-m,-n}],PrintAs->"\[ScriptCapitalB]",PrintSourceAs->"J"];
DefField[Cf[-m,-n],Symmetric[{-m,-n}],PrintAs->"\[ScriptCapitalC]",PrintSourceAs->"J"];
DefField[Cfgz[-m,-n,-g],Antisymmetric[{-m,-g}],PrintAs->"\[ScriptCapitalC]",PrintSourceAs->"J"];*)
DefField[Cfg[-m,-n,-g],Symmetric[{-m,-g}],PrintAs->"\[ScriptCapitalC]",PrintSourceAs->"J"];

Quit[];

DefTensor[B[-m,-n,-c],M4,Antisymmetric[{-m,-n,-c}],PrintAs->"\[Phi]"];

GetRelevantSlots[InputExpr_]:=Module[{Expr=InputExpr},
	Expr//=SymmetryOf;
	Expr//=List@@#&;
	Expr//=Last;
	Expr//=List@@#&;
	Expr//=(#/.GenSet->Zero)&;
	Expr//=DeleteCases[#,0]&;
	Expr//=First;
Expr];

PermuteAtSlots[InputList_,SlotsList_]:=Module[
	{sub,perms},
	sub=InputList[[SlotsList]];
	perms=Permutations[sub];
	Map[ReplacePart[InputList,Thread[SlotsList->#]]&,perms]
];

EnumerateSymmetriesOf[InputExpr_]:=Module[
	{Expr=InputExpr,PermutedExpr,CanonicalExpr},
	Expr//=List@@#&;
	Expr=Expr~PermuteAtSlots~(GetRelevantSlots@InputExpr);
	PermutedExpr=((Head@InputExpr)@@#)&/@Expr;
	CanonicalExpr=(ScreenDollarIndices@ToCanonical@#)&/@PermutedExpr;
	Expr={PermutedExpr,CanonicalExpr};
	Expr//=Transpose;
	Expr//=DeleteDuplicates;
	IsSame[InputLst_]:=Module[{Expr=InputLst,LeftHandSide,RightHandSide},
		LeftHandSide=Expr//First;	
		RightHandSide=Expr//Last;
		Return[LeftHandSide===RightHandSide];
	];
	Expr//=DeleteCases[#,_?IsSame]&;
	Expr//=(((#1==#2)&)@@#)&/@#&;
Expr];

Expr=B[-m,-n,-f];
Expr//=EnumerateSymmetriesOf;
Expr//DisplayExpression;

Quit[];

Get@FileNameJoin@{$ThisDirectory,"ParticleSpectroscopy","SpecialFunctions.m"};

Unprotect[$ProcessorCount];
(*$ProcessorCount=8;*)
Protect[$ProcessorCount];

Comment@"Some secret settings that are not documented.";
Code[
	xAct`PSALTer`Private`$DiagnosticMode=False;
	xAct`PSALTer`Private`$Disabled=True;
	xAct`PSALTer`Private`$SystemTesting=True;
	xAct`PSALTer`Private`$RecomputeEdges=True;
	xAct`PSALTer`Private`$RecomputeTable=True;
];

Get@FileNameJoin@{$ThisDirectory,"ParticleSpectroscopy","FieldKinematics.m"};

Supercomment@"Note that whilst \"DefField\" appears in the code block above, the fact that we are running with $Disabled=True means that this function is not actually doing anything. This saves a load of time when re-running this particular script, but it does mean that pretty formatting for the source components is not available. Therefore, we'll have to make our own replacement source components with good formatting below.";

(*
ParticleSpectrum[M2*A23Field[a,-a,b]*A23Field[c,-b,-c]+K1*CD[-b][A23Field[d,-c,-d]]*CD[c][A23Field[a,-a,b]],TheoryName->"CMExample",Method->"Hard",ShowPropagator->True,AspectRatio->Portrait,MaxLaurentDepth->1];
*)

Comment@"Now we try to load the binary file. This is done with the \"Get\" command.";
Code[
	Get@"ParticleSpectrographA23B1D4F1H2J2.mx";
];




Comment@"First we check the matrices to see that we grabbed the right model.";
Code[
	Expr=A23B1D4F1H2J2;
	Expr=Expr@WaveOperator;
	Expr//DisplayExpression;
];

Comment@"Now we focus on the source constraints. How many source components are referred to in these equations?";
Code[
	Expr=A23B1D4F1H2J2;
	SourceConstraints=Expr@ComponentSourceConstraints;
	ComponentBasis=Cases[SourceConstraints,_xAct`PSALTer`A23Field`SourceRank3Antisymmetric,Infinity];
	ComponentBasis//=DeleteDuplicates;
	ComponentBasis//Length//DisplayExpression;
];

Comment@"Can we get better variables that don't require us to wait for \"DefField\"?";
Code[
	SimpleVars=DefNiceConstantSymbol["\[ScriptCapitalJ]",SomeIndex]~Table~{SomeIndex,Length@ComponentBasis};
	ConjSimpleVars=DefNiceConstantSymbol["\[ScriptCapitalJ]\[Dagger]",SomeIndex]~Table~{SomeIndex,Length@ComponentBasis};
	ToSimpleVars=Rule~MapThread~{ComponentBasis,SimpleVars};
	ToSimpleVars//=(#~Join~(Rule~MapThread~{(ComponentBasis/.{xAct`PSALTer`A23Field`SourceRank3Antisymmetric->Symbol["xAct`PSALTer`A23Field`SourceRank3Antisymmetric"<>"\[Dagger]"]}),ConjSimpleVars}))&;
	SimpleVars//DisplayExpression;
	TakeConjugate=Rule~MapThread~{SimpleVars,ConjSimpleVars};
	SourceConstraints//=(#/.ToSimpleVars)&;
];

Comment@"Can we see how many source constraints we really have?";
Code[
	SourceSolutions=SourceConstraints~Solve~SimpleVars;
	SourceSolutions//=First;
	SourceSolutions//Length//DisplayExpression;
	SourceSolutions//DisplayExpression;
];

Comment@"Time to move on to the saturated propagator.";
Code[
	Expr=A23B1D4F1H2J2;
	SaturatedPropagator=Expr@ComponentSaturatedPropagator;
	SaturatedPropagator//=(#/.ToSimpleVars)&;
	SaturatedPropagator//=Total;
	SaturatedPropagator//=Expand;
	SaturatedPropagator//DisplayExpression;
];

Comment@"Now we want to make a function that extracts the pole structure from the saturated propagator for a given choice of source constraint solution.";
Code[
	ExtractPoleStructure[SourceSolution_]:=Module[
		{FullSourceSolution=SourceSolution,Propagator=SaturatedPropagator},

		FullSourceSolution//=(#~Join~(#/.TakeConjugate))&;
		Propagator//=(#/.FullSourceSolution)&;
		Propagator//=(#/.{Mo->Sqrt[En^2-qq]})&;
		Propagator//=(#~Series~{qq,0,-1})&;
		Propagator//=FullSimplify[#,Assumptions->{En>0,qq>=0}]&;
		Propagator//DisplayExpression;
	];
];

(*Comment@"Test it.";
Code[
	ExtractPoleStructure[SourceSolutions];
];*)

Comment@"Systematic approach.";

SourceConstraints//=DeleteDuplicates;

IsPivotRow[InputRow_]:=Evaluate[Total[InputRow]==1];
ReapLocalPool[InputEquations_List,InputVariables_List]:=Module[
	{n,InitialBasis,BasisQueue,BasisSeen,BasisReap,CurrentBasis,
	CurrentFreeVars,CurrentSolution,BasicVar,FreeVar,NewBasis,SortedNewBasis},

	(*n=Length[InputEquations];*)

	Module[{mat,PivotColumns},
		{SystemConstants,
			MatrixRepresentation}=InputEquations~CoefficientArrays~InputVariables;
		PivotColumns=First/@Position[
			Transpose@RowReduce@Normal@MatrixRepresentation,
			_?IsPivotRow,1];
		InitialBasis=InputVariables[[PivotColumns]];
		InitialBasis//=Sort;
	];
	InitialBasis//DisplayExpression;
	BasisQueue={InitialBasis};
	BasisSeen={InitialBasis};
	BasisReap={InitialBasis};

	While[BasisQueue=!={},
		CurrentBasis=BasisQueue;
		CurrentBasis//=First;
		BasisQueue//=Rest;
		CurrentFreeVars=InputVariables~Complement~CurrentBasis;
		CurrentSolution=InputEquations~Solve~CurrentBasis;
		CurrentSolution//=First;
		Do[
			Do[
				If[Coefficient[BasicVar/.CurrentSolution,FreeVar]=!=0,
					NewBasis=Union[
						Complement[CurrentBasis,
							{BasicVar}],
						{FreeVar}];
					SortedNewBasis=NewBasis;
					SortedNewBasis//=Sort;
					If[!(BasisSeen~MemberQ~SortedNewBasis),
						SortedNewBasis//DisplayExpression;
						SortedNewBasis//TestPoleStructure;
						BasisSeen~AppendTo~SortedNewBasis;
						BasisQueue~AppendTo~SortedNewBasis;
						BasisReap~AppendTo~SortedNewBasis;];
				]
			,
				{FreeVar,CurrentFreeVars}
			]
		,
			{BasicVar,CurrentBasis}
		]
	];
	BasisReap//Return;
];

TestPoleStructure[ChoiceOfVars_]:=Module[
	{FullSourceSolution,Propagator=SaturatedPropagator},

	FullSourceSolution=SourceConstraints~Solve~ChoiceOfVars;
	FullSourceSolution//=First;
	FullSourceSolution//=(#~Join~(#/.TakeConjugate))&;
	Propagator//=(#/.FullSourceSolution)&;
	Propagator//=(#/.{Mo->Sqrt[En^2-qq]})&;
	Propagator//=(#~Series~{qq,0,-1})&;
	Propagator//=FullSimplify[#,Assumptions->{En>0,qq>=0}]&;
	Propagator//DisplayExpression;
];

ReapLocalPool[SourceConstraints,SimpleVars];

Quit[];
