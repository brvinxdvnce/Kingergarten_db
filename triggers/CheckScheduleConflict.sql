--Триггер на проверку конфликтов в расписании

CREATE OR REPLACE FUNCTION check_schedule_conflict()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM fixed_class 
        WHERE group_id IN (SELECT group_id FROM subgroup WHERE subgroup_id = NEW.subgroup_id)
        AND time = NEW.class_time
    ) THEN
        RAISE EXCEPTION 'Группа уже имеет занятия в это время';
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM class 
        WHERE subgroup_id = NEW.subgroup_id 
        AND class_date = NEW.class_date 
        AND class_time = NEW.class_time
        AND (TG_OP = 'INSERT' OR class_time != OLD.class_time OR class_date != OLD.class_date)
    ) THEN
        RAISE EXCEPTION 'Подгруппа уже имеет занятие в это время';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_schedule_conflict
    BEFORE INSERT OR UPDATE ON class
    FOR EACH ROW
    EXECUTE FUNCTION check_schedule_conflict();