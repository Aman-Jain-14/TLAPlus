---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417282706077000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417282706078000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_152417282706079000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 02:50:27 IST 2018 by aman
