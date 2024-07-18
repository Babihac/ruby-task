# frozen_string_literal:true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:user) { create(:user, email: 'test@test.cz') }
  let(:valid_attributes) { { title: 'Test Project', position: 1 } }
  let(:invalid_attributes) { { title: '', position: '' } }
  let(:projects_url) { '/projects' }

  context 'when user is signed in' do
    before do
      sign_in user
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        get projects_url
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Project' do
          expect do
            post projects_url, params: { project: valid_attributes }
          end.to change(Project, :count).by(1)
        end

        it 'set user_id to current user' do
          post projects_url, params: { project: valid_attributes }
          expect(Project.last.user_id).to eq(user.id)
        end

        it 'redirects to the created project' do
          post projects_url, params: { project: valid_attributes }
          expect(response).to redirect_to(projects_url)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Project' do
          expect do
            post projects_url, params: { project: invalid_attributes }
          end.not_to change(Project, :count)
        end
      end
    end
  end

  context 'when user is not signed in' do
    describe 'GET /index' do
      it 'redirects to sign in page' do
        get projects_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'POST /create' do
      it 'redirects to sign in page' do
        post projects_url, params: { project: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
