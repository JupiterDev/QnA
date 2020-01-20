require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:comments) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#already_voted?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.vote_up(another_user) }

    it 'user already voted the resource' do
      expect(another_user).to be_already_voted(question.id)
    end

    it 'user has not voted the resource' do
      expect(user).to_not be_already_voted(question.id)
    end
  end
end
