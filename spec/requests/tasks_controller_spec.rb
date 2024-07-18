# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController do
  let(:user) { create(:user, email: 'tester@test.cz') }
  let(:task_url) { '/tasks' }

  context 'when user is signed in' do
    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'renders a successful response' do
        get task_url
        expect(response).to be_successful
      end
    end

    describe 'GET #show' do
      it 'renders a successful response' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}"
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'renders a successful response' do
        get "#{task_url}/new"
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'renders a successful response' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}/edit"
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new Task' do
          expect do
            post task_url, params: { task: attributes_for(:task) }
          end.to change(Task, :count).by(1)
        end

        it 'redirects to the created task' do
          post task_url, params: { task: attributes_for(:task) }
          expect(response).to redirect_to(tasks_url)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Task' do
          expect do
            post task_url, params: { task: attributes_for(:task, title: nil) }
          end.not_to change(Task, :count)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested task' do
        task = create(:task, user:)
        expect do
          delete "#{task_url}/#{task.id}"
        end.to change(Task, :count).by(-1)
      end

      it 'redirects to the tasks list' do
        task = create(:task, user:)
        delete "#{task_url}/#{task.id}"
        expect(response).to redirect_to(tasks_url)
      end
    end
  end

  context 'when user is not signed in' do
    describe 'GET #index' do
      it 'redirects to the sign in page' do
        get task_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'GET #show' do
      it 'redirects to the sign in page' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}"
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'GET #new' do
      it 'redirects to the sign in page' do
        get "#{task_url}/new"
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'GET #edit' do
      it 'redirects to the sign in page' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}/edit"
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'POST #create' do
      it 'redirects to the sign in page' do
        post task_url, params: { task: attributes_for(:task) }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to the sign in page' do
        task = create(:task, user:)
        delete "#{task_url}/#{task.id}"
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  context 'when user is signed in as another user' do
    before do
      sign_in create(:user, email: 'another@user.cz')
    end

    describe 'GET #show' do
      it 'redirects to the tasks list' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}"
        expect(response).to redirect_to(tasks_url)
      end
    end

    describe 'GET #edit' do
      it 'redirects to the tasks list' do
        task = create(:task, user:)
        get "#{task_url}/#{task.id}/edit"
        expect(response).to redirect_to(tasks_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to the tasks list' do
        task = create(:task, user:)
        delete "#{task_url}/#{task.id}"
        expect(response).to redirect_to(tasks_url)
      end
    end
  end
end
