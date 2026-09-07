(*==========================*)
(*  DeconflictionRepair     *)
(*==========================*)

(*  Audit and repair of the deconfliction column of AllModels<Theory>.csv.

    Reads that CSV and nothing else: no PSALTer, no Lagrangians, no spectra,
    and it writes no files. Every conclusion is therefore downstream of the
    survey's own model discovery and definitions. It cannot detect a model the
    survey never found, and a wrong DEFINITION would be inherited silently.

    Companion to DeconflictionRepair.py in this directory, a deliberately
    independent implementation: that one parses with sympy and works in exact
    rationals, this one lets the Wolfram kernel parse its own syntax and uses
    MatrixRank. Agreement between them is the check that neither has a parsing
    or algebra bug of its own.

    The presentation reproduces the ORIGINAL pipeline's final steps rather than
    imposing a tidier style, so that rows the survey already got right come out
    byte-identical to the published table.                                    *)

$Theory="A23";
$ThisDirectory=If[NotebookDirectory[]==$Failed,Directory[],NotebookDirectory[],NotebookDirectory[]];

<<xAct`xPlain`;
$Listings=True;
$HistoryLength=0;

Title@"Deconfliction repair";

Comment@"Each row of the survey records a DEFINITION, a conjunction of linear
combinations of the couplings which must vanish to reach that model, and a
DECONFLICTION, the alternative ways of falling into a deeper model, any one of
which must be avoided if the model is to be the one under discussion.";

Comment@"The same audit applied to paper II. The fault diagnosed in paper I is a
property of the survey algorithm, not of either theory, so it is expected here
too -- and on a larger table, with more models below each row, it should be
worse. The questions are the same: what changes, and does the repair reproduce
the survey wherever the survey was right?";

Section@"Reading the survey output";

Code[
	CsvFile=FileNameJoin@{$ThisDirectory,"AllModels"<>$Theory<>".csv"};
	RawRows=Import[CsvFile,"CSV"];
	ModelNames=First/@RawRows;
	Definitions=Association@Table[First@Row->ToExpression@(Row[[2]]),{Row,RawRows}];
	RecordedDeconfliction=Association@Table[First@Row->ToExpression@(Row[[3]]),{Row,RawRows}];
	TheCouplings=Union@Flatten[Variables/@Values@Definitions];
	AsAlternativeList[Entry_]:=Function[Item,If[Head@Item===List,Item,{Item}]]/@Entry;
	Print["models: ",Length@ModelNames,"   couplings: ",TheCouplings];
	,LineLabel->"ImportCsv"];

Section@"Conditions as subspaces";

Comment@"A conjunction of vanishing linear forms is a linear subspace, so every
question below is a rank computation and no general solver is needed. An early
draft asked Reduce to decide implication pairwise across the table and
exhausted the machine's memory; MatrixRank does the same work in milliseconds.";

