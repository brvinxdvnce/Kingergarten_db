-- Получить отчет по посещаемости на определенную дату
-- Включает общее количество, количество присутствующих, отсутствующих и детей с аллергиями

SELECT
	COUNT(an.attended) as всего,
	COUNT(CASE WHEN an.attended = true THEN 1 END) AS присутствующие,
	COUNT(CASE WHEN an.attended = false THEN 1 END) AS отсутствующие,
	COUNT(DISTINCT CASE WHEN ac.certificate_id IS NOT NULL THEN an.child_id END) AS с_аллергиями
FROM attendance_note as an
LEFT JOIN medical_certificate as mc
ON mc.child_id = an.child_id
LEFT JOIN allergy_certificate as ac
ON ac.certificate_id = mc.certificate_id
WHERE an.note_date = '2025-11-03';


-- Получить отчет по посещаемости на определенную дату
-- Включает общее количество, количество присутствующих, отсутствующих и детей с аллергиями

SELECT
	COUNT(an.attended) as всего,
	COUNT(CASE WHEN an.attended = true THEN 1 END) AS присутствующие,
	COUNT(CASE WHEN an.attended = false THEN 1 END) AS отсутствующие,
	COUNT(DISTINCT CASE WHEN ac.certificate_id IS NOT NULL AND an.attended = true THEN an.child_id END) AS с_аллергиями
FROM attendance_note as an
LEFT JOIN medical_certificate as mc
ON mc.child_id = an.child_id
LEFT JOIN allergy_certificate as ac
ON ac.certificate_id = mc.certificate_id
WHERE an.note_date = '2025-11-03';