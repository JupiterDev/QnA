require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: other_question, user: other_user) }
    let(:comment) { create(:comment, user: user, commentable: question) }
    let(:other_comment) { create(:comment, user: other_user, commentable: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Link }
    it { should be_able_to :create, Badge }

    it { should be_able_to :update, question, user: user }
    it { should be_able_to :update, answer, user: user }
    
    it { should_not be_able_to :update, other_question, user: user }
    it { should_not be_able_to :update, other_answer, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should be_able_to :destroy, answer, user: user }
    it { should be_able_to :destroy, comment, user: user }
    
    it { should_not be_able_to :destroy, other_question, user: user }
    it { should_not be_able_to :destroy, other_answer, user: user }
    it { should_not be_able_to :destroy, other_comment, user: user }

    it { should be_able_to :choose_the_best, answer, user: user }
    it { should be_able_to :vote_up, other_answer, user: other_user }
    it { should be_able_to :vote_down, other_answer, user: other_user }
    it { should be_able_to :vote_up, other_question, user: other_user }
    it { should be_able_to :vote_down, other_question, user: other_user }
    
    it { should_not be_able_to :choose_the_best, other_answer, user: other_user }
    it { should_not be_able_to :vote_up, answer, user: user }
    it { should_not be_able_to :vote_down, answer, user: user }
    it { should_not be_able_to :vote_up, question, user: user }
    it { should_not be_able_to :vote_down, question, user: user }
  end
end
