(***************************************************************************
--fair algorithm peterson 
variables flag0, flag1, turn \in {0, 1};

    process P0 = 0 
    begin
        ncs00: flag0 := true;
        ncs01: turn := 1;
        check0: while(flag1 == true and turn == 1)
        do
            cs0: skip;
        end while;
        flag0 := false;
    end process

    process p1 = 1
    begin 
        ncs10: flag1 := true;
        ncs11: turn := 0;
        check1: while(flag0 == true and turn == 0)
        do
            cs1: skip;
        end while;
        flag1 := false;
    end process
end algorithm
 ***************************************************************************)
\* BEGIN TRANSLATION
CONSTANT defaultInitValue
VARIABLES flag0, flag1, turn, pc

vars == << flag0, flag1, turn, pc >>

ProcSet == {0} \cup {1}

Init == (* Global variables *)
        /\ flag0 = defaultInitValue
        /\ flag1 = defaultInitValue
        /\ turn \in {0, 1}
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "ncs0"
                                        [] self = 1 -> "ncs1"]

ncs0 == /\ pc[0] = "ncs0"
        /\ flag0' = true
        /\ turn' = 1
        /\ pc' = [pc EXCEPT ![0] = "check0"]
        /\ flag1' = flag1

check0 == /\ pc[0] = "check0"
          /\ IF (flag1 == true and turn == 1)
                THEN /\ pc' = [pc EXCEPT ![0] = "cs0"]
                     /\ flag0' = flag0
                ELSE /\ flag0' = false
                     /\ pc' = [pc EXCEPT ![0] = "Done"]
          /\ UNCHANGED << flag1, turn >>

cs0 == /\ pc[0] = "cs0"
       /\ TRUE
       /\ pc' = [pc EXCEPT ![0] = "check0"]
       /\ UNCHANGED << flag0, flag1, turn >>

P0 == ncs0 \/ check0 \/ cs0

ncs1 == /\ pc[1] = "ncs1"
        /\ flag1' = true
        /\ turn' = 0
        /\ pc' = [pc EXCEPT ![1] = "check1"]
        /\ flag0' = flag0

check1 == /\ pc[1] = "check1"
          /\ IF (flag0 == true and turn == 0)
                THEN /\ pc' = [pc EXCEPT ![1] = "cs1"]
                     /\ flag1' = flag1
                ELSE /\ flag1' = false
                     /\ pc' = [pc EXCEPT ![1] = "Done"]
          /\ UNCHANGED << flag0, turn >>

cs1 == /\ pc[1] = "cs1"
       /\ TRUE
       /\ pc' = [pc EXCEPT ![1] = "check1"]
       /\ UNCHANGED << flag0, flag1, turn >>

p1 == ncs1 \/ check1 \/ cs1

Next == P0 \/ p1
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION
------------------------------ MODULE peterson ------------------------------
EXTENDS Integers

VARIABLES flag0, flag1, turn, pc, cs0, cs1

vars == << flag0, flag1, turn, pc, cs0, cs1>>

ProcSet == {0} \cup {1}

Init == (* Global variables *)
        /\ flag0 = FALSE
        /\ flag1 = FALSE
        /\ turn \in {0, 1}
        /\ cs0 = 0
        /\ cs1 = 0
        /\ pc = [self \in ProcSet |-> CASE self = 0 -> "ncs01"
                                        [] self = 1 -> "ncs11"]

ncs00 == /\ pc[0] = "ncs00"
        /\ flag0' = TRUE
        /\ turn' = turn
        /\ cs0' = cs0
        /\ cs1' = cs1
        /\ pc' = [pc EXCEPT ![0] = "check0"]
        /\ flag1' = flag1

ncs01 == /\ pc[0] = "ncs01"
        /\ flag0' = flag0
        /\ turn' = 1
        /\ cs0' = cs0
        /\ cs1' = cs1
        /\ pc' = [pc EXCEPT ![0] = "ncs00"]
        /\ flag1' = flag1

check0 == /\ pc[0] = "check0"
          /\ IF (flag1 = TRUE)
                THEN /\ IF(turn = 1)
                        THEN /\ pc' = [pc EXCEPT ![0] = "check0"]
                             /\ flag0' = flag0
                        ELSE /\ flag0' = TRUE
                             /\ pc' = [pc EXCEPT ![0] = "cas0"]
                ELSE /\ flag0' = TRUE
                     /\ pc' = [pc EXCEPT ![0] = "cas0"]
          /\ UNCHANGED << flag1, turn, cs1, cs0 >>

cas0 == /\ pc[0] = "cas0"
       (* /\ TRUE *)
       /\ cs0' = 1
       /\ pc' = [pc EXCEPT ![0] = "ncs00"]
       /\ flag0' = FALSE
       /\ UNCHANGED << flag1, turn, cs1 >>

P0 == ncs00 \/ ncs01 \/ check0 \/ cas0

ncs10 == /\ pc[1] = "ncs10"
        /\ flag1' = TRUE
        /\ turn' = turn
        /\ cs1' = cs1
        /\ cs0' = cs0
        /\ pc' = [pc EXCEPT ![1] = "check1"]
        /\ flag0' = flag0

ncs11 == /\ pc[1] = "ncs11"
        /\ flag1' = flag1
        /\ turn' = 0
        /\ cs1' = cs1
        /\ cs0' = cs0
        /\ pc' = [pc EXCEPT ![1] = "ncs10"]
        /\ flag0' = flag0

check1 == /\ pc[1] = "check1"
          /\ IF (flag0 = TRUE)
             THEN /\ IF(turn = 0)
                     THEN /\ pc' = [pc EXCEPT ![1] = "check1"]
                          /\ flag1' = flag1
                     ELSE /\ flag1' = TRUE
                          /\ pc' = [pc EXCEPT ![1] = "cas1"]
             ELSE /\ flag1' = TRUE
                  /\ pc' = [pc EXCEPT ![1] = "cas1"]
          /\ UNCHANGED << flag0, turn, cs0, cs1 >>

cas1 == /\ pc[1] = "cas1"
       (* /\ TRUE *)
       /\ cs1' = 1
       /\ flag1' = FALSE
       /\ pc' = [pc EXCEPT ![1] = "ncs10"]
       /\ UNCHANGED << flag0, turn, cs0 >>

p1 == ncs10 \/ ncs11 \/ check1 \/ cas1

Next == P0 \/ p1
           \/ (* Disjunct to prevent deadlock on termination *)
              ((\A self \in ProcSet: pc[self] = "Done") /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(\A self \in ProcSet: pc[self] = "Done")
Termination2 == <>(pc[0] = "cas0") /\ <>(pc[1] = "cas1")

=============================================================================
\* Modification History
\* Last modified Wed Apr 18 04:13:25 IST 2018 by aman
\* Last modified Tue Apr 17 16:32:57 EDT 2018 by azk68
\* Created Tue Apr 17 14:11:59 EDT 2018 by azk68
