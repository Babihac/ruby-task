# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user, email: 'tester@test.cz') }
  let(:task) { build(:task, user:) }

  describe 'attachment field' do
    context 'when attachment size is lte 10MB' do
      it 'is valid' do
        task.attachment.attach(io: Rails.root.join('spec/support/attachments/max_size_file.jpg').open, filename: 'small_file.jpg', content_type: 'image/jpeg')
        expect(task).to be_valid
      end
    end

    context 'when attachment size is greater than 10MB' do
      it 'is not valid with' do
        task.attachment.attach(io: Rails.root.join('spec/support/attachments/large_file.jpg').open, filename: 'small_file.jpg', content_type: 'image/jpeg')
        expect(task).not_to be_valid
        expect(task.errors[:attachment]).to include('is too big')
      end
    end
  end

  describe 'title field' do
    context 'when title is present' do
      it 'is valid' do
        task.title = 'test title'
        expect(task).to be_valid
      end
    end

    context 'when title is missing' do
      it 'is invalid' do
        task.title = nil
        expect(task).not_to be_valid
      end
    end
  end

  describe 'create with tags' do
    let(:user) { create(:user, email: 'tester@test.cz') }
    let(:task) { create(:task, user:) }
    let(:tag) { create(:tag, title: 'first tag', user:) }
    let(:second_tag) { create(:tag, title: 'second tag', user:) }

    it 'can add tags to task' do
      task.tags << tag
      task.tags << second_tag

      expect(task.tags.size).to eq(2)
    end

    it 'cleans up taggings when the task is deleted' do
      task.tags << tag
      expect { task.destroy }.to change(Tagging, :count).by(-1)
    end
  end

  describe '.by_user' do
    let!(:user) { create(:user, email: 'tester@test.cz') }
    let!(:other_user) { create(:user, email: 'tester2@test.cz') }

    let!(:older_task) { create(:task, user:, created_at: 1.day.ago) }
    let!(:newer_task) { create(:task, user:, created_at: 1.hour.ago) }
    let!(:other_user_task) { create(:task, user: other_user) }

    it 'returns tasks belonging to the specified user, ordered by created_at desc' do
      tasks = described_class.by_user(user.id)

      expect(tasks.length).to eq(2)
      expect(tasks.first).to eq(newer_task)
      expect(tasks.second).to eq(older_task)
      expect(tasks).not_to include(other_user_task)
    end
  end

  describe '.filter_by_project_id' do
    let!(:user) { create(:user, email: 'tester@test.cz') }
    let!(:project) { create(:project, position: Project.count + 1, user:) }
    let!(:other_project) { create(:project, position: Project.count + 2, title: 'other project', user:) }

    let!(:older_task) { create(:task, project:, created_at: 1.day.ago, user:) }
    let!(:newer_task) { create(:task, project:, created_at: 1.hour.ago, user:) }
    let!(:other_project_task) { create(:task, project: other_project, user:) }

    it 'returns tasks belonging to the specified project, ordered by created_at desc' do
      tasks = described_class.filter_by_project_id(project.id)

      expect(tasks.length).to eq(2)
      expect(tasks.first).to eq(newer_task)
      expect(tasks.second).to eq(older_task)
      expect(tasks).not_to include(other_project_task)
    end
  end

  describe '.filter_by_title' do
    let!(:user) { create(:user, email: 'tester@test.cz') }
    let!(:task_with_title) { create(:task, title: 'Complete the project documentation', user:) }
    let(:task_with_different_title) { create(:task, title: 'Review code for the new feature', user:) }
    let!(:task_with_partial_match) { create(:task, title: 'Documentation review meeting', user:) }

    before do
      task_with_different_title
    end

    it 'returns tasks that match the title search, case-insensitively' do
      expect(described_class.filter_by_title('docu')).to contain_exactly(task_with_title, task_with_partial_match)
    end

    it 'returns an empty array when no titles match' do
      expect(described_class.filter_by_title('nonexistent')).to be_empty
    end
  end
end
