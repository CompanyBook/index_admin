class SolrServersController < ApplicationController
  # GET /solr_servers
  # GET /solr_servers.json
  def index
    @solr_servers = SolrServer.all
    #@server_name = params[:]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @solr_servers }
    end
  end

  # GET /solr_servers/1
  # GET /solr_servers/1.json
  def show
    @solr_server = SolrServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @solr_server }
    end
  end

  # GET /solr_servers/new
  # GET /solr_servers/new.json
  def new
    @solr_server = SolrServer.new
    @solr_server.name = params[:server_name]
    @solr_server.port = '8360'
    @solr_server.version = '3.6.0'

    respond_to do |format|
        format.html # new.html.erb
      format.json { render json: @solr_server }
    end
  end

  # GET /solr_servers/1/edit
  def edit
    @solr_server = SolrServer.find(params[:id])
  end

  # POST /solr_servers
  # POST /solr_servers.json
  def create
    @solr_server = SolrServer.new(params[:solr_server])

    respond_to do |format|
      if @solr_server.save
        format.html { redirect_to @solr_server, notice: 'Solr server was successfully created.' }
        format.json { render json: @solr_server, status: :created, location: @solr_server }
      else
        format.html { render action: "new" }
        format.json { render json: @solr_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /solr_servers/1
  # PUT /solr_servers/1.json
  def update
    @solr_server = SolrServer.find(params[:id])

    respond_to do |format|
      if @solr_server.update_attributes(params[:solr_server])
        format.html { redirect_to @solr_server, notice: 'Solr server was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @solr_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solr_servers/1
  # DELETE /solr_servers/1.json
  def destroy
    @solr_server = SolrServer.find(params[:id])
    @solr_server.destroy

    respond_to do |format|
      format.html { redirect_to solr_servers_url }
      format.json { head :ok }
    end
  end
end
