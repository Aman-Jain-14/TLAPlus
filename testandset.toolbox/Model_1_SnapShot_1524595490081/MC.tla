---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_15245954803262000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_15245954803263000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
\* PROPERTY definition @modelCorrectnessProperties:0
prop_15245954803264000 ==
Termination
----
=============================================================================
\* Modification History
\* Created Wed Apr 25 00:14:40 IST 2018 by aman
