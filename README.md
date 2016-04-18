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

# Database

## Todo data

### Todo
title:string  
iteration_type:integer(enum)(single,recurring) default (0)  
frequency:integer(enum)(day,week,month,year) default (0)  
daycare_id:integer  
department_id:integer
user_id:integer  

has_many :tasks, class_name: 'TodoTask'  
has_one :todo_subject
has_one :subject, through: :todo_subject
belongs_to :daycare  
belongs_to :deparment
belongs_to :user  

### TodoTask
title:string  
description:text  
todo_id:integer  

belongs_to :todo  

### TodoComplete
submitter_id:integer
todo_id:integer
completion_date:datetime
status:integer(enum)(active,inactive)

has_many :tasks_complete, class_name: 'TodoTaskComplete'
belongs_to :submitter
belongs_to :todo

### TodoTaskComplete
submitter_id:integer
todo_complete_id:integer  
todo_task_id:integer
completion_date:datetime  
result:integer(enum)(pass,failed)

belongs_to :submitter
belongs_to :todo_complete
belongs_to :todo_task

## Payment data

### Plan
name:string  
price:decimal   
allocation:integer  

has_many :subscriptions  
has_many :users, through: :subscriptions  

### Subscription
plan_id:integer  
user_id:integer  

belongs_to :plan  
belongs_to :user  

### DiscountCode
code:string  
value:decimal default(0.0)  
status:integer(enum)(active,disabled) default(0)  

has_many :discount_code_users, dependent: :restrict_with_exception  
has_many :users, through: :discount_code_users  

### DiscountCodeUser
user_id:integer   
discount_code_id:integer  

belongs_to :discount_code   
belongs_to :user  

## Daycare data

### Department
name:string  
daycare_id:integer  

belongs_to :daycare  

### DepartmentTodo
todo_id:integer  
department_id:integer  

belongs_to :todo  
belongs_to :department  

### Daycare
name:string  
address_line1:string  
post_code:string  
country:string  
telephone:string  

has_many :departments   
has_many :managers   
has_many :workers   
has_many :parents  

### Child
name:string  
parent_id:integer  
department_id:integer   
birth_date:datetime  

belongs_to :parent, class_name: 'User'   
belongs_to :department  

## User data

### User
role:integer(enum)(parent,worker,manager,admin) default(0)   
name:string  
daycare_id:integer   
stripe_customer_token:string  

has_many :todos   
has_many :completed_todos   
has_one :subscription   
has_one :plan, through: :subscription   
belongs_to :daycare   
has_one :discount_code_user   
has_one :discount_code, through: :discount_code_user  

### UserOccurrence  
user_id:integer  
todo_id:integer  
status:integer(enum)(active,inactive) default(0)  

belongs_to :user  
belongs_to :todo    

### UserDaycare  
user_id:integer  
daycare_id:integer  

belongs_to :user  
belongs_to :daycare  


# User stories

## Todo

As an admin...  
- I need to view all global todos  
- I need to view all local todos per daycare  
- I need to be able to create global todos   


As a manager...  
- I need to view all global todos   
- I need to view all local todos in related to my daycare  
- I need to be able to create new local todos  

As a worker or parent...  
- I need to be able to view incomplete todos...  
- I need to be able to view complete todos...  
- I need to be able to view available todos for my associated daycare...    
