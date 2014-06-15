class TasksController < ApplicationController

  include TasksHelper

  before_filter :find_task, only: [:show, :edit, :update, :destroy, :complete]
  before_filter :authenticate_user!

  def index
    @tasks = current_user.tasks.not_done
    @finished_tasks = current_user.tasks.finished

    # for new task form
    @task = Task.new
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    if @task.save
      flash[:notice] = "Zadanie zapisane!"
      redirect_to tasks_path
    else
      flash.now[:error] = "Niepoprawne dane"
      render action: "index"
    end

  end

  def edit
  end

  def update
    @task.update_attributes(task_params)
    if @task.save
      flash[:notice] = "Zadanie zaktualizowane!"
      redirect_to tasks_path
    else
      flash.now[:error] = "Niepoprawne dane w formularzu!"
      render action: "edit"
    end
  end

  def destroy
    @task.destroy!
    flash[:notice] = "Zadanie usunięte!"
    redirect_to tasks_path
  end

  def complete
    @task.complete!

    flash[:notice] = completion_flash_notice
    redirect_to tasks_path
  end

  private

    def find_task
      @task = current_user.tasks.find params[:id]
    end

    def task_params
      params.require(:task).permit(:title, :description)
    end

end
