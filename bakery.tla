(***************************************************************************
--fair algorithm bakery
variables Choosing = [ i \in 1..20 |-> FALSE], Number = [i \in 1..20 |-> 0], sum = 0, count = [i \in 1..20 |-> 0]
process P \in 1..20
variables temp = -1, check =0
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
------------------------------- MODULE bakery -------------------------------