CREATE OR REPLACE 
FUNCTION EMail_Filter(original varchar2)
  RETURN varchar2 IS

BEGIN
   IF original IS null THEN
   RETURN null;

   ELSIF original like '%@%.%'  THEN
     RETURN trim(lower(original));

   ELSE
    
    RETURN null;

END IF;
END EMail_Filter;