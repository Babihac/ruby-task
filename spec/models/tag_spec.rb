# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'validations' do
    let(:tag) { build(:tag) }

    context 'when title is present' do
      it 'is valid tag' do
        tag.title = 'test tag'
        expect(tag).to be_valid
      end
    end

    context 'when title is missing' do
      it 'is invalid tag' do
        tag.title = nil
        expect(tag).not_to be_valid
      end
    end
  end

  describe 'create with tasks' do
    let(:tag) { create(:tag) }
    let(:task) { create(:task, title: 'first task') }
    let(:second_task) { create(:task, title: 'second task') }

    it 'can add tags to task' do
      tag.tasks << task
      tag.tasks << second_task

      expect(tag.tasks.size).to eq(2)
    end

    it 'cleans up taggings when the task is deleted' do
      tag.tasks << task
      expect { tag.destroy }.to change(Tagging, :count).by(-1)
    end
  end
end
