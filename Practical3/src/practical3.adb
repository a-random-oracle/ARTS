with GNAT.IO; use GNAT.IO;

procedure Practical3 is
   Ints : array(1..10) of Integer;
   pragma Volatile(Ints);

   procedure Pause is
   begin
      for i in 1..10000 loop
         null;
      end loop;
   end Pause;

   procedure Tasks is
      task Ones;
      task Sevens;

      task body Ones is
      begin
         for I in Ints'Range loop
            Ints(I) := 1;
            Pause;
         end loop;
      end Ones;

      task body Sevens is
      begin
         for I in Ints'Range loop
            Ints(I) := 7;
            Pause;
         end loop;
      end Sevens;
   begin
      null;
   end Tasks;
begin
   for I in Ints'Range loop
      Ints(I) := 0;
   end loop;

   Tasks;

   for I in Ints'Range loop
      Put(Integer'Image(Ints(I)));
   end loop;
end Practical3;
