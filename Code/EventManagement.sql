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

-- DROP DATABASE EventManagement; 
