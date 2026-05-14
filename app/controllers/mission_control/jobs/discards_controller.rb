class MissionControl::Jobs::DiscardsController < MissionControl::Jobs::ApplicationController
  include MissionControl::Jobs::JobScoped

  def create
    status_before_discard = @job.status
    @job.discard
    redirect_to redirect_location(status_before_discard), notice: "Discarded job with id #{@job.job_id}"
  end

  private
    def jobs_relation
      ActiveJob.jobs
    end

    def redirect_location(status = nil)
      status = status.presence_in(supported_job_statuses) || :failed
      application_jobs_url(@application, status, **jobs_filter_param)
    rescue NoMethodError
      application_jobs_url(@application, :failed)
    end
end
