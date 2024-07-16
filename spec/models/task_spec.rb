# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task) }

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
    let(:task) { create(:task) }
    let(:tag) { create(:tag, title: 'first tag') }
    let(:second_tag) { create(:tag, title: 'second tag') }

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
end
