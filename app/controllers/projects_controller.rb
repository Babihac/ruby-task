# frozen_string_literal: true

class ProjectsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :load_project, only: %i[destroy]

  def index
    @pagy, @projects = pagy(Project.where(user_id: current_user.id).order(position: :asc), items: 10)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge(user_id: current_user.id))
    render :new, status: :unprocessable_entity and return unless @project.valid?

    ProjectService.shift_projects(project_params[:position])
    @project.save!
    redirect_to projects_path, status: :see_other, notice: I18n.t('projects.create.success')
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: I18n.t('projects.destroy.success')
  end

  private

  def project_params
    params.require(:project).permit(:title, :position)
  end

  def load_project
    @project = Project.find(params[:id])

    redirect_to projects_path, alert: I18n.t('projects.destroy.unauthorize') if @project.user_id != current_user.id
  rescue ActiveRecord::RecordNotFound
    redirect_to projects_path, alert: I18n.t('projects.destroy.not_found')
  end
end
