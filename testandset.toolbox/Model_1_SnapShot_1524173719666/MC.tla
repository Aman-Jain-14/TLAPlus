---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417371763495000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417371763496000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_152417371763497000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 03:05:17 IST 2018 by aman
