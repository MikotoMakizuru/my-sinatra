# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'ulid'
require 'erb'

FILE_PATH = 'memos/memos.json'

helpers do
  def h(text)
    escape_html(text)
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  load_memos = File.read(FILE_PATH) { |file| JSON.parse(file) }
  @memos = JSON.parse load_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/' do
  memo = {
          'memo_id' => ULID.generate,
          'title'   => "#{h(params[:title])}",
          'content' => "#{h(params[:content])}"
				}
	File.open(FILE_PATH) do |file|
		load_memos = JSON.load(file)
		load_memos << memo
		File.open(FILE_PATH, "w") { |file| JSON.dump(load_memos, file) }
	end
	redirect '/memos'
end

get '/memos/:memo_id' do |memo_id|
	memos = File.open(FILE_PATH) { |file| JSON.load(file) }
	memos.each do |memo|
		if memo_id == memo['memo_id']
			@memo_id = memo['memo_id']
			@title = memo['title']
			@content = memo['content']
		end
	end
	erb :show
end

get '/memos/:memo_id/edit' do |memo_id|
	memos = File.open(FILE_PATH) { |file| JSON.load(file) }
	memos.each do |memo|
		if memo_id == memo['memo_id']
			@memo_id = memo['memo_id']
			@title = memo['title']
			@content = memo['content']
		end
	end
	erb :edit
end

patch '/memos/:memo_id' do |memo_id|
	title = "#{h(params[:title])}"
	content = "#{h(params[:content])}"

	memos = File.open(FILE_PATH) { |file| JSON.load(file) }
	memos.each do |memo|
		if memo_id == memo['memo_id']

			memo['title'] = title
			memo['content'] = content
			File.open(FILE_PATH, "w") { |file| JSON.dump(memos, file) }
		end
	end
	redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do |memo_id|
	memos = File.open(FILE_PATH) { |file| JSON.load(file) }
  memos.each do |memo|
		if memo_id == memo['memo_id']
			memos.delete(memo)
			File.open(FILE_PATH, "w") { |file| JSON.dump(memos, file) }
		end
	end
	erb :index
	redirect '/memos'
end
