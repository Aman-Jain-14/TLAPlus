---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_15245054185216000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_15245054185217000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_15245054185218000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Mon Apr 23 23:13:38 IST 2018 by aman
