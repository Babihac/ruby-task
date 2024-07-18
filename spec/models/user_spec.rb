# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'deleting a user' do
    let(:user) { create(:user, email: 'test@test.cz') }
    let(:project) { create(:project, user:) }
    let(:tag) { create(:tag, user:) }

    before do
      project
      tag
    end

    it 'deletes associated projects and tags' do
      expect { user.destroy }.to change(Project, :count).by(-1).and change(Tag, :count).by(-1)
    end
  end
end
