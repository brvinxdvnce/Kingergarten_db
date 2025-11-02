CREATE TABLE kindergarten (
    kindergarten_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name            VARCHAR(255) NOT NULL,
    address         VARCHAR(255) NOT NULL,
    phone_number    VARCHAR(20)
);

CREATE TABLE child (
    child_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    birth_certificate VARCHAR(20) UNIQUE NOT NULL,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    gender            VARCHAR(10) NOT NULL CHECK (gender IN ('мужской','женский')),
    birth_date        DATE NOT NULL CHECK (birth_date > DATE '2000-01-01' AND birth_date <= CURRENT_DATE),
    group_id          UUID,

    FOREIGN KEY (group_id) REFERENCES kids_group(group_id) ON DELETE SET NULL
);

CREATE TABLE parent (
    parent_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gender       VARCHAR(10) NOT NULL CHECK (gender IN ('мужской','женский')),
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    address      VARCHAR(255) NOT NULL
);

CREATE TABLE kids_group (
    group_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_name      VARCHAR(30) NOT NULL,
    age_category    age_category_enum NOT NULL,
    classroom       VARCHAR(10),
    kindergarten_id UUID NOT NULL,
    nanny           UUID UNIQUE,
    teacher         UUID UNIQUE,

    FOREIGN KEY (kindergarten_id) REFERENCES kindergarten(kindergarten_id) ON DELETE CASCADE,
    FOREIGN KEY (nanny) REFERENCES employee(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (teacher) REFERENCES employee(employee_id) ON DELETE SET NULL
);

CREATE TABLE subgroup (
    subgroup_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subgroup_name  VARCHAR(150),
    classroom      VARCHAR(10),
    group_id       UUID NOT NULL,
    teacher        UUID,
    specialization VARCHAR(100),

    FOREIGN KEY (group_id) REFERENCES kids_group(group_id),
    FOREIGN KEY (teacher) REFERENCES Employee(employee_id),
    FOREIGN KEY (specialization) REFERENCES specialization(specialization_name) ON DELETE SET NULL
);

CREATE TABLE specialization (
    specialization_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE fixed_class (
    group_id       UUID,
    time           timeslot_enum,
    class_type     activity_enum,

    UNIQUE (group_id, time),
    FOREIGN KEY (group_id) REFERENCES kids_group(group_id) ON DELETE CASCADE
);

CREATE TABLE class (
    subgroup_id UUID NOT NULL,
    class_time  timeslot_enum,
    class_date  DATE,

    UNIQUE (subgroup_id, class_date, class_time),
    FOREIGN KEY (subgroup_id) REFERENCES subgroup(subgroup_id) ON DELETE CASCADE
);

CREATE TABLE employee (
    employee_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name   VARCHAR(100) NOT NULL,
    last_name    VARCHAR(100) NOT NULL,
    position     position_enum,
    phone_number VARCHAR(20),
    birth_date   DATE NOT NULL CHECK (birth_date > DATE '1900-01-01' AND birth_date < CURRENT_DATE)
);

CREATE TABLE attendance_note (
    child_id  UUID,
    note_date DATE NOT NULL,
    attended  BOOLEAN NOT NULL,
    note      TEXT,

    UNIQUE (child_id, note_date),
    FOREIGN KEY (child_id) REFERENCES child(child_id) ON DELETE CASCADE
);



CREATE TABLE medical_certificate (
    certificate_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_id       UUID,
    issue_date     DATE,
    doctor         VARCHAR(200),
    symptoms       TEXT,
    note           TEXT,

    FOREIGN KEY (child_id) REFERENCES child(child_id) ON DELETE CASCADE
);

CREATE TABLE chronic_disease_certificate (
    certificate_id UUID PRIMARY KEY REFERENCES medical_certificate(certificate_id) ON DELETE CASCADE,
    restrictions   TEXT
);

CREATE TABLE allergy_certificate (
    certificate_id UUID PRIMARY KEY REFERENCES medical_certificate(certificate_id) ON DELETE CASCADE,
    expiry_date    DATE,
    drugs          TEXT,
    reaction_type VARCHAR(50)
);

CREATE TABLE vaccination_certificate (
    certificate_id UUID PRIMARY KEY REFERENCES medical_certificate(certificate_id) ON DELETE CASCADE,
    immunization_type VARCHAR(50),
    expiry_date       DATE,
    dose              VARCHAR(100),
    vaccine_id UUID   REFERENCES vaccine(vaccine_id) ON DELETE SET NULL
);

CREATE TABLE pediatrician_certificate (
    certificate_id UUID PRIMARY KEY REFERENCES medical_certificate(certificate_id) ON DELETE CASCADE,
    allowed        BOOLEAN,
    expiry_date    DATE
);



CREATE TABLE chronic_disease (
    disease_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    disease_code VARCHAR(10) UNIQUE NOT NULL,
    disease_name VARCHAR(100) NOT NULL
);

CREATE TABLE allergy (
    allergy_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    allergy_code VARCHAR(10) UNIQUE NOT NULL,
    allergy_name VARCHAR(100) NOT NULL
);

CREATE TABLE vaccine (
    vaccine_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vaccine_code  VARCHAR(20) NOT NULL,
    vaccine_name  VARCHAR(100) NOT NULL,
    manufacturer  VARCHAR(200),
    batch_number  VARCHAR(20),
    expiry_date   DATE NOT NULL CHECK (expiry_date > delivery_date),
    delivery_date DATE NOT NULL
);

CREATE TABLE illness (
    illness_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    illness_code VARCHAR(10) UNIQUE NOT NULL,
    illness_name VARCHAR(100) NOT NULL
);




CREATE TABLE child_parent (
    child_id    UUID,
    parent_id   UUID,

    FOREIGN KEY (child_id) REFERENCES child(child_id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES parent(parent_id) ON DELETE CASCADE,
    PRIMARY KEY (child_id, parent_id)
);

CREATE TABLE child_subgroup (
    child_id    UUID,
    subgroup_id UUID,

    PRIMARY KEY (child_id, subgroup_id),
    FOREIGN KEY (child_id) REFERENCES child(child_id) ON DELETE CASCADE,
    FOREIGN KEY (subgroup_id) REFERENCES subgroup(subgroup_id) ON DELETE CASCADE
);

CREATE TABLE chronic_cert_disease (
    certificate_id UUID NOT NULL,
    disease_id     UUID NOT NULL,

    FOREIGN KEY (certificate_id) REFERENCES chronic_disease_certificate(certificate_id) ON DELETE CASCADE,
    FOREIGN KEY (disease_id) REFERENCES chronic_disease(disease_id) ON DELETE CASCADE,
    PRIMARY KEY (certificate_id, disease_id)
);

CREATE TABLE pediatric_cert_illness (
    certificate_id UUID NOT NULL,
    illness_id     UUID NOT NULL,

    FOREIGN KEY (certificate_id) REFERENCES pediatrician_certificate(certificate_id) ON DELETE CASCADE,
    FOREIGN KEY (illness_id) REFERENCES illness(illness_id) ON DELETE CASCADE,
    PRIMARY KEY (certificate_id, illness_id)
);

CREATE TABLE allergy_cert_allergy (
    certificate_id UUID NOT NULL,
    allergy_id     UUID NOT NULL,
    severity       TEXT CHECK (severity in ('легкая', 'умеренная', 'тяжелая')),

    FOREIGN KEY (certificate_id) REFERENCES allergy_certificate(certificate_id) ON DELETE CASCADE,
    FOREIGN KEY (allergy_id) REFERENCES allergy(allergy_id) ON DELETE CASCADE,
    PRIMARY KEY (certificate_id, allergy_id)
);
