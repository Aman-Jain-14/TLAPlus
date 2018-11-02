(***************************************************************************
--fair algorithm bakery
variables Choosing = [ i \in 1..20 |-> FALSE], Number = [i \in 1..20 |-> 0], sum = 0, count = [i \in 1..20 |-> 0]
process P \in 1..20
variables temp = -1, check =0, id = self
begin
    remainderSection00: Choosing[self] := TRUE;
    remainderSection01: while (count[id] < 20) (*Finding max number*)
                            do
                            if temp < Number[count[id]]
                               then temp := Number[count[id]]
                            else temp := temp;
                            end if;
                           count[id] := count[id] + 1;
                        end while;
                        count[id] := 0;
                        Number[self] := temp + 1; (*Assigning max number + 1 to self*)
     remainderSection02: Choosing[self] := FALSE;
     remainderSection03: while( count[id] < 20 )
                            do
                            remainderSection04: while (Choosing[self] = TRUE) (*First busy wait*)
                                                do
                                                    skip
                                                end while;
                            remainderSection05: if (Number[count[id]] <= Number[self]) (*Finding if Number and id pair is smaller*)
                                                then if(count < self)
                                                        then check := TRUE
                                                     else
                                                        check := FALSE
                                                     end if
                                                else
                                                    check := FALSE
                                                end if;
                            remainderSection06: while (Number[count[id]] > 0 /\ check = TRUE) (*Second busy wait*)
                                                    do
                                                        skip;
                                                end while;
                          count[id] := count[id] + 1;
                          end while;
      criticalSection: sum := sum+1;
      exitSection: Number[self] := 0
  end process;
  end algorithm
 ***************************************************************************)
\* BEGIN TRANSLATION


\* END TRANSLATION
------------------------------ MODULE bakery1 ------------------------------
EXTENDS Integers
VARIABLES Choosing, Number, sum, count, pc, temp, check, id

vars == << Choosing, Number, sum, count, pc, temp, check, id >>

ProcSet == (1..20)

Init == (* Global variables *)
        /\ Choosing = [ i \in 1..20 |-> FALSE]
        /\ Number = [i \in 1..20 |-> 0]
        /\ sum = 0
        /\ count = [i \in 1..20 |-> 0]
        (* Process P *)
        /\ temp = [self \in 1..20 |-> -1]
        /\ check = [self \in 1..20 |-> 0]
        /\ id = [self \in 1..20 |-> self]
        /\ pc = [self \in ProcSet |-> "remainderSection00"]

remainderSection00(self) == /\ pc[self] = "remainderSection00"
                            /\ Choosing' = [Choosing EXCEPT ![self] = TRUE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                            /\ UNCHANGED << Number, sum, count, temp, check, 
                                            id >>

remainderSection01(self) == /\ pc[self] = "remainderSection01"
                            /\ IF (count[id[self]] < 20)
                                  THEN /\ IF temp[self] < Number[count[id[self]]]
                                             THEN /\ temp' = [temp EXCEPT ![self] = Number[count[id[self]]]]
                                             ELSE /\ temp' = [temp EXCEPT ![self] = temp[self]]
                                       /\ count' = [count EXCEPT ![id[self]] = count[id[self]] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                                       /\ UNCHANGED Number
                                  ELSE /\ count' = [count EXCEPT ![id[self]] = 0]
                                       /\ Number' = [Number EXCEPT ![self] = temp[self] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection02"]
                                       /\ temp' = temp
                            /\ UNCHANGED << Choosing, sum, check, id >>

remainderSection02(self) == /\ pc[self] = "remainderSection02"
                            /\ Choosing' = [Choosing EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection03"]
                            /\ UNCHANGED << Number, sum, count, temp, check, 
                                            id >>

remainderSection03(self) == /\ pc[self] = "remainderSection03"
                            /\ IF ( count[id[self]] < 20 )
                                  THEN /\ pc' = [pc EXCEPT ![self] = "remainderSection04"]
                                  ELSE /\ pc' = [pc EXCEPT ![self] = "criticalSection"]
                            /\ UNCHANGED << Choosing, Number, sum, count, temp, 
                                            check, id >>

remainderSection04(self) == /\ pc[self] = "remainderSection04"
                            /\ IF (Choosing[self] = TRUE)
                                  THEN /\ TRUE
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection04"]
                                  ELSE /\ pc' = [pc EXCEPT ![self] = "remainderSection05"]
                            /\ UNCHANGED << Choosing, Number, sum, count, temp, 
                                            check, id >>

remainderSection05(self) == /\ pc[self] = "remainderSection05"
                            /\ IF (Number[count[id[self]]] <= Number[self])
                                  THEN /\ IF (count < self)
                                             THEN /\ check' = [check EXCEPT ![self] = TRUE]
                                             ELSE /\ check' = [check EXCEPT ![self] = FALSE]
                                  ELSE /\ check' = [check EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection06"]
                            /\ UNCHANGED << Choosing, Number, sum, count, temp, 
                                            id >>

remainderSection06(self) == /\ pc[self] = "remainderSection06"
                            /\ IF (Number[count[id[self]]] > 0 /\ check[self] = TRUE)
                                  THEN /\ TRUE
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection06"]
                                       /\ count' = count
                                  ELSE /\ count' = [count EXCEPT ![id[self]] = count[id[self]] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection03"]
                            /\ UNCHANGED << Choosing, Number, sum, temp, check, 
                                            id >>

criticalSection(self) == /\ pc[self] = "criticalSection"
                         /\ sum' = sum+1
                         /\ pc' = [pc EXCEPT ![self] = "exitSection"]
                         /\ UNCHANGED << Choosing, Number, count, temp, check, 
                                         id >>

exitSection(self) == /\ pc[self] = "exitSection"
                     /\ Number' = [Number EXCEPT ![self] = 0]
                     /\ pc' = [pc EXCEPT ![self] = "Done"]
                     /\ UNCHANGED << Choosing, sum, count, temp, check, id >>

P(self) == remainderSection00(self) \/ remainderSection01(self)
              \/ remainderSection02(self) \/ remainderSection03(self)
              \/ remainderSection04(self) \/ remainderSection05(self)
              \/ remainderSection06(self) \/ criticalSection(self)
              \/ exitSection(self)

Next == (\E self \in 1..20: P(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

=============================================================================
\* Modification History
\* Last modified Thu Apr 19 23:23:16 IST 2018 by aman
\* Created Thu Apr 19 23:19:36 IST 2018 by aman
