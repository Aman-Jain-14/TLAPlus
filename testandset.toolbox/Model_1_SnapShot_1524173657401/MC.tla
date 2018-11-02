---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417365334587000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417365334588000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 03:04:13 IST 2018 by aman
