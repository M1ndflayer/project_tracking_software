CREATE TABLE employee(
    employee_id SERIAL,
    first_name VARCHAR(100),
    last_name VARCHAR(150),
    mail VARCHAR(150),
    workphone VARCHAR(20),

    PRIMARY KEY(employee_id)
);

CREATE TYPE project_or_task_status AS ENUM('not_started','on_hold', 'in_progress', 'cancelled');

CREATE TABLE project (
    project_id SERIAL,
    starting_date DATE,
    planned_end_date DATE,
    project_status project_or_task_status,
    company_id INTEGER,

    PRIMARY KEY (project_id)
);

CREATE TABLE company (
    company_id SERIAL,
    company_name VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(100),
    country VARCHAR(100),
    email varchar(150),
    phone VARCHAR(20),
    
    PRIMARY KEY (company_id)
);

CREATE TABLE employee_project(
    employee_id INTEGER,
    project_id INTEGER,
    project_role_id INTEGER,

    PRIMARY KEY (employee_id, project_id, project_role_id)
);

CREATE TABLE employee_task(
    employee_id INTEGER,
    task_id INTEGER,

    PRIMARY KEY (employee_id, task_id)
);

CREATE TABLE tracking(
    tracking_id SERIAL,
    tracked_time INTERVAL,
    tracked_on TIMESTAMP,
    employee_id INTEGER,
    task_ID INTEGER,

    PRIMARY KEY (tracking_id)
);

CREATE TABLE company_contact(
    contact_id SERIAL,
    first_name VARCHAR(100),
    last_name VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(20),
    company_position VARCHAR(100),
    company_id INTEGER,

    PRIMARY KEY (contact_id)
);

CREATE TABLE project_role(
    project_role_id SERIAL,
    role_name VARCHAR(100),
    role_description TEXT,

    PRIMARY KEY (project_role_id)
);

CREATE TABLE task(
    task_id SERIAL,
    task_name VARCHAR(100),
    task_description TEXT,
    started_on TIMESTAMP,
    due_on TIMESTAMP,
    task_status project_or_task_status,
    project_id INTEGER,

    PRIMARY KEY (task_id)
);

CREATE TABLE milestone(
    milestone_id SERIAL,
    milestone_description TEXT,
    planned_for TIMESTAMP,
    is_finished BOOLEAN,
    finished_on TIMESTAMP,
    project_id INTEGER,

    PRIMARY KEY(milestone_id)
);


ALTER TABLE project
    ADD CONSTRAINT fk_company
        FOREIGN KEY (company_id) REFERENCES company (company_id);

ALTER TABLE employee_project
    ADD CONSTRAINT fk_employee
        FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    ADD CONSTRAINT fk_project
        FOREIGN KEY (project_id) REFERENCES project (project_id),
    ADD CONSTRAINT fk_project_role
        FOREIGN KEY (project_role_id) REFERENCES project_role (project_role_id);

ALTER TABLE employee_task
    ADD CONSTRAINT fk_employee
        FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    ADD CONSTRAINT fk_task
        FOREIGN KEY (task_id) REFERENCES task (task_id);

ALTER TABLE tracking
    ADD CONSTRAINT fk_employee
        FOREIGN KEY (employee_id) REFERENCES employee (employee_id),
    ADD CONSTRAINT fk_task
        FOREIGN KEY (task_id) REFERENCES task (task_id);

ALTER TABLE company_contact
    ADD CONSTRAINT fk_company
        FOREIGN KEY (company_id) REFERENCES company (company_id);

ALTER TABLE task
    ADD CONSTRAINT fk_project
        FOREIGN KEY (project_id) REFERENCES project (project_id);

ALTER TABLE milestone
    ADD CONSTRAINT fk_project
        FOREIGN KEY (project_id) REFERENCES project (project_id);
