class MergeJobsController < ApplicationController
  # GET /merge_jobs
  # GET /merge_jobs.json
  def index
    @merge_jobs = MergeJob.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @merge_jobs }
    end
  end

  # GET /merge_jobs/1
  # GET /merge_jobs/1.json
  def show
    @merge_job = MergeJob.find(params[:id])
    @is_solr_install_status_ok, @solr_install_status = check_solr

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @merge_job }
    end
  end

  # GET /merge_jobs/new
  # GET /merge_jobs/new.json
  def new
    @merge_job = MergeJob.new
    index_name = params[:hdfs_src].split('/').last
    @merge_job.hdfs_src = params[:hdfs_src]
    @merge_job.dest_path = "#{params[:dest_path]}/#{index_name}"
    @merge_job.dest_server = params[:dest_server]
    @merge_job.copy_dst = "/data/f/copy_to/#{index_name}"
    @merge_job.job_id = params[:job_id]
    @merge_job.solr_schema = params[:solr_schema]
    @merge_job.solr_version = "3.5.0"
    @merge_job.solr_lib_path = "/usr/local/solr/apache-solr-3.5.0/example/webapps/WEB-INF/lib"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @merge_job }
    end
  end

  # GET /merge_jobs/1/edit
  def edit
    @merge_job = MergeJob.find(params[:id])
  end

  # POST /merge_jobs
  # POST /merge_jobs.json
  def create
    @merge_job = MergeJob.new(params[:merge_job])

    respond_to do |format|
      if @merge_job.save
        format.html { redirect_to @merge_job, notice: 'Merge job was successfully created.' }
        format.json { render json: @merge_job, status: :created, location: @merge_job }
      else
        format.html { render action: "new" }
        format.json { render json: @merge_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /merge_jobs/1
  # PUT /merge_jobs/1.json
  def update
    @merge_job = MergeJob.find(params[:id])

    respond_to do |format|
      if @merge_job.update_attributes(params[:merge_job])
        format.html { redirect_to @merge_job, notice: 'Merge job was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @merge_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /merge_jobs/1
  # DELETE /merge_jobs/1.json
  def destroy
    @merge_job = MergeJob.find(params[:id])
    @merge_job.destroy

    respond_to do |format|
      format.html { redirect_to merge_jobs_url }
      format.json { head :ok }
    end
  end

  def check_solr
    @merge_job.check_solr_installation(@merge_job.solr_lib_path, @merge_job.solr_version)
  end

  def run
    @merge_job = MergeJob.find(params[:id])
    @merge_job.run_solr_index_copy_and_merg

    respond_to do |format|
      format.html { redirect_to merge_job_path @merge_job }
      format.json { head :ok }
    end
  end
end
