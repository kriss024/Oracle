CREATE OR REPLACE 
FUNCTION Telephone_Filter(original varchar2)
  RETURN varchar2 IS
  
  tekst varchar2(255);
  stekst varchar2(255);

BEGIN
   IF original IS null THEN
   RETURN null;

   ELSIF original IS NOT null  THEN
   
       FOR x IN 1 .. LENGTH(original) LOOP
           IF SUBSTR(original,x,1) IN (' ','/','*','+','-','p','w','#','(',')','1','2','3','4','5','6','7','8','9','0') THEN
              stekst := SUBSTR(original,x,1);
              tekst  := CONCAT(tekst,stekst);
           END IF;
   END LOOP;
   tekst:=replace(tekst, '-', ' ');
   tekst:=trim(tekst);
   IF  Length(tekst)>=7 THEN
      RETURN tekst;
   ELSE
      RETURN null;
  END IF;
END IF;
END Telephone_Filter;