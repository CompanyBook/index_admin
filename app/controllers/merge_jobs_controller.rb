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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @merge_job }
    end
  end

  # GET /merge_jobs/new
  # GET /merge_jobs/new.json
  def new
    @merge_job = MergeJob.new
    @merge_job.hdfs_src = params[:hdfs_src]
    @merge_job.dest_path = params[:dest_path]
    @merge_job.dest_server = params[:dest_server]

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

  def run
    @merge_job = MergeJob.find(params[:id])


    #respond_to do |format|
    #  format.html { redirect_to merge_jobs_url }
    #  format.json { head :ok }
    #end
  end
end