Code[
	ToMatrix[Forms_]:=Table[Coefficient[Form,#]&/@TheCouplings,{Form,Forms}];
	RankOf[Forms_]:=If[Forms==={},0,MatrixRank@ToMatrix@Forms];
	FormsOf[Condition_]:=Module[{Parts},
		If[Condition===True||Condition===False,Return@{}];
		Parts=If[Head@Condition===And,List@@Condition,{Condition}];
		(#[[1]]-#[[2]])&/@Parts];
	ImpliesQ[A_,B_]:=RankOf@Join[A,B]===RankOf@A;
	SameConditionQ[A_,B_]:=ImpliesQ[A,B]&&ImpliesQ[B,A];
	,LineLabel->"SubspaceTools"];

Section@"The deeper models";

Comment@"The survey keys models by the NUMBER of defining equations and, for a
given model, considers every model defined by more equations. That relation is
reproduced here. Model NAMES are not consulted: the bifurcation trees are only
a device for discovering the models, a model reached by two trees is filed
under one of them arbitrarily, and by this stage the trees carry no meaning.
The structure is a DAG, and most models lie below several others at once.";

Code[
	EquationCount[Model_]:=Length@Definitions@Model;
	DeeperModels[Model_]:=Select[ModelNames,EquationCount@#>EquationCount@Model&];
	,LineLabel->"DeeperModels"];

Section@"The conditions carrying a model into a deeper one";

Comment@"A deeper model D is reachable from P only if P's conditions already
hold on D. Where they do, the extra conditions follow by solving P and
substituting into D, then reducing. This mirrors the original exactly, and it
is not where the fault lay.";

Code[
	ExtraConditions[Parent_,Deeper_]:=Module[{P,D,Solution},
		P=Definitions@Parent; D=Definitions@Deeper;
		If[!ImpliesQ[D,P],Return@$Failed];
		If[SameConditionQ[D,P],Return@$Failed];
		Solution=Quiet@Solve[(#==0)&/@P];
		If[Solution==={},Return@$Failed];
		Quiet@Reduce[(And@@((#==0)&/@D))/.First@Solution,TheCouplings]];
	,LineLabel->"ExtraConditions"];

Section@"The repair";

Comment@"Because ALL deeper models are considered, a grandchild's conditions
may be strictly stronger than a child's and must be discarded so that only the
first branching survives. The original discarded a condition when substituting
its own solution made MORE THAN ONE member of the list true. That count
includes the condition itself, so the test means 'delete X if X implies at
least one other'. For strict implication that is right. But when two conditions
are EQUIVALENT -- the same first branching arriving from two different
descendants, which is the normal case -- each implies the other, and because
DeleteCases evaluates the predicate against the original list, both are deleted
in the same pass. Nothing survives to break the tie and the column collapses.";

Comment@"The repair keeps a condition unless some DIFFERENT condition is
strictly weaker, and merges equivalents rather than letting them cancel. Every
comparison is made modulo the parent's own conditions, since two extras can
look incomparable while the spaces they generate on top of the parent are
nested.";

Code[
	PruneConditions[Parent_,Conditions_]:=Module[{Kept,ImpliesModP,SameModP},
		ImpliesModP[A_,B_]:=RankOf@Join[Definitions@Parent,FormsOf@A,FormsOf@B]===
			RankOf@Join[Definitions@Parent,FormsOf@A];
		SameModP[A_,B_]:=ImpliesModP[A,B]&&ImpliesModP[B,A];
		Kept=DeleteCases[Conditions,True|False];
		Kept=Select[Kept,Function[This,
			!AnyTrue[DeleteCases[Kept,This],
				ImpliesModP[This,#]&&!ImpliesModP[#,This]&]]];
		Kept=DeleteDuplicates[Kept,SameModP];
	Kept];
	RepairedConditions[Model_]:=PruneConditions[Model,
		DeleteCases[ExtraConditions[Model,#]&/@DeeperModels@Model,$Failed]];
	,LineLabel->"PruneRule"];

Section@"Presentation, as the original does it";

Comment@"The original keeps its conditions as a LIST and never assembles a
disjunction, so FullSimplify acts elementwise and cannot factorise a common
conjunct across alternatives. Its final three steps are reproduced verbatim:
FullSimplify, then And -> List, then lhs==rhs -> Expand[lhs-rhs]. The '=0' is
never stored; UpdateScienceProducts.py appends it. No rescaling to integer
coefficients and no sign convention are imposed: the aim is continuity with the
published table, not a tidier style.";

Code[
	ToSurveyForm[Conditions_]:=Module[{Result},
		Result=Quiet@FullSimplify@Conditions;
		Result=Result/.And->List;
		Result=Result/.{lhs_==rhs_:>Expand[lhs-rhs]};
		Result=Function[Item,If[Head@Item===List,Item,{Item}]]/@Result;
		Result=DeleteCases[Result,{}|{True}];
	Result];
	SurveyFormOf[Model_]:=ToSurveyForm@RepairedConditions@Model;
	,LineLabel->"SurveyForm"];

Section@"How two answers are compared";

Comment@"Two decompositions can denote the SAME conditions while carving them
into different alternatives. Which model a given alternative guards against is
not recorded in the table and is not needed by the reader, so the test of
correctness is equality of the UNION: each alternative of one must lie inside
some alternative of the other, and vice versa. Over an infinite field a
subspace contained in a finite union of subspaces lies wholly inside one of
them, so this is exact. An alternative-by-alternative match is the WRONG test
and reports spurious failures.";

Code[
	SubspaceOf[A_,B_]:=RankOf@Join[A,B]===RankOf@A;
	SameUnionQ[As_,Bs_]:=
		AllTrue[As,Function[Aa,AnyTrue[Bs,SubspaceOf[Aa,#]&]]]&&
		AllTrue[Bs,Function[Bb,AnyTrue[As,SubspaceOf[Bb,#]&]]];
	SelfTestA=AllTrue[ModelNames,Function[M,SameUnionQ[
			AsAlternativeList@RecordedDeconfliction@M,
			AsAlternativeList@RecordedDeconfliction@M]]];
	Print["self-test A (must be True)   recorded vs itself, every row: ",SelfTestA];
	SelfTestB=SameUnionQ[AsAlternativeList@RecordedDeconfliction@First@ModelNames,
			AsAlternativeList@RecordedDeconfliction@Last@ModelNames]];
	SelfTestC=SameUnionQ[{{K3},{18*K1+K3}},{{2*(18*K1+K3)},{-5*K3}}];
	Print["self-test B (must be False)  two genuinely different rows:  ",SelfTestB];
	Print["self-test C (must be True)   same set, rescaled, reordered: ",SelfTestC];
	,LineLabel->"ComparisonTests"];

Section@"Does the repair reproduce the survey where the survey was right?";

Code[
	CompleteRows=Select[ModelNames,Function[M,
		Module[{Kids,Alts},
			Kids=Select[ModelNames,#=!=M&&ImpliesQ[Definitions@#,Definitions@M]&&
				RankOf@Definitions@#>RankOf@Definitions@M&];
			Alts=AsAlternativeList@RecordedDeconfliction@M;
			Kids=!={}&&AllTrue[Kids,Function[K,
				AnyTrue[Alts,RankOf@Join[Definitions@K,#]===RankOf@Definitions@K&]]]]]];
	Print["rows the survey got right: ",Length@CompleteRows];
	SameContent=Select[CompleteRows,Function[M,
		SameUnionQ[SurveyFormOf@M,AsAlternativeList@RecordedDeconfliction@M]]];
	Print["  same CONTENT as recorded  : ",Length@SameContent," of ",Length@CompleteRows];
	Identical=Select[CompleteRows,Function[M,
		Sort[Sort/@SurveyFormOf@M]===Sort[Sort/@AsAlternativeList@RecordedDeconfliction@M]]];
	Print["  BYTE-IDENTICAL to recorded: ",Length@Identical," of ",Length@CompleteRows];
	Print["  content differs in        : ",Complement[CompleteRows,SameContent]];
	Print["  only the text differs in  : ",Complement[SameContent,Identical]];
	Do[Print["    ",M,"  recorded = ",InputForm@AsAlternativeList@RecordedDeconfliction@M,
		"  emulated = ",InputForm@SurveyFormOf@M],
		{M,Take[Complement[SameContent,Identical],UpTo@4]}];
	,LineLabel->"EmulationCheck"];

Section@"Rows recording nothing at all";

Comment@"The clearest symptom of the collapse is a row whose deconfliction is
empty although models lie below it. Such a row does not merely omit a warning:
it asserts that the theory cannot degenerate into anything more symmetric.";

Code[
	BlankRows=Select[ModelNames,Function[M,
		RecordedDeconfliction@M==={}&&
		AnyTrue[ModelNames,#=!=M&&ImpliesQ[Definitions@#,Definitions@M]&&
			RankOf@Definitions@#>RankOf@Definitions@M&]]];
	Print["rows recording NOTHING while models lie below: ",Length@BlankRows];
	Print["  ",BlankRows];
	,LineLabel->"BlankRows"];

Section@"Everything the repair changes";

Code[
	Changed={};
	Do[Module[{Repaired,Recorded},
		Repaired=SurveyFormOf@Model;
		Recorded=AsAlternativeList@RecordedDeconfliction@Model;
		If[!SameUnionQ[Repaired,Recorded],AppendTo[Changed,Model]];
		],{Model,ModelNames}];
	Glyph[U_]:=Which[
		StringContainsQ[ToString@U,">"]||StringContainsQ[ToString@U,"<"],"Consistent",
		StringContainsQ[ToString@U,"Demonstrably"],"Inconsistent",
		StringContainsQ[ToString@U,"True"],"Empty",True,"More"];
	Unitarity=Association@Table[First@Row->Row[[4]],{Row,RawRows}];
	Print["MODELS CHANGED (",Length@Changed," of ",Length@ModelNames,")"];
	Print["  by unitarity glyph: ",InputForm@Tally[Glyph@Unitarity@#&/@Changed]];
	Print["  the unitary ones  : ",Select[Changed,Glyph@Unitarity@#==="Consistent"&]];
	Do[Print["   ",M,"  recorded = ",InputForm@AsAlternativeList@RecordedDeconfliction@M,
		"  repaired = ",InputForm@SurveyFormOf@M],
		{M,Select[Changed,Glyph@Unitarity@#==="Consistent"&]}];
	,LineLabel->"Regression"];

Section@"Writing the repaired table";

Comment@"The corrected deconfliction is written back to the CSV, NOT to the
manuscript TeX. That preserves the one-way flow survey -> CSV ->
UpdateScienceProducts.py -> .tex: the repaired output is already in the shape
the CSV uses, so the existing generator needs no change. It also removes a
standing hazard, since corrections that live only in the generated .tex are
destroyed by any regeneration.";

Comment@"Only the deconfliction field is touched, and only on rows where an
omission was actually found. Definitions and unitarity are copied through
untouched, and rows the survey got right keep their recorded text verbatim, so
the diff is confined to the rows that were wrong. Writing happens only when the
environment variable DECONFLICT_WRITE is set to 1, and only if the self-tests
above passed.";

Code[
	$WriteCsv=Environment["DECONFLICT_WRITE"]==="1";
	SelfTestsPassed=SelfTestA&&(!SelfTestB)&&SelfTestC;
	If[$WriteCsv&&!SelfTestsPassed,
		Print["REFUSING TO WRITE: self-tests did not pass."];
		$WriteCsv=False];
	If[$WriteCsv,
		NewRows=Table[
			Module[{Name,Deconfliction},
				Name=First@Row;
				Deconfliction=If[MemberQ[Changed,Name],
					SurveyFormOf@Name,
					RecordedDeconfliction@Name];
				(* an alternative holding one condition is stored bare, as
				   And -> List leaves a lone equation scalar *)
				Deconfliction=Function[Alt,
					If[Head@Alt===List&&Length@Alt===1,First@Alt,Alt]]/@Deconfliction;
				(* Row[[2]] and Row[[4]] are already the raw strings Import
				   returned; passing them through ToString would quote them a
				   second time. Only the deconfliction is regenerated. *)
				{Name,Row[[2]],ToString[Deconfliction,InputForm],Row[[4]]}],
			{Row,RawRows}];
		Export[CsvFile,NewRows];
		Print["WROTE ",CsvFile];
		Print["  rows rewritten: ",Length@Changed," of ",Length@ModelNames];
		Reread=Import[CsvFile,"CSV"];
		DefsOk=(#[[2]]&/@Reread)===(#[[2]]&/@RawRows);
		UniOk=(#[[4]]&/@Reread)===(#[[4]]&/@RawRows);
		NamesOk=(First/@Reread)===ModelNames;
		Print["  re-read: ",Length@Reread," rows; names ",NamesOk,
			", definitions ",DefsOk,", unitarity ",UniOk];
		If[!(DefsOk&&UniOk&&NamesOk),
			Print["*** WRITE CORRUPTED COLUMNS THAT SHOULD NOT HAVE CHANGED ***"];
			Print["*** revert with: git checkout -- ",CsvFile," ***"]];
		Print["  unchanged rows still byte-identical: ",
			AllTrue[Complement[ModelNames,Changed],Function[M,
				(SelectFirst[Reread,First@#===M&])[[3]]===
				(SelectFirst[RawRows,First@#===M&])[[3]]]]];
		,
		Print["Not writing (set DECONFLICT_WRITE=1 to rewrite the CSV in place)."];
		Print["  rows that WOULD be rewritten: ",Length@Changed];
	];
	,LineLabel->"WriteCsv"];

Quit[];
