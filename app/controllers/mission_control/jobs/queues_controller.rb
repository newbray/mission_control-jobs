class MissionControl::Jobs::QueuesController < MissionControl::Jobs::ApplicationController
  before_action :set_queue, only: [ :show, :discard ]

  def index
    @queues = ActiveJob.queues.sort_by(&:name)
  end

  def show
    @jobs_page = MissionControl::Jobs::Page.new(@queue.jobs, page: params[:page].to_i)
  end

  def discard
    count = @queue.jobs.count
    @queue.jobs.discard_all if count > 0
    redirect_to application_queue_path(@application, @queue.name), notice: "Discarded #{count} pending jobs from #{@queue.name}"
  end

  private
    def set_queue
      @queue = ActiveJob.queues[params[:id]]
    end
end
