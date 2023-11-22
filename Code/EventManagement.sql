CREATE DATABASE EventManagement;

USE EventManagement;

-- Venue Table
CREATE TABLE Venue (
    VenueID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Capacity INT
);

-- Organizer Table
CREATE TABLE Organizer (
    OrganizerID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20)
);

-- Attendee Table
CREATE TABLE Attendee (
    AttendeeID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20)
);

-- Event Table
CREATE TABLE Event (
    EventID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Date DATE NOT NULL,
    Time TIME,
    VenueID INT,
    OrganizerID INT
);

-- Ticket Table
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY,
    EventID INT,
    Price DECIMAL(10, 2) NOT NULL,
    AvailableQuantity INT NOT NULL,
    CONSTRAINT fk_event FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

-- Order Table
CREATE TABLE EventOrder (
    OrderID INT PRIMARY KEY,
    AttendeeID INT,
    EventID INT,
    OrderDate DATE NOT NULL,
    CONSTRAINT fk_attendee FOREIGN KEY (AttendeeID) REFERENCES Attendee(AttendeeID),
    CONSTRAINT fk_event_order FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

-- Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    AttendeeID INT,
    EventID INT,
    Comment TEXT,
    Rating INT,
    FeedbackDate DATE NOT NULL,
    CONSTRAINT fk_attendee_feedback FOREIGN KEY (AttendeeID) REFERENCES Attendee(AttendeeID)
);

ALTER TABLE Feedback
ADD CONSTRAINT fk_event_feedback
FOREIGN KEY (EventID) REFERENCES Event(EventID);


-- Create a new table for Event-Venue relationships
CREATE TABLE EventVenue (
    EventID INT PRIMARY KEY,
    VenueID INT,
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID)
);

-- Create a new table for Event-Organizer relationships
CREATE TABLE EventOrganizer (
    EventID INT PRIMARY KEY,
    OrganizerID INT,
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (OrganizerID) REFERENCES Organizer(OrganizerID)
);

DROP TABLE EventOrganizer;
DROP TABLE EventVenue;

-- DML COMMANDS

-- Venue data
INSERT INTO Venue (VenueID, Name, Address, Capacity)
VALUES (1, 'Shanti Devi Mittal Auditorium', 'Block 35', 3000);

INSERT INTO Venue (VenueID, Name, Address, Capacity)
VALUES (2, 'Uni Polis', 'Block 14', 5000);

INSERT INTO Venue (VenueID, Name, Address, Capacity)
VALUES (3, 'DSW Stage', 'Block 13', 200);

-- Organizer data
INSERT INTO Organizer (OrganizerID, Name, Email, Phone)
VALUES (1, 'Oasis', 'oasis.lpu@gmail.com', '1234567890');

INSERT INTO Organizer (OrganizerID, Name, Email, Phone)
VALUES (2, 'PentaOmnia', 'pentaomnia.lpu@gmail.com', '9876543210');

INSERT INTO Organizer (OrganizerID, Name, Email, Phone)
VALUES (3, 'Eventicia', 'eventicia.lpu@gmail.com', '9876501234');

-- Attendee data
INSERT INTO Attendee (AttendeeID, Name, Email, Phone)
VALUES (1, 'Chandan SM', 'chandan@example.com', '8311321987');

INSERT INTO Attendee (AttendeeID, Name, Email, Phone)
VALUES (2, 'Virat', 'virat@example.com', '8937438442');

-- Event data
INSERT INTO Event (EventID, Title, Description, Date, Time, VenueID, OrganizerID)
VALUES (1, 'Music Festival', 'A weekend of live music', '2023-06-15', '18:00:00', 2, 1);

INSERT INTO Event (EventID, Title, Description, Date, Time, VenueID, OrganizerID)
VALUES (2, 'Tech Conference', 'Cutting-edge tech talks', '2023-09-20', '09:00:00', 1, 2);

INSERT INTO Event (EventID, Title, Description, Date, Time, VenueID, OrganizerID)
VALUES (3, 'ISKCON Visit', 'Spitural Visit to Iskcon Ludhiana', '2023-09-25', '09:00:00', 3, 3);

SELECT * FROM Venue;

SELECT * FROM Event WHERE OrganizerID = 1;

UPDATE Venue SET Capacity = 3500 WHERE VenueID = 1;

SELECT * FROM Attendee WHERE AttendeeID = 1;

UPDATE Attendee SET Email = 'chandan1012004@gmail.com' WHERE AttendeeID = 1;

SELECT * FROM Event;

DELETE FROM Event WHERE EventID = 2;

DELETE FROM Attendee WHERE AttendeeID = 1;

-- Role Based Access Control

CREATE USER 'user1'@'%' IDENTIFIED BY 'user1@123';
CREATE USER 'user2'@'%' IDENTIFIED BY 'user2@123';
CREATE USER 'user3'@'%' IDENTIFIED BY 'user3@123';

-- Create roles
CREATE ROLE admin;
CREATE ROLE event_organizer;
CREATE ROLE attendee;

-- Grant all privileges on all tables to the admin role
GRANT ALL PRIVILEGES ON your_database.* TO admin;

-- Grant privileges to roles for Venue table
GRANT SELECT, INSERT, UPDATE, DELETE ON Venue TO event_organizer;
GRANT SELECT ON Venue TO attendee;

-- Grant privileges to roles for Organizer table
GRANT SELECT, INSERT, UPDATE, DELETE ON Organizer TO event_organizer;

-- Grant privileges to roles for Attendee table
GRANT SELECT, INSERT, UPDATE, DELETE ON Attendee TO event_organizer;

-- Grant privileges to roles for Event table
GRANT SELECT, INSERT, UPDATE, DELETE ON Event TO event_organizer;

-- Grant privileges to roles for Ticket table
GRANT SELECT, INSERT, UPDATE ON Ticket TO event_organizer;

-- Grant privileges to roles for Feedback table
GRANT SELECT, INSERT ON Feedback TO event_organizer;

-- Assigning users to roles
GRANT event_organizer TO user1;
GRANT attendee TO user2;
GRANT admin TO user3;

-- INNER JOIN
SELECT Event.Title, Venue.Name
FROM Event
INNER JOIN Venue ON Event.VenueID = Venue.VenueID;

-- LEFT JOIN
SELECT Event.Title, COALESCE(Venue.Name, 'N/A') AS VenueName
FROM Event
LEFT JOIN Venue ON Event.VenueID = Venue.VenueID;

-- Subquery in WHERE clause
SELECT *
FROM Event
WHERE VenueID IN (
    SELECT VenueID
    FROM Venue
    WHERE Capacity > 1000
);

-- Subquery in SELECT clause
SELECT Event.Title,
    (SELECT COUNT(*) 
     FROM Feedback 
     WHERE Feedback.EventID = Event.EventID) AS TotalFeedback
FROM Event;

-- Drop DATABASE EventManagement;