class MissionControl::Jobs::WorkersController < MissionControl::Jobs::ApplicationController
  before_action :ensure_exposed_workers
  before_action :set_worker, only: [ :show, :prune ]

  def index
    @workers_page = MissionControl::Jobs::Page.new(workers_relation, page: params[:page].to_i)
    @workers_count = @workers_page.total_count
  end

  def show
  end

  def prune
    if (process = SolidQueue::Process.find_by(id: @worker.id))
      count = process.claimed_executions.count
      process.prune
      redirect_to application_workers_url(@application), notice: "Killed worker #{@worker.name} (#{count} jobs moved to failed)"
    else
      redirect_to application_workers_url(@application), alert: "Worker process not found"
    end
  end

  private
    def ensure_exposed_workers
      unless workers_exposed?
        redirect_to root_url, alert: "This server doesn't expose workers"
      end
    end

    def set_worker
      @worker = MissionControl::Jobs::Current.server.find_worker(params[:id])
    end

    def workers_relation
      MissionControl::Jobs::Current.server.workers_relation
    end
end
