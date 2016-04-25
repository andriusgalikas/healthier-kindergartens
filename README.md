# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

*   Ruby version

*   System dependencies

*   Configuration

*   Database creation

*   Database initialization

*   How to run the test suite

*   Services (job queues, cache servers, search engines, etc.)

*   Deployment instructions

*   ...

# Getting started

Install gems:  

`bundle install`
  
Install asset dependencies:  

`bower install`

Seed the database

`bundle exec rake db:setup`
  
Start the web server and Sidekiq:   

`foreman start -f Procfile.dev`


# Seed data

## Login details

Admin/Super Admin: admin@daycare.org / mypassword   
Manager: manager@daycare.org / mypassword   
Worker: worker@daycare.org / mypassword   
Parent: parent@daycare.org / mypassword   
  

# Stripe

When testing card authorisation and payments, please use the details in the following link:

https://stripe.com/docs/testing#cards

# Synopsis

## Attachment

The Attachment model is a polymoprhic model which can be utilised by any other model to enable file attachments via the Carrierwave gem.

## Child

The Child model belongs to a User record with the 'parentee' role. A parentee User can create a Child record when the register for an account.

## Daycare

The Daycare model is created when a User record with the 'manger' role is registered on the system. A Daycare record can have multiple Users, Departments and local Todos.

## Department

The Department model belongs to a Daycare record. Department records are created when a User with a 'manager' role is registerd on the system; they need to be unique within the scope of the parent Daycare record.

## DepartmentTodo

The DepartmentTodo is a HABTM relationship handler between the Department and Todo models. A Department can have mutiple Todos, and a Todo can belong to multiple Departments.

## DiscountCode

The DiscountCode model is designed to define available DiscountCodes based around on percentage for the subscription part of the system. When creating a new DiscountCode, it should automtically create and/or update the linked Stripe account with the required information. Stripe needs to hold the DiscountCode information in order to apply the discount to the User's subscription every month. If you cannot find the DiscountCode information in your stripe dashboard, run the following command: 

`rake stripe:prepare`

## DiscountCodeUser

The DiscountCodeUser is a HABTM relationship handler between the DiscountCode and User models. A DiscountCode can have mutiple Users, whereas a User can only have one DiscountCode.

## Plan

The Plan model is designed to define available Plans for when a User would like to upgrade their subscription in the system. When creating a new Plan, it should automtically create and/or update the linked Stripe account with the required information. Stripe needs to hold the Plan information in order to charge the User with the correct amount for each month of their subscription. If you cannot find the Plan information in your stripe dashboard, run the following command: 

`rake stripe:prepare`

## Subject

The Subject model is designed to define a predefined set of subjects for when a User with the 'manager' role creates a new Todo for their associated Daycare. Instead of a User with a 'manager' role submitting custom text for the Title of the Todo, they need to select from a list of predefined Subjects which have been created by a User with an 'admin' role. This has been designed in order support legacy functionality and is advisable to restructure later on.

## SurveySubject
    
The SurveySubject model is designed to define the master subject for a Survey. Since there are mutliple modules (Survey model) in a Survey, it made sense to create a parent record which defined the survey Title, Description and Icon. After creating a SurveySubject record, a User can then create modules containing questions and answers with the Survey model. In order to create SurveySubject or Survey records, a User needs to have an 'admin' role.

## Todo

The Todo logic is broken up into two types: Local and Global. Global Todos are created by an admin, and only an admin can create, edit and destroy. Managers can view global todos, but cannot modify their data. However, a Manager can create local todos, which are only assigned to their associated Daycare. Additionally, a Manager can generate reports based in start and end time/date for both global todo attempts and local todo attempts by their associated parents and managers.

As a Parent or Worker, you can view the global todos created by an admin and local todos created by your manager within your associated Daycare. Furthermore, Parents and Workers can start a Todo and mark its associated tasks as complete.

### User stories

As an admin I can...  
- view all global todos  
- create global todos   

As a manager I can...  
- view all global todos   
- generate report on global and local todos
- iew all local todos in relation to my daycare  
- create local todos which are assigned to my daycare

As a worker or parent I can...  
- view available todos...
- view incomplete todos...  
- mark a tasks on a todo as complete
- complete all tasks on a todo, thereby completing the todo

## TodoComplete

A TodoComplete record is a User's attempt at trying to complete a Todo which is associated with their Daycare. A TodoComplete record has many TodoTaskComplete records - one for each of the TodoTask records associated with a Todo record. When all TodoTaskComplete records are marked as either 'pass' or 'failed' the completion_date attribute is assigned and the status attribute is set to 'inactive'. Only a User record with a 'parentee' or 'worker' role may attempt at completing a Todo.

## TodoTask

A TodoTask record is task associated with a Todo record. A Todo record can have many TodoTask records, each of which contain a Title and Description attribute.

## TodoTaskComplete

A TodoTaskComplete record is a User's attempt at trying to complete TodoTask associated with a Todo record. When a TodoTaskComplete record is created, the result attribute is automatically set to 'pending'. If a User marks a TodoTaskComplete as 'completed', the result attribute is updated to 'pass'. Whereas if a User fails to complete a TodoTaskComplete within the completion date or frequency, the result attrbiute is marked as 'failed'. Only a User record with a 'parentee' or 'worker' role may attempt at completing a TodoTask.

## User

A User record is designed to allow people to create their own account, each of which is assigned either a 'parentee', 'worker', 'manager' and 'admin' role. Each of the aforementioned roles allow the User to perform different types of functionality inside the system. A User record is required in order to utilise alot of the dynamic functionality inside the system.

## UserDaycare

The UserDaycare is a HABTM relationship handler between the Users and Daycares models. A Daycare can have mutiple Users, whereas a User can only have one Daycare.

## UserOccurrence

The UserOccurrence model is designed to prevent Users from repeating a Todo with a 'recurring' iteration type within the defined frequency defined for the aforementioned Todo. For example, if a Todo has a 'recurring' iteration type and a 'weekly' frequency, they cannot perform the Todo more than once a week.