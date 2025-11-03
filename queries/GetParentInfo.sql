-- Получить информацию и ребенках и родителях

SELECT
	c.first_name AS имя_ребенка,
	c.last_name AS фамилия_ребенка,
	p.first_name AS имя_родителя,
	p.last_name AS фамилия_родителя,
	p.phone_number AS телефон_родителя
FROM child as c
JOIN child_parent AS cp 
	ON cp.child_id = c.child_id
JOIN parent AS p 
	ON p.parent_id = cp.parent_id;