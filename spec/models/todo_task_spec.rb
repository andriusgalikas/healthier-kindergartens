# == Schema Information
#
# Table name: todo_tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TodoTask, type: :model do
    
end
