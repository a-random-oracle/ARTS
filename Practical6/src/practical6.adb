with GNAT.IO; use GNAT.IO;
with Ada.Numerics.Discrete_Random;

procedure Practical6 is
   Client_Count : constant Integer := 5;
   Releaser : constant Integer := 3;

   protected type Server is
      entry Wait(Id : Integer);
   private
      entry Hold(1..5);
      function CountOnHold return Integer;

      Release : Boolean := False;
      AllArrived : Boolean := False;
   end Server;

   protected body Server is
      entry Wait(Id : Integer) when True is
      begin
         Put_Line("Task" & Integer'Image(Id) & " arrived");

         if CountOnHold + 1 = Client_Count then
            AllArrived := True;
         end if;

         if Id = Releaser then
            Release := True;
         end if;

         requeue Hold(Id);
      end Wait;

      entry Hold(for I in 1..5) when Release and AllArrived is
      begin
         if I /= 1 then
            if Hold(I - 1)'Count /= 0 then
               requeue Hold(I);
            end if;
         end if;

         if CountOnHold = 0 then
            Release := False;
            AllArrived := False;
         end if;

         Put_Line("Task" & Integer'Image(I) & " released");
      end Hold;

      function CountOnHold return Integer is
         Count : Integer := 0;
      begin
         for I in 1..5 loop
            Count := Count + Hold(I)'Count;
         end loop;

         return Count;
      end CountOnHold;
   end Server;

   S : Server;

   task type Client(Id : Integer);
   task body Client is
      subtype Rand_Range is Integer range 1..10;
      package Random_Integer is new Ada.Numerics.Discrete_Random(Rand_Range);
      Generator : Random_Integer.Generator;
      Random_Int : Integer;
   begin
      Random_Int := Random_Integer.Random(Generator);
      delay Random_Int * 1.0;
      S.Wait(Id);
   end Client;

   C1 : Client(1);
   C2 : Client(2);
   C3 : Client(3);
   C4 : Client(4);
   C5 : Client(5);

begin
   null;
end Practical6;
