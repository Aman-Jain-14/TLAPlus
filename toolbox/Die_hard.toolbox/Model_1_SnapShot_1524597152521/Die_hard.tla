(***************************************************************************
--algorithm DieHard {
    variables big = 0, small = 0 ;
    { while ( true )
        
        { either big := 5
            or
          small := 3 
            or
          big := 0
          
            or
          small := 0
            or
          
          with ( poured = Min(big + small , 5) - big )
            { big := big + poured ;
              small := small - poured }
          
                    or
          with ( poured = Min(big + small , 3) - small )
            { big := big - poured ;
              small := small + poured }
        }
    }
}
 ***************************************************************************)
\* BEGIN TRANSLATION
VARIABLES big, small, pc

vars == << big, small, pc >>

Init == (* Global variables *)
        /\ big = 0
        /\ small = 0
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF true
               THEN /\ \/ /\ big' = 5
                          /\ small' = small
                       \/ /\ small' = 3
                          /\ big' = big
                       \/ /\ big' = 0
                          /\ small' = small
                       \/ /\ small' = 0
                          /\ big' = big
                       \/ /\ LET poured == Min(big + small , 5) - big IN
                               /\ big' = big + poured
                               /\ small' = small - poured
                       \/ /\ LET poured == Min(big + small , 3) - small IN
                               /\ big' = big - poured
                               /\ small' = small + poured
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << big, small >>

Next == Lbl_1
           \/ (* Disjunct to prevent deadlock on termination *)
              (pc = "Done" /\ UNCHANGED vars)

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION
------------------------------ MODULE Die_hard ------------------------------
EXTENDS Integers
VARIABLES big, small, pc

vars == << big, small, pc >>


Min(a,b) == IF a < b THEN a
            ELSE b

Init == (* Global variables *)
        /\ big = 0
        /\ small = 0
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF TRUE
               THEN /\ \/ /\ big' = 5
                          /\ small' = small
                       \/ /\ small' = 3
                          /\ big' = big
                       \/ /\ big' = 0
                          /\ small' = small
                       \/ /\ small' = 0
                          /\ big' = big
                       \/ /\ LET poured == Min(big + small , 5) - big IN
                               /\ big' = big + poured
                               /\ small' = small - poured
                       \/ /\ LET poured == Min(big + small , 3) - small IN
                               /\ big' = big - poured
                               /\ small' = small + poured
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << big, small >>

Next == Lbl_1
           \/ (* Disjunct to prevent deadlock on termination *)
              (pc = "Done" /\ UNCHANGED vars)

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")
=============================================================================
\* Modification History
\* Last modified Mon Apr 16 19:34:04 EDT 2018 by axj182
\* Created Mon Apr 16 18:47:40 EDT 2018 by axj182
