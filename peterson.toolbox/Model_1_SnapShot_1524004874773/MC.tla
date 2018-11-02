---- MODULE MC ----
EXTENDS peterson, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_15240048713734000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_15240048713735000 ==
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"cas0"})
\/
(pc[1] \in {"ncs10","ncs11","check1"} /\ pc[0] \in {"cas1"})
\/
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"ncs10","ncs11","check1"})
----
=============================================================================
\* Modification History
\* Created Wed Apr 18 04:11:11 IST 2018 by aman
