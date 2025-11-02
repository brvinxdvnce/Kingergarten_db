-- Получение расписания для группы с учетом подгрупп за конкретную дату
-- Полное расписание, включая фиксированные и обычные занятия

SELECT 
	fc.time AS class_time,
	fc.class_type::text,
	kids_group.group_name AS groupname
FROM fixed_class AS fc
JOIN kids_group 
ON fc.group_id = kids_group.group_id
WHERE kids_group.group_id = '22c8dbad-b79a-4ba8-8b35-da1fac73ab2d'

UNION

SELECT
	c.class_time,
	sg.specialization AS class_type,
	sg.subgroup_name AS groupname
FROM class AS c
JOIN kids_group AS kg
ON kg.group_id = '22c8dbad-b79a-4ba8-8b35-da1fac73ab2d'
JOIN subgroup AS sg
ON sg.group_id = kg.group_id
WHERE C.class_date = '2025-11-03'

ORDER BY class_time