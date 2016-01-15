with GNAT.IO; use GNAT.IO;

procedure Practical1 is
   task Caller;

   task body Caller is
   begin
      Put_Line("Hello world!");
   end Caller;

begin
   null;
end Practical1;
