with GNAT.IO; use GNAT.IO;
with System; use System;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Real_Time.Timing_Events; use Ada.Real_Time.Timing_Events;

procedure Practical8 is
   Epoch : constant Time := Clock;
   Start_Time : constant Time := Epoch + Milliseconds(1000);

   procedure Run is
      Periodic_Task_Firer : Timing_Event;

      protected type Periodic_Handler(T : Positive) is
         pragma Interrupt_Priority(Interrupt_Priority'Last);

         procedure Start (Start_Time : Time);
         entry Wait;
         procedure Handle (Event : in out Timing_Event);
      private
         Ready : Boolean := False;
         Next_Time : Time;
         Period : Time_Span := Milliseconds(T);
      end Periodic_Handler;

      protected body Periodic_Handler is
         procedure Start (Start_Time : Time) is
         begin
            Next_Time := Start_Time;
            Periodic_Task_Firer.Set_Handler(Next_Time, Handle'Unrestricted_access);
         end Start;

         entry Wait when Ready is
         begin
            Ready := False;
         end Wait;

         procedure Handle (Event : in out Timing_Event) is
         begin
            Ready := True;
            Next_Time := Next_Time + Period;
            Event.Set_Handler(Next_Time, Handle'Unrestricted_Access);
         end Handle;
      end Periodic_Handler;

      task type Periodic(T : Positive; Pri : Priority) is
         pragma Priority(Pri);
      end Periodic;

      task body Periodic is
         Handler : Periodic_Handler(T);
      begin
         Handler.Start(Start_Time);

         for i in 1..100 loop
            Handler.Wait;
            Put_Line("Periodic");
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
            F := 0;
            Put_Line("Low Executing");

            for J in 1..10000 loop
               F := F + (J * 10);
            end loop;

            Count := Count + 1;
         end loop;

         Put_Line("Low Terminating");
      end;

      Periodic_Task : Periodic(500, System.Priority'First + 5);
      Other_Task : Other(Priority'First);
   begin
      null;
   end Run;
begin
   Run;
   delay until Start_Time + Milliseconds(60000);
end Practical8;
