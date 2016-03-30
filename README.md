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


## Database

### Todo data

#### Todo
title:string  
due_date:datetime  
iteration_type:integer(enum)(single,recurring) default (0)  
frequency:integer(enum)(day,week,month,year) default (0)  
daycare_id:integer  
user_id:integer  

has_many :tasks, class_name: 'TodoTask' 
belongs_to :daycare 
belongs_to :user

### TodoTask
title:string 
description:text 
todo_id:integer

belongs_to :todo

### TodoTaskCompletion
submitter_id:integer 
todo_task_id:integer 
daycare_id:integer
completion_date:datetime

has_one :todo_task 
has_one :user, through: :todo_task 
belongs_to :submitter
belongs_to :daycare

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
parent_id:string 
department_id:integer 
birth_year:datetime

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