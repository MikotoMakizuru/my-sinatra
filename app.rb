require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pry'

@memos = []

get '/' do
	redirect '/memos'
end

get '/memos' do
	erb :index
end

get '/memos/new' do
	erb :new
end

post '/' do
	@memos << params[:title]
	binding.pry
	erb :index
end

get '/memos/show' do
	erb :show
end

get '/memos/edit' do
	erb :edit
end
