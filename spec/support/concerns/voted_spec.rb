require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:model) { described_class.controller_name.classify.constantize }

  before { login(user) }

  describe 'POST #vote_up' do
    context 'author of resource' do
      before { login(user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new vote' do
        expect { post :vote_up, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    context 'not author of resource' do
      before { login(another_user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new vote' do
        expect { post :vote_up, params: { id: user_votable } }.to change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'author of resource' do
      before { login(user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new votedown' do
        expect { post :vote_down, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    context 'not author of resource' do
      before { login(another_user) }

      let!(:user_votable) { voted(model, user) }

      it 'try to add new votedown' do
        expect { post :vote_down, params: { id: user_votable } }.to change(Vote, :count)
      end
    end
  end
end
