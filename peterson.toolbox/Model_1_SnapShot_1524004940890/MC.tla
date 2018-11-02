---- MODULE MC ----
EXTENDS peterson, TLC

\* SPECIFICATION definition @modelBehaviorSpec:0
spec_15240049368148000 ==
Spec
----
\* INVARIANT definition @modelCorrectnessInvariants:0
inv_15240049368149000 ==
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"cas1"})
\/
(pc[1] \in {"ncs10","ncs11","check1"} /\ pc[0] \in {"cas0"})
\/
(pc[0] \in {"ncs00","ncs01","check0"} /\ pc[1] \in {"ncs10","ncs11","check1"})
----
=============================================================================
\* Modification History
\* Created Wed Apr 18 04:12:16 IST 2018 by aman
