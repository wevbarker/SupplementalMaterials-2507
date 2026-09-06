(*====================*)
(*  SpecialFunctions  *)
(*====================*)

DisplayRule~SetAttributes~HoldAll;
DisplayRule[InputExpr_,InputRule_]:=Module[{Expr=Evaluate@InputExpr,EqnLabelValue=ToString@Defer@InputRule},
	EqnLabelValue//=StringDelete[#,"Defer["]&;
	EqnLabelValue//=StringDelete[#,"]"]&;
	Expr=Expr/.Evaluate@InputRule;
	Expr//=ToCanonical;
	Expr//=ContractMetric;
	Expr//=ScreenDollarIndices;
	Expr//=CollectTensors;
	Expr//=ScreenDollarIndices;
	DisplayExpression[(InputExpr->Expr),EqnLabel->EqnLabelValue];
Expr];
