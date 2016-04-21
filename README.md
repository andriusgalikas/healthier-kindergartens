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

## Todo

The Todo logic is broken up into two types: Local and Global. Global Todos are created by an admin, and only an admin can create, edit and destroy. Managers can view 


# User stories

## Todo

As an admin I can...  
- view all global todos  
- create global todos   

As a manager I can...  
- view all global todos   
- generate report on global and local todos
- iew all local todos in relation to my daycare  
- create local todos which are assigned to my daycare

As a worker or parent I can...  
- can view available todos...
- can view incomplete todos...  
- 
