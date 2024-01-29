---------------------------------------------------------------
-- Создание базы данных
---------------------------------------------------------------

CREATE DATABASE pets_database;
\c pets_database

---------------------------------------------------------------
-- Создание таблиц и primary key (PK)
---------------------------------------------------------------

CREATE TABLE Person
(
    Person_ID  INTEGER     NOT NULL,
    Last_Name  VARCHAR(20) NOT NULL,
    First_Name VARCHAR(20) NOT NULL,
    Phone      VARCHAR(15) NOT NULL,
    Address    VARCHAR(50) NOT NULL,
    CONSTRAINT Person_PK PRIMARY KEY (Person_ID)
)
;
CREATE TABLE Owner
(
    Owner_ID    INTEGER NOT NULL,
    Description VARCHAR(50),
    Person_ID   INTEGER NOT NULL,
    CONSTRAINT Owner_PK PRIMARY KEY (Owner_ID)
)
;
CREATE TABLE Employee
(
    Employee_ID INTEGER NOT NULL,
    Spec        VARCHAR(15),
    Person_ID   INTEGER NOT NULL,
    CONSTRAINT Employee_PK PRIMARY KEY (Employee_ID)
)
;
CREATE TABLE Pet_Type
(
    Pet_Type_ID INTEGER     NOT NULL,
    Name        VARCHAR(15) NOT NULL,
    CONSTRAINT Pet_Type_PK PRIMARY KEY (Pet_Type_ID)
)
;
CREATE TABLE Pet
(
    Pet_ID      INTEGER NOT NULL,
    Nick        VARCHAR(15),
    Breed       VARCHAR(20),
    Age         INTEGER,
    Description VARCHAR(50),
    Pet_Type_ID INTEGER NOT NULL,
    Owner_ID    INTEGER NOT NULL,
    CONSTRAINT Pet_PK PRIMARY KEY (Pet_ID)
)
;
CREATE TABLE Service
(
    Service_ID INTEGER     NOT NULL,
    Name       VARCHAR(15) NOT NULL,
    CONSTRAINT Service_PK PRIMARY KEY (Service_ID)
)
;
CREATE TABLE Employee_Service
(
    Employee_ID INTEGER NOT NULL,
    Service_ID  INTEGER NOT NULL,
    Is_Basic    INTEGER
)
;
CREATE TABLE Order1
(
    Order_ID    INTEGER                        NOT NULL,
    Owner_ID    INTEGER                        NOT NULL,
    Service_ID  INTEGER                        NOT NULL,
    Pet_ID      INTEGER                        NOT NULL,
    Employee_ID INTEGER                        NOT NULL,
    Time_Order  TIMESTAMP DEFAULT CURRENT_DATE NOT NULL,
    Is_Done     INTEGER   DEFAULT 0            NOT NULL,
    Mark        INTEGER,
    Comments    VARCHAR(50),
    CONSTRAINT Order_Is_Done CHECK (Is_Done in (0, 1)),
    CONSTRAINT Order_PK PRIMARY KEY (Order_ID)
)
;
CREATE TABLE Vaccination_Type
(
    Type_ID INTEGER     NOT NULL,
    Name    VARCHAR(50) NOT NULL,
    CONSTRAINT Vaccination_Type_PK PRIMARY KEY (Type_ID)
)
;
CREATE TABLE Vaccination
(
    Vaccination_ID INTEGER                        NOT NULL,
    Date           TIMESTAMP DEFAULT CURRENT_DATE NOT NULL,
    Document       VARCHAR(50)                    NOT NULL,
    Type_ID        INTEGER,
    Pet_ID         INTEGER,
    CONSTRAINT Vaccination_PK PRIMARY KEY (Vaccination_ID)
)
;

---------------------------------------------------------------
-- Создание foreign key (FK)
---------------------------------------------------------------

ALTER TABLE Owner
    ADD CONSTRAINT FK_Owner_Person
        FOREIGN KEY (Person_ID)
            REFERENCES Person (Person_ID)
;
ALTER TABLE Employee
    ADD CONSTRAINT FK_Employee_Person
        FOREIGN KEY (Person_ID)
            REFERENCES Person (Person_ID)
;
ALTER TABLE Pet
    ADD CONSTRAINT FK_Pet_Owner
        FOREIGN KEY (Owner_ID)
            REFERENCES Owner (Owner_ID)
;
ALTER TABLE Pet
    ADD CONSTRAINT FK_Pet_Type
        FOREIGN KEY (Pet_Type_ID)
            REFERENCES Pet_Type (Pet_Type_ID)
