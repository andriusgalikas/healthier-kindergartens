# == Schema Information
#
# Table name: department_todos
#
#  id            :integer          not null, primary key
#  todo_id       :integer
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe DepartmentTodo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
