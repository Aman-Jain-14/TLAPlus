---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417320197780000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417320197781000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_152417320197782000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 02:56:41 IST 2018 by aman
