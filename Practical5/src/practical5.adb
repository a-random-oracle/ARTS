with GNAT.IO; use GNAT.IO;

procedure Practical5 is
   protected type Server is
      entry Wait(Id : Integer);

   private
      entry Hold(Id : Integer);

      Release : Boolean := False;
   end Server;

   protected body Server is
      entry Wait(Id : Integer) when True is
      begin
         if Id = 3 then
            Release := True;
            Put_Line("Task" & Integer'Image(Id) & " frees");
         else
            requeue Hold;
         end if;
      end Wait;

      entry Hold(Id : Integer) when Release is
      begin
         Put_Line("Task" & Integer'Image(Id) & " released");
         if Hold'count = 0 then
            Release := False;
         end if;
      end Hold;
   end Server;

   S : Server;

   task type Client(Id : Integer);
   task body Client is
   begin
      S.Wait(Id);
   end Client;

   C1 : Client(1);
   C2 : Client(2);
   C3 : Client(3);
   C4 : Client(4);
   C5 : Client(5);

begin
   null;
end Practical5;
