CREATE FUNCTION Overworking(max_lesson INT)
RETURNS TABLE(number_of_lessons INT, instructor INT)
AS 
$FUNCTION$
SELECT COUNT(instructor) AS number_of_lessons,instructor
FROM (SELECT lesson.instructor_id AS instructor, time_slot.date AS date
	FROM lesson
	INNER JOIN time_slot 
	on lesson.time_slot_id = time_slot.id 
	AND EXTRACT(MONTH FROM date) = (EXTRACT(MONTH FROM CURRENT_DATE))
	AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE)) AS f
GROUP BY instructor
HAVING COUNT(instructor) > max_lesson
ORDER BY number_of_lessons;
$FUNCTION$ LANGUAGE sql;
--SELECT*FROM overworking(6)
--Was used to get the result