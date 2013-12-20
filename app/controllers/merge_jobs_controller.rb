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

  # POST /merge_jobs/new
  # POST /merge_jobs/new.json
  def new
    # get checked

    index_name = params[:hdfs_src].split('/').last
    result_path = params[:dest_paths].map { |path| "#{path}/#{index_name}" }.join(",\n")

    @merge_job = MergeJob.new
    @merge_job.hdfs_src = params[:hdfs_src]
    @merge_job.dest_path = result_path
    @merge_job.dest_server = params[:dest_server]
    @merge_job.copy_dst = "/srv/scratch1/merge/#{index_name}"
    @merge_job.job_id = params[:job_id]
    @merge_job.solr_schema = params[:solr_schema]
    @merge_job.solr_version = "4.3.0"
    @merge_job.solr_lib_path = "/opt/solr43/example/webapps/WEB-INF/lib"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @merge_job }
    end
  end

  # GET /merge_jobs/new
  # GET /merge_jobs/new.json
  def deploy
    # get checked

    index_name = params[:hdfs_src].split('/').last

    @merge_job = MergeJob.new
    @merge_job.hdfs_src = params[:hdfs_src]
    @merge_job.dest_path = "#{params[:dest_path]}/#{index_name}"
    @merge_job.dest_server = params[:dest_server]
    @merge_job.copy_dst = "/srv/scratch1/merge/#{index_name}"
    @merge_job.job_id = params[:job_id]
    @merge_job.solr_schema = params[:solr_schema]
    @merge_job.solr_version = "4.3.0"
    @merge_job.solr_lib_path = "/opt/solr43/example/webapps/WEB-INF/lib"

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
