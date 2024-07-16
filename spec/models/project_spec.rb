# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    let(:title) { 'test title' }
    let(:position) { 1 }
    let(:project) { create(:project, title:, position:) }

    before do
      project
    end

    context 'with duplicate title' do
      it 'is not valid project' do
        new_project = described_class.new(title:, position: 2)
        expect(new_project).not_to be_valid
      end
    end

    context 'with duplicate position' do
      it 'is not valid project' do
        new_project = described_class.new(title: 'new title', position: 1)
        expect(new_project).not_to be_valid
      end
    end

    context 'with unique title and position' do
      it 'is valid project' do
        new_project = described_class.new(title: 'new title', position: 2)
        expect(new_project).to be_valid
      end
    end
  end
end
