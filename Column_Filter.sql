CREATE OR REPLACE 
FUNCTION Column_Filter(original varchar2,length_str number)
  RETURN varchar2 IS
  tekst varchar2(255);
  
BEGIN
  
   IF original IS null THEN
   RETURN null;

   ELSIF Length(trim(original))>=length_str  THEN
     RETURN trim(original);

   ELSE
    
    RETURN null;

END IF;
END Column_Filter;