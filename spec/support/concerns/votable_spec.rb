require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:third_user) { create(:user) }
  let(:votable) do
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end

  it '#vote_up' do
    votable.vote_up(another_user)
    expect(Vote.last.value).to eq 1
  end

  it '#vote_down' do
    votable.vote_down(another_user)
    expect(Vote.last.value).to eq -1
  end

  it '#rating' do
    votable.vote_up(another_user)
    votable.vote_up(third_user)
    expect(votable.rating).to eq 2
  end
end
