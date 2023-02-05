require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'ulid'

FILE_PATH = "memos/memos.json"

memos = []

get '/' do
	redirect '/memos'
end

get '/memos' do
	Dir.glob(FILE_PATH) do |file|
		file_parse = JSON.parse (File.open(file).read)
		file_parse = JSON.parse file_parse
		memos << file_parse
		@memos = memos
	end
	erb :index
end

get '/memos/new' do
	erb :new
end

post '/' do
	memo = {
		'memo_id'=>ULID.generate,
		'title'=>params[:title],
		'content'=>params[:content]
	}
	memo_json = JSON.pretty_generate(memo)
	File.open(FILE_PATH, 'a') do |file|
		str = JSON.dump(memo_json, file)
	end
	redirect '/memos'
end

get '/memos/:memo_id' do |memo_id|
	# @memos = []
	memos.each do |memo|
		if memo_id == memo[:memo_id]
			@memos << memo
		end
	end
	erb :show
end

get '/memos/:memo_id/edit' do |memo_id|
	# @memos = []
	memos.each do |memo|
		if memo_id == memo[:memo_id]
			@memos << memo
		end
	end
	erb :edit
end

patch '/memos/:memo_id' do |memo_id|
	title = params[:title]
	content = params[:content]

	memos.each do |memo|
		if memo_id == memo[:memo_id]
			memo[:title] = title
			memo[:content] = content
		end
	end
	redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do |memo_id|
  memos.each do |memo|
		if memo_id == memo[:memo_id]
			memo.delete(:memo_id)
			memo.delete(:title)
			memo.delete(:content)
			@memos = memos
			redirect '/memos'
		end
	end
end