;
ALTER TABLE Employee_Service
    ADD CONSTRAINT FK_Empl_Serv_Employee
        FOREIGN KEY (Employee_ID)
            REFERENCES Employee (Employee_ID)
;
ALTER TABLE Employee_Service
    ADD CONSTRAINT FK_Empl_Serv_Service
        FOREIGN KEY (Service_ID)
            REFERENCES Service (Service_ID)
;
ALTER TABLE Order1
    ADD CONSTRAINT FK_Order_Employee
        FOREIGN KEY (Employee_ID)
            REFERENCES Employee (Employee_ID)
;
ALTER TABLE Order1
    ADD CONSTRAINT FK_Order_Owner
        FOREIGN KEY (Owner_ID)
            REFERENCES Owner (Owner_ID)
;
ALTER TABLE Order1
    ADD CONSTRAINT FK_Order_Pet
        FOREIGN KEY (Pet_ID)
            REFERENCES Pet (Pet_ID)
;
ALTER TABLE Order1
    ADD CONSTRAINT FK_Order_Service
        FOREIGN KEY (Service_ID)
            REFERENCES Service (Service_ID)
;
ALTER TABLE Vaccination
    ADD CONSTRAINT FK_Vaccination_Type
        FOREIGN KEY (Type_ID)
            REFERENCES Vaccination_Type (Type_ID)
;
ALTER TABLE Vaccination
    ADD CONSTRAINT FK_Vaccination_Pet
        FOREIGN KEY (Pet_ID)
            REFERENCES Pet (Pet_ID)
;

---------------------------------------------------------------
-- Заполнение таблиц данными
---------------------------------------------------------------

INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (1, 'Ivanov', 'Vania', '+79123456789', 'Srednii pr VO, 34-2')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (2, 'Petrov', 'Petia', '+79234567890', 'Sadovaia ul, 17\2-23')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (3, 'Vasiliev', 'Vasia', '+7345678901', 'Nevskii pr, 9-11')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (4, 'Orlov', 'Oleg', '+7456789012', '5 linia VO, 45-8')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (5, 'Galkina', 'Galia', '+7567890123', '10 linia VO, 35-26')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (6, 'Sokolov', 'S.', '+7678901234', 'Srednii pr VO, 27-1')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (7, 'Vorobiev', 'Vova', '123-45-67', 'Universitetskaia nab, 17')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (8, 'Ivanov', 'Vano', '+7789012345', 'Malyi pr VO, 33-2')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (9, 'Sokolova', 'Sveta', '234-56-78', '')
;
INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES (10, 'Zotov', 'Misha', '111-56-22', '')
;

INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (1, 'Good boy', 4)
;
INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (2, '', 5)
;
INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (3, '', 6)
;
INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (4, 'From the Arts Academy', 7)
;
INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (5, '', 8)
;
INSERT INTO Owner(Owner_ID, Description, Person_ID)
VALUES (6, 'Mean', 9)
;

INSERT INTO Employee(Employee_ID, Spec, Person_ID)
VALUES (1, 'Boss', 1)
;
INSERT INTO Employee(Employee_ID, Spec, Person_ID)
VALUES (2, 'Hairdresser', 2)
;
INSERT INTO Employee(Employee_ID, Spec, Person_ID)
VALUES (3, 'Student', 3)
;
INSERT INTO Employee(Employee_ID, Spec, Person_ID)
VALUES (4, 'Student', 10)
;

INSERT INTO Pet_Type(Pet_Type_ID, Name)
VALUES (1, 'Dog')
;
INSERT INTO Pet_Type(Pet_Type_ID, Name)
VALUES (2, 'Cat')
;
INSERT INTO Pet_Type(Pet_Type_ID, Name)
VALUES (3, 'Cow')
;
INSERT INTO Pet_Type(Pet_Type_ID, Name)
VALUES (4, 'Fish')
;

INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (1, 'Bobik', 'Unknown', 3, NULL, 1, 1)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (2, 'Musia', NULL, 12, NULL, 2, 1)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (3, 'Katok', NULL, 2, 'Crazy guy', 2, 1)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (4, 'Apelsin', 'Poodle', 5, NULL, 1, 2)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (5, 'Partizan', 'Siamese', 5, 'Very big', 2, 2)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (6, 'Daniel', 'Spaniel', 14, NULL, 1, 3)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (7, 'Model', NULL, 5, NULL, 3, 4)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (8, 'Markiz', 'Poodle', 1, NULL, 1, 5)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (9, 'Zombi', 'Unknown', 7, 'Wild', 2, 6)
;
INSERT INTO Pet(Pet_ID, Nick, Breed, Age, Description, Pet_Type_ID, Owner_ID)
VALUES (10, 'Las', 'Siamese', 7, '', 2, 6)
;

