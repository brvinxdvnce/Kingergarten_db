-- Триггер для проверки уникальности ссылки на medical_certificate

CREATE OR REPLACE FUNCTION check_medical_certificate_unique()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM chronic_disease_certificate WHERE certificate_id = NEW.certificate_id
        UNION ALL
        SELECT 1 FROM allergy_certificate         WHERE certificate_id = NEW.certificate_id
        UNION ALL
        SELECT 1 FROM vaccination_certificate     WHERE certificate_id = NEW.certificate_id
        UNION ALL
        SELECT 1 FROM pediatrician_certificate    WHERE certificate_id = NEW.certificate_id
    ) THEN
        RAISE EXCEPTION 'На эту справку уже ссылаются';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ensure_single_chronic_disease_certificate
    BEFORE INSERT ON chronic_disease_certificate
    FOR EACH ROW
    EXECUTE FUNCTION check_medical_certificate_unique();

CREATE TRIGGER ensure_single_allergy_certificate
    BEFORE INSERT ON allergy_certificate
    FOR EACH ROW
    EXECUTE FUNCTION check_medical_certificate_unique();

CREATE TRIGGER ensure_single_vaccination_certificate
    BEFORE INSERT ON vaccination_certificate
    FOR EACH ROW
    EXECUTE FUNCTION check_medical_certificate_unique();

CREATE TRIGGER ensure_single_pediatrician_certificate
    BEFORE INSERT ON pediatrician_certificate
    FOR EACH ROW
    EXECUTE FUNCTION check_medical_certificate_unique();