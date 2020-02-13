# frozen_string_literal: true

require_relative 'db'
require_relative 'link'

require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/respond_with'
require 'json'

# Configuration

configure do
  set :erb, escape_html: true
  set(:public_folder, proc { File.join(root, '..', 'static') })
end

# Actions

get '/', provides: %w'text/html application/json' do
  @links = Link.order(Sequel.desc(:hits)).all
  respond_with :index do |f|
    f.html { erb :index, params: params }
    f.json { @links.map(&:to_json).to_json }
  end
end

get '/links' do
  redirect '/'
end

post '/links' do
  Link.create(
    name: params[:name].strip,
    url: params[:url].strip,
    description: params[:description].strip
  )
  redirect '/'
rescue Sequel::ValidationFailed,
       Sequel::DatabaseError => e
  halt "Error: #{e.message}"
end

get '/links/suggest' do
  query = params[:q]

  results = Link
            .filter(Sequel.ilike(:name, "#{query}%"))
            .or(Sequel.ilike(:url, "%#{query}%"))
  results = results.all.map(&:name)

  content_type :json
  results.to_json
end

get '/links/search' do
  query = params[:q]
  @links = Link
           .filter(Sequel.ilike(:name, "#{query}%"))
           .order(Sequel.desc(:hits))
           .all

  respond_with :index do |f|
    f.html { erb :index, params: params }
    f.json { @links.map(&:to_json).to_json }
  end
end

post '/links/:id/remove' do
  link = Link.find(id: params[:id])
  halt 404 unless link
  link.destroy
  redirect '/'
end

post '/links/:id/update' do
  link = Link.find(id: params[:id])
  halt 404 unless link

  begin
    link.name = params[:name]
    link.description = params[:description]
    link.url = params[:url]
    link.save
    redirect '/'
  rescue Sequel::ValidationFailed,
         Sequel::DatabaseError => e
    halt "Error: #{e.message}"
  end
end

get '/:name/?*?' do
  link = Link[name: [params[:name], params[:splat].first].join('/')]
  params[:splat] = [''] if link # remove the splat so we don't reuse it

  # Just try the straight link if we didn't find a matching link
  link ||= Link[name: params[:name]]

  if link
    link.hit!

    parts = params[:splat].first.split('/')
    parts = nil if parts.empty?

    url = link.url
    url %= parts

    redirect url
  else
    # try to list sub-links of the namespace
    filtered_links = Link
                     .filter(Sequel.ilike(:name, "#{params[:name]}%"))
                     .order(Sequel.desc(:hits))
                     .all
    if filtered_links.empty?
      @links = Link.order(Sequel.desc(:hits)).all
      params[:not_found] = params[:name]
    else
      @links = filtered_links
      params[:links_filter] = params[:name]
    end
    respond_with :index do |f|
      f.html { erb(:index, params: params) }
    end
  end
end
