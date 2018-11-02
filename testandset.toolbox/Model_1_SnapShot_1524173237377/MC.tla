---- MODULE MC ----
EXTENDS testandset, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152417323184885000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152417323184886000 ==
(\A i,j \in ProcSet : (i # j) => ~ (pc[i] = "criticalSection" /\ pc[j] = "criticalSection"))
----
=============================================================================
\* Modification History
\* Created Fri Apr 20 02:57:11 IST 2018 by aman
