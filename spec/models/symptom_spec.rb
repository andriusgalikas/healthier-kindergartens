# == Schema Information
#
# Table name: symptoms
#
#  id         :integer          not null, primary key
#  illness_id :integer
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Symptom, type: :model do

  describe '#create' do
    it 'should return an error when name is blank' do
      symptom = build(:symptom, name: nil)

      expect(symptom.valid?).to be_falsy
    end

    it 'should return an error when code is blank' do
      symptom = build(:symptom, code: nil)

      expect(symptom.valid?).to be_falsy
    end

    it 'should return an error when illness id is blank' do
      symptom = build(:symptom, illness: nil)

      expect(symptom.valid?).to be_falsy
    end

    it 'should return an error when a code already exists' do
      create(:symptom, code: 'fever')

      expect{ create(:symptom, code: 'fever') }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end
