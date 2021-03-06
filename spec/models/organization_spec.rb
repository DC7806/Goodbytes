require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'association' do
    it { should have_many(:users).through(:organizations_users) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
  end

  describe 'column_specification' do
    it { should have_db_column(:name).of_type(:string).with_options(length: { minimum: 1, maximum: 100 }) }
  end
end
