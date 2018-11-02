---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417369091392000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417369091393000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_152417369091394000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 03:04:50 IST 2018 by aman
