require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do

    before { question.files.attach(io: File.open("#{Rails.root.join('spec/rails_helper.rb')}"), filename: 'rails_helper.rb') }

    context 'Author' do
      before { login(user) }

      it 'trying to delete their attachment' do
        expect { delete :destroy, params: { id: question.files.first}, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'redirect' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      before { login(another_user) }

      it "trying to delete someone else's question" do
        expect { delete :destroy, params: { id: question.files.first}, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
