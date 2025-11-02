-- Триггер, проверяющий, что с детьми работает сотрудник с правильной должностью

CREATE OR REPLACE FUNCTION check_employee_roles()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nanny IS NOT NULL AND NEW.teacher IS NOT NULL AND NEW.nanny = NEW.teacher THEN
        RAISE EXCEPTION 'Няня и воспитатель не могут быть одним человеком';
    END IF;
    
    IF NEW.nanny IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM employee 
            WHERE employee_id = NEW.nanny AND position = 'няня'
    ) THEN
        RAISE EXCEPTION 'Сотрудник должен иметь должность "няня"';
    END IF;
    
    IF NEW.teacher IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM employee WHERE employee_id = NEW.teacher AND position = 'воспитатель'
    ) THEN
        RAISE EXCEPTION 'Сотрудник должен иметь должность "воспитатель"';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_employee_roles
    BEFORE INSERT OR UPDATE ON kids_group
    FOR EACH ROW
    EXECUTE FUNCTION check_employee_roles();