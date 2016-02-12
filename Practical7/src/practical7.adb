pragma Task_Dispatching_Policy(FIFO_WITHIN_PRIORITIES);
with GNAT.IO; use GNAT.IO;
with System; use System;
with Ada.Real_Time; use Ada.Real_Time;

procedure Practical7 is
   Epoch : constant Time := Clock;
   Start_Time : constant Time := Epoch + Milliseconds(1000);

   procedure Run(Start_Time : Time) is

   task type Periodic(T : Positive; Pri : Priority) is
      pragma Priority(Pri);
   end Periodic;

   task body Periodic is
      NextRelease : Time;
      Period : constant Time_Span := Milliseconds(T);
      Executions : Integer := 0;
   begin
      delay until Start_Time;

      NextRelease := Start_Time + Period;
      while Executions < 10 loop
         Put_Line("Periodic");

         delay until NextRelease;
         NextRelease := NextRelease + Period;

         Executions := Executions + 1;
      end loop;
   end Periodic;

   task type Other(Pri : Priority) is
      pragma Priority(Pri);
   end Other;

   task body Other is
      Count : Integer := 0;
      F : Integer := 0;
   begin
      delay until Start_Time;

      while Count < 50 loop
         Put_Line("Low Executing");

         for J in 1..5000 loop
            F := F + (J * 10);
         end loop;

         Count := Count + 1;
      end loop;

      Put_Line("Low Terminating");
   end;

   Periodic_Task : Periodic(100, Priority'First + 10);
   Other_Task : Other(Priority'First);
   begin
      null;
   end;

begin
   Run(Start_Time);
   delay until Start_Time + Milliseconds(60000);
end Practical7;
