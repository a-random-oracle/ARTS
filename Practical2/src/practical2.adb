with GNAT.IO; use GNAT.IO;

procedure Practical2 is
   task Numbers;
   task Letters;

   task body Numbers is
   begin
      for Num in 1..100 loop
         Put_Line(Integer'Image(Num));
      end loop;
   end Numbers;

   task body Letters is
   begin
      for Letter in 97..122 loop
         Put_Line(Character'Image(Character'Val(Letter)));
      end loop;

      for Letter in 65..90 loop
         Put_Line(Character'Image(Character'Val(Letter)));
      end loop;
   end Letters;

begin
   null;
end Practical2;
