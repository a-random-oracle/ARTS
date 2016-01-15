with GNAT.IO; use GNAT.IO;

procedure Practical4 is
   type IntArray is array (0..10) of Integer;

   Contents : IntArray;
   pragma Volatile(Contents);

   protected type ProtectedArray is
      procedure Initialise;
      procedure Print;

      entry Set1 (I: in Integer);
      entry Set7 (I: in Integer);
   private
      Last : Integer := 7;
      Count : Integer := 1;
   end ProtectedArray;

   protected body ProtectedArray is
      procedure Initialise is
      begin
         for I in Contents'Range loop
            Contents(I) := 0;
         end loop;
      end Initialise;

      procedure Print is
      begin
         for I in Contents'Range loop
            Put(Integer'Image(Contents(I)));
         end loop;
      end Print;

      entry Set1 (I: in Integer) when Last = 7 is
      begin
         if Count = 1 then
            Last := 1;
            Count := 0;
         else
            Count := Count + 1;
         end if;

         Contents(I) := 1;
      end Set1;

      entry Set7 (I: in Integer) when Last = 1 is
      begin
         if Count = -1 or Count = 1 then
            Last := 7;
            Count := 0;
         else
            Count := Count + 1;
         end if;

         Contents(I) := 7;
      end Set7;
   end ProtectedArray;

   Ints : ProtectedArray;

   procedure Tasks is
      task Ones;
      task Sevens;

      task body Ones is
      begin
         for I in Contents'Range loop
            Ints.Set1(I);
         end loop;
      end Ones;

      task body Sevens is
      begin
         for I in Contents'Range loop
            Ints.Set7(I);
         end loop;
      end Sevens;
   begin
      null;
   end Tasks;
begin
   Ints.Initialise;

   Tasks;

   Ints.Print;
end Practical4;
