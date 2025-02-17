#!/bin/sh
sqlplus64 "d1yeung/06145080@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.cs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF


CREATE TABLE Equipment_Type (
    Equipment_Type_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Equipment_Type_Name  VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Customer (
    Customer_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Staff (
    Staff_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL
);

CREATE TABLE Equipment (
    Equipment_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Equipment_Type_ID INT NOT NULL,
    Status VARCHAR(50) DEFAULT 'Available' CHECK (Rental_Status IN ('Available', 'Under Maintenance', 'Out of Service')),
    Condition VARCHAR(100) NOT NULL,
    Purchase_Date DATE NOT NULL,
    Equipment_Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Equipment_Type_ID) REFERENCES Equipment_Type(Equipment_Type_ID)
);

CREATE TABLE Customer_Phone (
    Phone_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Customer_ID INT,
    Customer_Phone_Number VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT fk_customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Customer_Email (
    Email_ID INT GENERATED AS IDENTITY PRIMARY KEY, 
    Customer_ID INT,
    Customer_Email VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT fk_customer_email FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) 
);

CREATE TABLE Rental (
    Rental_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Staff_ID INT,
    Customer_ID INT,
    Equipment_ID INT,
    Rental_Date DATE NOT NULL,
    Estimated_Return_Date DATE NOT NULL,
    Estimated_Duration_Days INT,
    Rentail_Price DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(50) DEFAULT 'Ongoing' CHECK (Status IN ('Ongoing', 'Completed', 'Overdue')),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
);

CREATE TABLE Rental_History (
    Rental_History_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Staff_ID INT,
    Customer_ID INT,
    Equipment_ID INT,
    Rental_Date DATE NOT NULL,
    Duration INT,
    Rental_Return DATE NOT NULL,
    Price DECIMAL(10, 2)
);

CREATE TABLE Overdue (
    Overdue_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Rental_ID INT,
    Overdue_Date DATE NOT NULL,
    Amount DECIMAL(10, 2),
    Payment_Method VARCHAR(50),
    Status VARCHAR(50) DEFAULT 'Paid' CHECK (Status IN ('Declined', 'Paid')),
    FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Rental_Customer (
    Rental_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);


CREATE TABLE Payment (
    Payment_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Rental_ID INT,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10, 2),
    Payment_Method VARCHAR(50),
    Status VARCHAR(50) DEFAULT 'Pending' CHECK (Status IN ('Declined', 'Accepted', 'Pending')),
    FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Payment_History (
    Payment_History_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Payment_ID INT NOT NULL,
    Payment_Date DATE NOT NULL,
    Amount DECIMAL(10, 2),
    Payment_Method VARCHAR(50),
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID)
);

CREATE TABLE Payment_Rental_Customer (
    Payment_ID INT PRIMARY KEY,
    Rental_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    FOREIGN KEY (Rental_ID) REFERENCES Rental(Rental_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);



CREATE TABLE Reservation (
    Reservation_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Customer_ID INT,
    Equipment_ID INT,
    Reservation_Date DATE NOT NULL,
    Expiration_Date DATE NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending' CHECK (Status IN ('Confirmed', 'Canceled', 'Pending')),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
);

CREATE TABLE Maintenance (
    Maintenance_ID INT GENERATED AS IDENTITY PRIMARY KEY,
    Staff_ID INT,
    Equipment_ID INT,
    Maintenance_Start_Date DATE NOT NULL,
    Maintenance_Cost DECIMAL(10, 2),
    Expected_Completion_Date DATE,
    Status VARCHAR(50) DEFAULT 'Processing' CHECK (Status IN ('Processing', 'Completed', 'Out of Service')),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (Equipment_ID) REFERENCES Equipment(Equipment_ID)
);

EOF

