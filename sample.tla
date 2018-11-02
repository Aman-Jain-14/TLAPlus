------------------------------- MODULE sample -------------------------------
CONSTANT N
N == 5
EXTENDS Integers
CONSTANT defaultInitValue
VARIABLES X, pc, r

vars == << X, pc, r >>

ProcSet == (1..N)

Init == (* Global variables *)
        /\ X = 0
        (* Process Proc *)
        /\ r = [self \in 1..N |-> defaultInitValue]
        /\ pc = [self \in ProcSet |-> "trying"]

trying(self) == /\ pc[self] = "trying"
                /\ pc' = [pc EXCEPT ![self] = "t1"]
                /\ UNCHANGED << X, r >>

t1(self) == /\ pc[self] = "t1"
            /\ r' = [r EXCEPT ![self] = X]
            /\ X' = 1
            /\ pc' = [pc EXCEPT ![self] = "t2"]

t2(self) == /\ pc[self] = "t2"
            /\ IF r[self]=0
                  THEN /\ pc' = [pc EXCEPT ![self] = "criticalsection"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "trying"]
            /\ UNCHANGED << X, r >>

criticalsection(self) == /\ pc[self] = "criticalsection"
                         /\ TRUE
                         /\ pc' = [pc EXCEPT ![self] = "exit"]
                         /\ UNCHANGED << X, r >>

exit(self) == /\ pc[self] = "exit"
              /\ X' = 0
              /\ pc' = [pc EXCEPT ![self] = "noncriticalsection"]
              /\ r' = r

noncriticalsection(self) == /\ pc[self] = "noncriticalsection"
                            /\ TRUE
                            /\ PrintT(self)
                            /\ pc' = [pc EXCEPT ![self] = "trying"]
                            /\ UNCHANGED << X, r >>

Proc(self) == trying(self) \/ t1(self) \/ t2(self) \/ criticalsection(self)
                 \/ exit(self) \/ noncriticalsection(self)

Next == (\E self \in 1..N: Proc(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

=============================================================================
\* Modification History
\* Last modified Fri Apr 20 02:24:50 IST 2018 by aman
\* Created Fri Apr 20 02:21:55 IST 2018 by aman
