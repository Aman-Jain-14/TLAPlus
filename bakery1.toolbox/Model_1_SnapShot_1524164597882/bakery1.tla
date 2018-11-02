(***************************************************************************
--fair algorithm bakery
variables Choosing = [ i \in 1..20 |-> FALSE], Number = [i \in 1..20 |-> 0], sum = 0
process P \in 1..20
variables temp = -1, check =0, count = 0
begin
    remainderSection00: Choosing[self] := TRUE;
    remainderSection01: while (count < 20) (*Finding max number*)
                            do
                            if temp < Number[count]
                               then temp := Number[count]
                            else temp := temp;
                            end if;
                           count := count + 1;
                        end while;
                        count := 0;
                        Number[self] := temp + 1; (*Assigning max number + 1 to self*)
     remainderSection02: Choosing[self] := FALSE;
     remainderSection03: while( count < 20 )
                            do
                            remainderSection04: while (Choosing[self] = TRUE) (*First busy wait*)
                                                do
                                                    skip
                                                end while;
                            remainderSection05: if (Number[count] <= Number[self]) (*Finding if Number and id pair is smaller*)
                                                then if(count < self)
                                                        then check := TRUE
                                                     else
                                                        check := FALSE
                                                     end if
                                                else
                                                    check := FALSE
                                                end if;
                            remainderSection06: while (Number[count] > 0 /\ check = TRUE) (*Second busy wait*)
                                                    do
                                                        skip;
                                                end while;
                          count := count + 1;
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
VARIABLES Choosing, Number, sum, pc, temp, check, count

vars == << Choosing, Number, sum, pc, temp, check, count >>

ProcSet == (1..2)

Init == (* Global variables *)
        /\ Choosing = [ i \in 1..2 |-> FALSE]
        /\ Number = [i \in 1..2 |-> 0]
        /\ sum = 0
        (* Process P *)
        /\ temp = [self \in 1..2 |-> -1]
        /\ check = [self \in 1..2 |-> 0]
        /\ count = [self \in 1..2 |-> 0]
        /\ pc = [self \in ProcSet |-> "remainderSection00"]

remainderSection00(self) == /\ pc[self] = "remainderSection00"
                            /\ Choosing' = [Choosing EXCEPT ![self] = TRUE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                            /\ UNCHANGED << Number, sum, temp, check, count >>

remainderSection01(self) == /\ pc[self] = "remainderSection01"
                            /\ IF (count[self] < 2)
                                  THEN /\ IF temp[self] < Number[sum]
                                             THEN /\ temp' = [temp EXCEPT ![self] = Number[self]]
                                             ELSE /\ temp' = [temp EXCEPT ![self] = temp[self]]
                                       /\ count' = [count EXCEPT ![self] = count[self] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection01"]
                                       /\ UNCHANGED Number
                                  ELSE /\ count' = [count EXCEPT ![self] = 0]
                                       /\ Number' = [Number EXCEPT ![self] = temp[self] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection02"]
                                       /\ temp' = temp
                            /\ UNCHANGED << Choosing, sum, check >>

remainderSection02(self) == /\ pc[self] = "remainderSection02"
                            /\ Choosing' = [Choosing EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection03"]
                            /\ UNCHANGED << Number, sum, temp, check, count >>

remainderSection03(self) == /\ pc[self] = "remainderSection03"
                            /\ IF ( count[self] < 2 )
                                  THEN /\ pc' = [pc EXCEPT ![self] = "remainderSection04"]
                                  ELSE /\ pc' = [pc EXCEPT ![self] = "criticalSection"]
                            /\ UNCHANGED << Choosing, Number, sum, temp, check, 
                                            count >>

remainderSection04(self) == /\ pc[self] = "remainderSection04"
                            /\ IF (Choosing[self] = TRUE)
                                  THEN /\ TRUE
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection04"]
                                  ELSE /\ pc' = [pc EXCEPT ![self] = "remainderSection05"]
                            /\ UNCHANGED << Choosing, Number, sum, temp, check, 
                                            count >>

remainderSection05(self) == /\ pc[self] = "remainderSection05"
                            /\ IF (Number[count[self]] <= Number[self])
                                  THEN /\ IF (count[self] < self)
                                             THEN /\ check' = [check EXCEPT ![self] = TRUE]
                                             ELSE /\ check' = [check EXCEPT ![self] = FALSE]
                                  ELSE /\ check' = [check EXCEPT ![self] = FALSE]
                            /\ pc' = [pc EXCEPT ![self] = "remainderSection06"]
                            /\ UNCHANGED << Choosing, Number, sum, temp, count >>

remainderSection06(self) == /\ pc[self] = "remainderSection06"
                            /\ IF (Number[count[self]] > 0 /\ check[self] = TRUE)
                                  THEN /\ TRUE
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection06"]
                                       /\ count' = count
                                  ELSE /\ count' = [count EXCEPT ![self] = count[self] + 1]
                                       /\ pc' = [pc EXCEPT ![self] = "remainderSection03"]
                            /\ UNCHANGED << Choosing, Number, sum, temp, check >>

criticalSection(self) == /\ pc[self] = "criticalSection"
                         /\ sum' = sum+1
                         /\ pc' = [pc EXCEPT ![self] = "exitSection"]
                         /\ UNCHANGED << Choosing, Number, temp, check, count >>

exitSection(self) == /\ pc[self] = "exitSection"
                     /\ Number' = [Number EXCEPT ![self] = 0]
                     /\ pc' = [pc EXCEPT ![self] = "Done"]
                     /\ UNCHANGED << Choosing, sum, temp, check, count >>

P(self) == remainderSection00(self) \/ remainderSection01(self)
              \/ remainderSection02(self) \/ remainderSection03(self)
              \/ remainderSection04(self) \/ remainderSection05(self)
              \/ remainderSection06(self) \/ criticalSection(self)
              \/ exitSection(self)

Next == (\E self \in 1..2: P(self))
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")


=============================================================================
\* Modification History
\* Last modified Fri Apr 20 00:33:13 IST 2018 by aman
\* Created Thu Apr 19 23:19:36 IST 2018 by aman
