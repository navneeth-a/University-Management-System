# University Management System - SQL Project

## Overview

A relational database project for managing university operations including students, faculty, courses, fees, library, transport, and placements. Built using MySQL and designed to demonstrate real-world database concepts from basic queries to advanced.

## Features

* Manage student information
* Maintain faculty records
* Handle departments and courses
* Track enrollments and academic activities
* Monitor fee payments, dues, and overdue status for each student
* Manage hostel allocation and room details for resident students
* Maintain library records including book issue, return, and fine calculation
* Handle transport routes and student subscriptions
* Track placements, alumni records, and career progression
* Manage scholarships and student applications
* Organize clubs, events, and student participation
* Record and resolve student complaints and grievances

## Database Schema

* The database consists of 23 tables grouped into the following categories:
* Academics - departments, faculty, courses, students, enrollments, exams, grades, attendance
* Administrative - fees, hostels, library, staff, complaints
* Career & Records - alumni, placements, scholarships, scholarship_applications
* Extracurricular - clubs, club_members, events, event_registrations
* Transport - transport, transport_subscriptions

## Concepts

* Basic SQL - SELECT, WHERE, INSERT, UPDATE, DELETE, LIKE, BETWEEN
* Advanced SQL - Subqueries, GROUP BY, HAVING, Aggregate Functions
* Joins - INNER JOIN, LEFT JOIN, RIGHT JOIN, SELF JOIN, UNION, UNION ALL
* Window Functions - RANK, DENSE_RANK, ROW_NUMBER, LAG, LEAD, NTILE, PARTITION BY
* Stored Procedures - IN/OUT parameters, CURSOR, LOOP, IF-ELSE, SIGNAL
* Control Flow - CASE WHEN, IF(), IFNULL(), NULLIF()
* Triggers - BEFORE/AFTER INSERT, UPDATE, DELETE
* Events - Scheduled tasks with CREATE EVENT

## Technologies Used

* SQL
* MySQL Workbench
* GitHub

## Files Included

* Tables.sql
* Queries.sql
* README.md

## How to Run

1. Open MySQL Workbench and Create a new database.
2. Execute the Tables.sql script.
3. Insert datas from Tables.sql.
4. Run queries from Queries.sql.
