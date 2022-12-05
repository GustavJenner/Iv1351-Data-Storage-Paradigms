CREATE VIEW ENSEMBLE_SCHEDULE AS  
SELECT ensemble.lesson_id, 
	   ensemble.genre, 
	   TO_CHAR(time_slot.date,'dy') AS WEEKDAY, 
	   COUNT(student_lesson.student_id) AS BOOKED_STUDENTS,
	   CASE 
			WHEN  COUNT(student_lesson.student_id) >= ensemble.max_number THEN 'FULLY BOOKED'
			WHEN  COUNT(student_lesson.student_id)+1 = ensemble.max_number THEN '1 SEAT LEFT'
			WHEN  COUNT(student_lesson.student_id)+2 = ensemble.max_number THEN '2 SEAT LEFT'
			ELSE 'SEATS AVAILABLE'
	   END AS test
FROM ensemble
INNER JOIN lesson on lesson.id = ensemble.lesson_id
INNER JOIN time_slot on time_slot.id = lesson.time_slot_id
AND DATE_PART('week',time_slot.date) = DATE_PART('week',CURRENT_DATE)
AND EXTRACT(YEAR FROM time_slot.date) = EXTRACT(YEAR FROM CURRENT_DATE)
INNER JOIN student_lesson ON ensemble.lesson_id = student_lesson.lesson_id
GROUP BY ensemble.lesson_id, ensemble.genre, time_slot.date
ORDER BY EXTRACT(dow FROM time_slot.date),genre

