# frozen_string_literal: true

class TasksController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :load_task, only: %i[destroy edit update show toggle_done]

  def index
    @pagy, @tasks = pagy(Task.where(user_id: current_user.id).order(created_at: :desc), items: 8)
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

  def load_task
    @task = Task.find(params[:id])

    redirect_to tasks_path, alert: I18n.t('tasks.unauthorized') if @task.user_id != current_user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: I18n.t('tasks.not_found')
  end
end
