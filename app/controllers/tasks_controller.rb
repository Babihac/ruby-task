# frozen_string_literal: true

class TasksController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :load_task_detail, only: %i[edit show]
  before_action :load_task, only: %i[destroy toggle_done update]
  before_action :load_user_resources, only: %i[new create edit update]

  def index
    @pagy, @tasks = pagy(Task.filter(filter_params).by_user(current_user.id), items: Pagy::DEFAULT[:max_items])
  rescue Pagy::OverflowError
    redirect_to tasks_path
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))
    render :new, status: :unprocessable_entity and return unless @task.valid?

    @task.save!
    redirect_to tasks_path, status: :see_other, notice: I18n.t('tasks.create.success')
  end

  def update
    render :edit, status: :unprocessable_entity and return unless @task.update(task_params)

    redirect_to tasks_path, status: :see_other, notice: I18n.t('tasks.update.success')
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: I18n.t('tasks.destroy.success')
  end

  def toggle_done
    task = Task.find(params[:id])
    task.update(is_done: !task.is_done)
    redirect_to request.referer || tasks_path, notice: I18n.t('tasks.toggle_complete.success')
  end

  private

  def task_params
    params.require(:task).permit(:title, :attachment, :project_id, :description, :is_done, tag_ids: [])
  end

  def filter_params
    params.permit(:title, :status, :project_id).to_h.select { |_, v| v.present? }
  end

  def load_task
    @task = Task.find(params[:id])

    redirect_to tasks_path, alert: I18n.t('tasks.unauthorized') if @task.user_id != current_user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: I18n.t('tasks.not_found')
  end

  def load_task_detail
    @task = Task.detail(params[:id])

    redirect_to tasks_path, alert: I18n.t('tasks.unauthorized') if @task.user_id != current_user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: I18n.t('tasks.not_found')
  end

  def load_user_resources
    @tags = Tag.by_user(current_user.id)
    @projects = Project.by_user(current_user.id)
  end
end
