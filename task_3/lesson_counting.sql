CREATE FUNCTION public.lesson_counting(input_year integer) 
RETURNS TABLE(mo character varying, tot_lesson integer, ind_lesson integer, grp_lesson integer, ens_lesson integer)
    LANGUAGE sql
    AS $$
SELECT mo, tot_lesson,ind_lesson,grp_lesson,ens_lesson
FROM(SELECT TO_CHAR(time_slot.date,'MONTH') AS mo,
		   COUNT(lesson.id) AS tot_lesson, 
		   COUNT(individual_lesson.lesson_id) AS ind_lesson,
		   COUNT(group_lesson.lesson_id) AS grp_lesson,
		   COUNT(ensemble.lesson_id) AS ens_lesson
	FROM time_slot
	INNER JOIN lesson on time_slot.id = lesson.time_slot_id 
	AND EXTRACT(YEAR FROM time_slot.date) = INPUT_YEAR
	LEFT JOIN individual_lesson on lesson.id = individual_lesson.lesson_id
	LEFT JOIN group_lesson on lesson.id = group_lesson.lesson_id
	LEFT JOIN ensemble on lesson.id = ensemble.lesson_id
	group by mo) AS f
ORDER BY EXTRACT(MONTH FROM TO_DATE(mo,'MONTH'));
$$;
--SELECT*FROM lesson_counting(2022)
--To get result


