--Отчет об аллергиях ребенка

SELECT 
	child.first_name AS Имя,
	child.last_name AS Фамилия,
	mc.issue_date AS Дата,
	mc.doctor AS Врач,
	mc.note AS Заметка,
	al.allergy_name AS Аллергия
FROM medical_certificate AS mc
JOIN child
	ON child.child_id = mc.child_id
JOIN allergy_certificate AS ac
	ON ac.certificate_id = mc.certificate_id
JOIN allergy_cert_allergy AS aca
ON aca.certificate_id = ac.certificate_id
JOIN allergy AS al
	ON al.allergy_id = aca.allergy_id
WHERE mc.child_id = '130cf589-4c3c-4a63-88db-233e41040cc3';

-- '130cf589-4c3c-4a63-88db-233e41040cc3'