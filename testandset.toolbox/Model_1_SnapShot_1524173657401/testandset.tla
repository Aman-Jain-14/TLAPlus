(***************************************************************************
--fair algorithm testandset
variables rv = FALSE, lock = FALSE, sum = 0;
macro testandset(lock,temp) 
    begin 
        temp := lock; 
        lock := TRUE
    end macro;
process P \in 0..9
variables temp = FALSE
begin
     start: while ( TRUE )
            do
                busyWait: while (TRUE )
                            do
                               testandset(lock,temp);
                               if (temp = FALSE)
                                 then goto criticalSection;
                               end if; 
                            end while;
                criticalSection: sum:= sum + 1;
                remainderSection0: lock := FALSE
            end while;
end process
end algorithm
 ***************************************************************************)
\* BEGIN TRANSLATION

\* END TRANSLATION
----------------------------- MODULE testandset -----------------------------
EXTENDS Integers
VARIABLES lock, pc, temp

vars == << lock, pc, temp >>

ProcSet == (0..0)

Init == (* Global variables *)
        /\ lock = FALSE
        (* Process P *)
        /\ temp = [self \in 0..0 |-> FALSE]
        /\ pc = [self \in ProcSet |-> "start"]

start(self) == /\ pc[self] = "start"
               /\ pc' = [pc EXCEPT ![self] = "busyWait"]
               /\ UNCHANGED << lock, temp >>

busyWait(self) == /\ pc[self] = "busyWait"
                  /\ temp' = [temp EXCEPT ![self] = lock]
                  /\ lock' = TRUE
                  /\ IF (temp'[self] = FALSE)
                        THEN /\ pc' = [pc EXCEPT ![self] = "criticalSection"]
                        ELSE /\ pc' = [pc EXCEPT ![self] = "busyWait"]

criticalSection(self) == /\ pc[self] = "criticalSection"
                         /\ TRUE
                         /\ pc' = [pc EXCEPT ![self] = "remainderSection0"]
                         /\ UNCHANGED << lock, temp >>

remainderSection0(self) == /\ pc[self] = "remainderSection0"
                           /\ lock' = FALSE
                           /\ pc' = [pc EXCEPT ![self] = "busyWait"]
                           /\ UNCHANGED << temp >>

P(self) == start(self) \/ busyWait(self) \/ criticalSection(self)
              \/ remainderSection0(self)

Next == (\E self \in 0..0: P(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")
=============================================================================
\* Modification History
\* Last modified Fri Apr 20 03:04:07 IST 2018 by aman
\* Created Fri Apr 20 01:44:05 IST 2018 by aman
