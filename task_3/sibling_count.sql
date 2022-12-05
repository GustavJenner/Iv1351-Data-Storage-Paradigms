CREATE VIEW SIBLING_COUNT AS
SELECT Count(*), number_of_siblings
from(SELECT student.id, COUNT(siblings.sibling_a_id) AS number_of_siblings
	FROM student
	LEFT JOIN siblings
	on student.id = siblings.sibling_a_id or student.id = siblings.sibling_b_id
	group by student.id
	having COUNT(siblings.sibling_a_id) <= 2
	order by COUNT(siblings.sibling_a_id)) as f
group by number_of_siblings