INSERT INTO Service(Service_ID, Name)
VALUES (1, 'Walking')
;
INSERT INTO Service(Service_ID, Name)
VALUES (2, 'Combing')
;
INSERT INTO Service(Service_ID, Name)
VALUES (3, 'Milking')
;

INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (1, 1, 0)
;
INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (1, 2, 0)
;
INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (1, 3, 1)
;
INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (2, 1, 0)
;
INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (2, 2, 1)
;
INSERT INTO Employee_Service(Employee_ID, Service_ID, Is_Basic)
VALUES (3, 1, 1)
;

INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (1, 1, 1, 1, 3, '2020-09-04 08:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (2, 1, 2, 2, 2, '2020-09-04 09:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (3, 1, 2, 3, 2, '2020-09-04 09:00', 0, 0, 'That cat is crazy!')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (4, 1, 1, 1, 3, '2020-09-05 00:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (5, 1, 1, 1, 3, '2020-09-06 11:00', 1, 3, 'Coming late')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (6, 1, 1, 1, 3, '2020-09-07 17:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (7, 1, 2, 2, 2, '2020-09-07 18:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (8, 2, 1, 5, 3, '2020-09-07 18:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (9, 2, 1, 4, 3, '2020-09-07 10:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (10, 2, 1, 5, 3, '2020-09-08 17:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (11, 2, 1, 4, 3, '2020-09-08 18:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (12, 2, 1, 5, 3, '2020-09-08 12:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (13, 2, 1, 4, 3, '2020-09-08 14:00', 1, 4, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (14, 3, 1, 6, 3, '2020-09-09 10:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (15, 3, 2, 6, 2, '2020-09-09 18:00', 0, 0, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (16, 3, 1, 6, 3, '2020-09-10 10:00', 0, 0, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (17, 3, 1, 6, 3, '2020-09-10 11:00', 0, 0, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (18, 3, 1, 6, 3, '2020-09-12 10:00', 0, 0, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (19, 3, 1, 6, 3, '2020-09-13 10:00', 0, 0, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark, Comments)
VALUES (20, 4, 3, 7, 1, '2020-09-10 11:00', 1, 5, '')
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark)
VALUES (21, 4, 3, 7, 1, '2020-09-11 11:00', 0, 0)
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark)
VALUES (22, 4, 3, 7, 1, '2020-09-12 11:00', 0, 0)
;
INSERT INTO Order1(Order_ID, Owner_ID, Service_ID, Pet_ID, Employee_ID, Time_Order, Is_Done, Mark)
VALUES (23, 5, 2, 8, 2, '2020-09-10 16:00', 0, 0)
;

INSERT INTO Vaccination_Type(Type_ID, Name)
VALUES (1, 'Rabies')
;
INSERT INTO Vaccination_Type(Type_ID, Name)
VALUES (2, 'Plague')
;

INSERT INTO Vaccination(Vaccination_ID, Date, Document, Type_ID, Pet_ID)
VALUES (0, '2020-09-05 00:00', 'Musia.pdf', 1, 2)
;
INSERT INTO Vaccination(Vaccination_ID, Date, Document, Type_ID, Pet_ID)
VALUES (1, '2020-09-23 00:00', 'Musia2.pdf', 2, 2)
;
INSERT INTO Vaccination(Vaccination_ID, Date, Document, Type_ID, Pet_ID)
VALUES (2, '2020-10-15 00:00', 'Daniel.pdf', 2, 6)
;
INSERT INTO Vaccination(Vaccination_ID, Date, Document, Type_ID, Pet_ID)
VALUES (3, '2020-02-01 00:00', 'Bobik.pdf', 1, 1)
;
INSERT INTO Vaccination(Vaccination_ID, Date, Document, Type_ID, Pet_ID)
VALUES (4, '2020-01-02 00:00', 'Daniel2.pdf', 1, 6)
;

---------------------------------------------------------------
-- Запросы к базе данных
---------------------------------------------------------------

SELECT *
FROM Pet
WHERE Nick = 'Partizan'
;
SELECT Nick, Breed
FROM Pet
ORDER BY Age
;
SELECT *
FROM Pet
WHERE Description IS NOT NULL
  AND Description != ''
;
SELECT avg(Age)
FROM Pet
WHERE Breed = 'Poodle'
;
SELECT count(DISTINCT Owner_ID)
FROM Pet
;

---------------------------------------------------------------
-- Объединение баз данных
---------------------------------------------------------------

SELECT Pet.Nick,
       Pet_Type.Name
FROM Pet
         JOIN Pet_Type on Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
WHERE Pet.Nick = 'Partizan'
;
SELECT Pet.Nick, Pet.Breed, Pet.Age
FROM Pet,
     Pet_Type
WHERE Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
  AND Pet_Type.Name = 'Dog'
  AND Pet.Breed IS NOT NULL
  AND Pet.Age IS NOT NULL
  AND Nick IS NOT NULL
;
SELECT AVG(Pet.Age)
FROM Pet
         JOIN Pet_Type on Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
WHERE Pet.Age IS NOT NULL
  AND Pet_Type.Name = 'Cat'
;
SELECT Order1.Time_Order, Person.Last_Name
FROM Order1
         JOIN Employee on Order1.Employee_ID = Employee.Employee_ID
         JOIN Person on Employee.Person_ID = Person.Person_ID
WHERE Order1.Is_Done = 0
;
SELECT Person.First_Name, Person.Last_Name, Person.Phone
FROM Pet
         JOIN Owner ON Pet.Owner_ID = Owner.Owner_ID
         JOIN Person ON Owner.Person_ID = Person.Person_ID
         JOIN Pet_Type on Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
WHERE Pet_Type.Name = 'Dog'
;
SELECT Pet_Type.Name, Pet.Nick
FROM Pet_Type
         Left JOIN Pet ON Pet_Type.Pet_Type_ID = Pet.Pet_Type_ID
;

---------------------------------------------------------------
-- Гриппировка и сортировка таблиц
---------------------------------------------------------------

SELECT Age, count(*)
FROM Pet
GROUP BY Age
ORDER BY Age
;
SELECT Pet.Age, Pet_Type.Name, count(*)
FROM Pet
         JOIN Pet_Type ON Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
GROUP BY Pet.Age, Pet_Type.Name
ORDER BY Pet.Age
;
SELECT Pet_Type.Name, AVG(Pet.Age)
FROM Pet
         JOIN Pet_Type ON Pet.Pet_Type_ID = Pet_Type.Pet_Type_ID
GROUP BY Pet_Type.Name
HAVING AVG(Pet.Age) < 6
;
SELECT Person.Last_Name, sum(Order1.Is_Done)
FROM Order1
         join Employee on Order1.Employee_ID = Employee.Employee_ID
         join Person on Employee.Person_ID = Person.Person_ID
GROUP BY Person.Last_Name
HAVING sum(Order1.Is_Done) > 5
;

-- Фамилии работников, получивших заказ после полудня и выполневших его с положительной оценкой
SELECT Person.Last_Name, count(*)
FROM Order1
         join Employee on Order1.Employee_ID = Employee.Employee_ID
         join Person on Employee.Person_ID = Person.Person_ID
WHERE extract(hour from Time_Order) > 12
  AND Order1.Mark > 3
GROUP BY Person.Person_ID, Person.Last_Name
ORDER BY Person.Person_ID
;

-- Фамилии заказчиков и первая буква их имени, поставивших положительную оценку
SELECT Person.Last_Name, left(Person.First_Name, 1)
FROM Order1
         join Owner on Order1.Owner_ID = Owner.Owner_ID
         join Person on Owner.Person_ID = Person.Person_ID
WHERE Order1.Mark > 3
GROUP BY Person.Person_ID, Person.Last_Name, left(Person.First_Name, 1)
ORDER BY Person.Person_ID
;

---------------------------------------------------------------
-- Сложные запросы
---------------------------------------------------------------

SELECT Order1.Mark
FROM Order1
WHERE Order1.Employee_ID IN (SELECT Employee.Employee_ID FROM Employee WHERE Employee.Spec = 'Student')
  AND Order1.Is_Done = 1
;

SELECT Person.Last_Name
FROM Person
WHERE Person.Person_ID IN (SELECT Employee.Person_ID
                           FROM Employee
                           WHERE Employee.Employee_ID NOT IN (SELECT Order1.Employee_ID FROM Order1))
;

SELECT S.Name, Order1.Time_Order, Emp.Last_Name, P.Nick, Own.Last_Name
FROM Order1
         JOIN Service S on Order1.Service_ID = S.Service_ID
         JOIN Employee E ON Order1.Employee_ID = E.Employee_ID
         JOIN Person Emp ON E.Person_ID = Emp.Person_ID
         JOIN Pet P On Order1.Pet_ID = P.Pet_ID
         JOIN Owner O on Order1.Owner_ID = O.Owner_ID
         JOIN Person Own ON O.Person_ID = Own.Person_ID
;


SELECT O.Comments
FROM Order1 O
where O.Comments != ''
UNION ALL
SELECT P.Description
FROM Pet P
where P.Description != ''
UNION ALL
SELECT Ow.Description
FROM Owner Ow
where Ow.Description != ''
ORDER BY Comments
;


SELECT P.First_Name, P.Last_Name
FROM Person P
         JOIN Employee E on P.Person_ID = E.Person_ID
WHERE EXISTS(SELECT O.Employee_ID
             FROM Order1 O
             WHERE O.Mark = 5
               and O.Employee_ID = E.Employee_ID)
;

---------------------------------------------------------------
-- Обновление таблиц
---------------------------------------------------------------

INSERT INTO Person(Person_ID, Last_Name, First_Name, Phone, Address)
VALUES ((SELECT MAX(Person_ID) FROM Person) + 1, 'Kuznetsov', 'Ilya', '+79281777005', 'Botanicheskaya st., 64')
;
SELECT *
FROM Person
;

UPDATE Order1
SET Comments = '(s)' || (Order1.Comments)
WHERE Order_ID IN (SELECT O.Order_ID
                   FROM Order1 O
                            JOIN Employee E ON O.Employee_ID = E.Employee_ID
                   WHERE E.Spec = 'Student')
;
SELECT Comments
FROM Order1
;

CREATE TABLE Document
(
    document_id   INTEGER     NOT NULL,
    person_id     INTEGER     NOT NULL,
    document_type varchar(64) NOT NULL DEFAULT 'Unknown',
    CONSTRAINT document_PK PRIMARY KEY (document_id)
);
ALTER TABLE Document
    ADD CONSTRAINT document_FK FOREIGN KEY (person_id) REFERENCES Person (Person_ID) ON DELETE CASCADE
;
INSERT INTO Document(document_id, person_id, document_type)
VALUES (1, (SELECT P.person_id FROM Person P WHERE P.last_name = 'Kuznetsov'),
        'Driving License')
;
INSERT INTO Document(document_id, person_id, document_type)
VALUES ((SELECT MAX(D.document_id) + 1 FROM Document D),
        (SELECT P.person_id FROM Person P WHERE P.last_name = 'Kuznetsov'),
        'Passport')
;
SELECT *
FROM Document
;
DELETE
FROM Person P
WHERE P.last_name = 'Kuznetsov'
;


---------------------------------------------------------------
-- Другие объекты БД
---------------------------------------------------------------

CREATE VIEW V_dogs AS
SELECT Pet.nick, Pet.Breed, Pet.Age, P.Last_Name, P.First_Name
FROM Pet
         JOIN Owner O on Pet.Owner_ID = O.Owner_ID
         JOIN person P on O.Person_ID = P.person_id
         JOIN Pet_Type PT on Pet.Pet_Type_ID = PT.Pet_Type_ID
WHERE PT.Name = 'Dog'
;
SELECT Nick, Last_Name
FROM V_dogs
WHERE Breed = 'Poodle'
;

CREATE VIEW V_employee_rate(last_name, first_name, orders_count, avg_mark)
AS
SELECT P.Last_Name, P.First_Name, COUNT(E.Person_ID), AVG(O.Mark)
FROM Person P
         JOIN Employee E on P.Person_ID = E.Person_ID
         JOIN Order1 O on E.Employee_ID = O.Employee_ID
WHERE O.Is_Done = 1
GROUP BY P.Last_Name, P.First_Name
;
SELECT *
FROM V_employee_rate
ORDER BY avg_mark DESC
;

CREATE VIEW V_customer(customer_id, last_name, first_name, phone, address)
AS
SELECT P.Person_ID, P.Last_Name, P.First_Name, P.Phone, P.Address
FROM Person P
         JOIN Owner O on P.Person_ID = O.Person_ID
;
UPDATE Person
SET Address = Address || '?'
WHERE Person_ID IN (SELECT customer_id FROM V_customer WHERE V_customer.address = '' OR V_customer.address IS NULL)
;
SELECT *
FROM V_customer
ORDER BY customer_id
;

---------------------------------------------------------------
-- Удаление таблиц (при необходимости)
---------------------------------------------------------------

-- DROP TABLE Vaccination
-- ;
-- DROP TABLE Vaccination_Type
-- ;
-- DROP TABLE Order1
-- ;
-- DROP TABLE Employee_Service
-- ;
-- DROP TABLE Service
-- ;
-- DROP TABLE Pet
-- ;
-- DROP TABLE Pet_Type
-- ;
-- DROP TABLE Employee
-- ;
-- DROP TABLE Owner
-- ;
-- DROP TABLE Person CASCADE
-- ;
-- DROP TABLE document
-- ;
