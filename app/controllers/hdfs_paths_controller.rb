class HdfsPathsController < ApplicationController
  # GET /hdfs_paths
  # GET /hdfs_paths.json
  def index
    @hdfs_paths = HdfsPath.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hdfs_paths }
    end
  end

  # GET /hdfs_paths/1
  # GET /hdfs_paths/1.json
  def show
    @hdfs_path = HdfsPath.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hdfs_path }
    end
  end

  # GET /hdfs_paths/new
  # GET /hdfs_paths/new.json
  def new
    @hdfs_path = HdfsPath.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hdfs_path }
    end
  end

  # GET /hdfs_paths/1/edit
  def edit
    @hdfs_path = HdfsPath.find(params[:id])
  end

  # POST /hdfs_paths
  # POST /hdfs_paths.json
  def create
    @hdfs_path = HdfsPath.new(params[:hdfs_path])

    respond_to do |format|
      if @hdfs_path.save
        format.html { redirect_to @hdfs_path, notice: 'Hdfs path was successfully created.' }
        format.json { render json: @hdfs_path, status: :created, location: @hdfs_path }
      else
        format.html { render action: "new" }
        format.json { render json: @hdfs_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hdfs_paths/1
  # PUT /hdfs_paths/1.json
  def update
    @hdfs_path = HdfsPath.find(params[:id])

    respond_to do |format|
      if @hdfs_path.update_attributes(params[:hdfs_path])
        format.html { redirect_to @hdfs_path, notice: 'Hdfs path was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @hdfs_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hdfs_paths/1
  # DELETE /hdfs_paths/1.json
  def destroy
    @hdfs_path = HdfsPath.find(params[:id])
    @hdfs_path.destroy

    respond_to do |format|
      format.html { redirect_to hdfs_paths_url }
      format.json { head :ok }
    end
  end
end
