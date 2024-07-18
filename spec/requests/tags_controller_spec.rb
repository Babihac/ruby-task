# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :request do
  let(:user) { create(:user, email: 'test@test.cz') }
  let(:valid_attributes) { { title: 'Test Tag' } }
  let(:invalid_attributes) { { name: '' } }
  let(:tags_url) { '/tags' }

  context 'when user is signed in' do
    before do
      sign_in user
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        get tags_url
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Tag' do
          expect do
            post tags_url, params: { tag: valid_attributes }
          end.to change(Tag, :count).by(1)
        end

        it 'redirects to the created tag' do
          post tags_url, params: { tag: valid_attributes }
          expect(response).to redirect_to(tags_url)
        end
      end

      it 'set user_id to current user' do
        post tags_url, params: { tag: valid_attributes }
        expect(Tag.last.user_id).to eq(user.id)
      end

      context 'with invalid parameters' do
        it 'does not create a new Tag' do
          expect do
            post tags_url, params: { tag: invalid_attributes }
          end.not_to change(Tag, :count)
        end
      end
    end
  end

  context 'when user is not signed in' do
    describe 'GET /index' do
      it 'redirects to sign in page' do
        get tags_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST /create' do
      it 'redirects to sign in page' do
        post tags_url, params: { tag: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
