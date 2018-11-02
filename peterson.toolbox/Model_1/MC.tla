---- MODULE MC ----
EXTENDS peterson, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_152459768548516000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_152459768548517000 ==
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"cas1"})
\/
(pc[1] \in {"ncs10","ncs11","check1"} /\ pc[0] \in {"cas0"})
\/
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"ncs10","ncs11","check1"})
----
=============================================================================
\* Modification History
\* Created Wed Apr 25 00:51:25 IST 2018 by aman
