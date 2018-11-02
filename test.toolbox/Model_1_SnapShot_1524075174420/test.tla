(***************************************************************************
--fair algorithm peterson

variables turn = 0, total = 2, flag = [i \in 1..2 |-> FALSE], sum = 0
process P \in 1..2
variables id = self
 begin
    remainderSection00: flag[self]:=TRUE;
    remainderSection01: turn := (self + 1)%total;
    check: while (flag[self+1] == TRUE /\ turn == (self+1)%total)
                do
                    busyWait: skip;
                end while;
    criticalSection00: sum := sum + 1;
    remainderSection02: flag[self] := FALSE
 end process;
end algorithm;
 ***************************************************************************)
\* BEGIN TRANSLATION
VARIABLES turn, total, flag, sum, pc, id

vars == << turn, total, flag, sum, pc, id >>

ProcSet == (1..2)

Init == (* Global variables *)
        /\ turn = 0
        /\ total = 2
        /\ flag = [i \in 1..2 |-> FALSE]
        /\ sum = 0
        (* Process P *)
        /\ id = [self \in 1..2 |-> self]
        /\ pc = [self \in ProcSet |-> "remainderSection00"]

remainderSection00(self) == /\ pc[self] = "remainderSection00"
                            /\ flag' = [flag EXCEPT ![self] = TRUE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                            /\ UNCHANGED << turn, total, sum, id >>

remainderSection01(self) == /\ pc[self] = "remainderSection01"
                            /\ turn' = (self + 1)%total
                            /\ pc' = [pc EXCEPT ![self] = "check"]
                            /\ UNCHANGED << total, flag, sum, id >>

check(self) == /\ pc[self] = "check"
               /\ IF (flag[self+1] == TRUE /\ turn == (self+1)%total)
                     THEN /\ pc' = [pc EXCEPT ![self] = "busyWait"]
                     ELSE /\ pc' = [pc EXCEPT ![self] = "criticalSection00"]
               /\ UNCHANGED << turn, total, flag, sum, id >>

busyWait(self) == /\ pc[self] = "busyWait"
                  /\ TRUE
                  /\ pc' = [pc EXCEPT ![self] = "check"]
                  /\ UNCHANGED << turn, total, flag, sum, id >>

criticalSection00(self) == /\ pc[self] = "criticalSection00"
                           /\ sum' = sum + 1
                           /\ pc' = [pc EXCEPT ![self] = "remainderSection02"]
                           /\ UNCHANGED << turn, total, flag, id >>

remainderSection02(self) == /\ pc[self] = "remainderSection02"
                            /\ flag' = [flag EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "Done"]
                            /\ UNCHANGED << turn, total, sum, id >>

P(self) == remainderSection00(self) \/ remainderSection01(self)
              \/ check(self) \/ busyWait(self) \/ criticalSection00(self)
              \/ remainderSection02(self)

Next == (\E self \in 1..2: P(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION
-------------------------------- MODULE test --------------------------------
EXTENDS Integers
VARIABLES turn, total, flag, sum, pc, temp

vars == << turn, total, flag, sum, pc >>

ProcSet == (1..2)

Pos(a) == (a+1)%total

Init == (* Global variables *)
        /\ temp = 0
        /\ turn = 0
        /\ total = 2
        /\ flag = [i \in 1..2 |-> FALSE]
        /\ sum = 0
        /\ pc = [self \in ProcSet |-> "remainderSection00"]

remainderSection00(self) == /\ pc[self] = "remainderSection00"
                            /\ flag' = [flag EXCEPT ![self] = TRUE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                            /\ UNCHANGED << turn, total, sum, temp >>

remainderSection01(self) == /\ pc[self] = "remainderSection01"
                            /\ turn' = (self + 1)%total
                            /\ pc' = [pc EXCEPT ![self] = "check"]
                            /\ UNCHANGED << total, flag, sum, temp >>

check(self) == /\ pc[self] = "check"
               /\ temp' = flag[self]
               /\ IF (flag[self] = TRUE) 
                  THEN /\ IF (turn = (self+1)%total)
                          THEN /\ pc' = [pc EXCEPT ![self] = "busyWait"]
                          ELSE /\ pc' = [pc EXCEPT ![self] = "criticalSection00"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "criticalSection00"]
               /\ UNCHANGED << turn, total, flag, sum >>

busyWait(self) == /\ pc[self] = "busyWait"
                  /\ TRUE
                  /\ pc' = [pc EXCEPT ![self] = "check"]
                  /\ UNCHANGED << turn, total, flag, sum, temp >>

criticalSection00(self) == /\ pc[self] = "criticalSection00"
                           /\ sum' = sum + 1
                           /\ pc' = [pc EXCEPT ![self] = "remainderSection02"]
                           /\ UNCHANGED << turn, total, flag, temp >>

remainderSection02(self) == /\ pc[self] = "remainderSection02"
                            /\ flag' = [flag EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "Done"]
                            /\ UNCHANGED << turn, total, sum, temp >>

P(self) == remainderSection00(self) \/ remainderSection01(self)
              \/ check(self) \/ busyWait(self) \/ criticalSection00(self)
              \/ remainderSection02(self)

Next == (\E self \in 1..2: P(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

=============================================================================
\* Modification History
\* Last modified Wed Apr 18 23:42:47 IST 2018 by aman
\* Created Wed Apr 18 20:46:57 IST 2018 by aman
