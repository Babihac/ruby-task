# frozen_string_literal: true

class TagsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :load_tag, only: %i[destroy]

  def index
    filtered_tags = Tag.filter_by_title(params[:title]).by_user(current_user.id)
    @pagy, @tags = pagy(filtered_tags, items: Pagy::DEFAULT[:max_items])
  rescue Pagy::OverflowError
    redirect_to tags_path
  end

  def new
    @tag = Tag.new
  end

  def test
    1 + 1
  end

  def create
    @tag = Tag.new(tag_params.merge(user_id: current_user.id))
    render :new, status: :unprocessable_entity and return unless @tag.valid?

    @tag.save!
    redirect_to tags_path, status: :see_other, notice: I18n.t('tags.create.success')
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: I18n.t('tags.destroy.success')
  end

  private

  def tag_params
    params.require(:tag).permit(:title)
  end

  def load_tag
    @tag = Tag.find(params[:id])

    redirect_to tags_path, alert: I18n.t('tags.destroy.unauthorize') if @tag.user_id != current_user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to tags_path, alert: I18n.t('tags.not_found')
  end
end
