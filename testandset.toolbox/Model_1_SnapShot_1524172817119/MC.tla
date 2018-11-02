---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417280859574000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417280859575000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_152417280859576000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 02:50:08 IST 2018 by aman
