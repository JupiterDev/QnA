require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create :link, name: 'link_name', url: 'https://thinknetica.teachbase.ru/', linkable: question }
  let(:another_user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(user) }

      it 'removes link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to change(Link, :count).by(-1)
      end
    end

    context 'Not the author' do
      before { login(another_user) }

      it 'removes link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end
    end

    context 'Unauthenticate user' do
      it 'removes link' do
        expect { delete :destroy, params: { id: link.id }, format: :js }.to_not change(Link, :count)
      end
    end
    
  end
end
