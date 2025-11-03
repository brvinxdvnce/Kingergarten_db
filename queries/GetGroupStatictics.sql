SELECT 
	kg.group_name AS название,
	kg.age_category AS возраст_категория,
	COUNT(c.child_id) AS количество_детей_в_группе
FROM kids_group AS kg
JOIN child AS c
	ON c.group_id = kg.group_id
GROUP BY kg.group_id;