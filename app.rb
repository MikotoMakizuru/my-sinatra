# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'ulid'
require 'erb'

FILE_PATH = 'memos/memos.json'

helpers do
  def text_escape(text)
    escape_html(text)
  end

  def memos
    JSON.parse(File.read(FILE_PATH))
  end

  def memo_matched_with_memo_id
    memos.find { |memo| memo['memo_id'] == params[:memo_id] }
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  if File.exist?(FILE_PATH)
    @memos = memos
  else
    File.open(FILE_PATH, 'w') { |file| file.write([]) }
  end
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/' do
  memo = {
    'memo_id': ULID.generate,
    'title': text_escape(params[:title]).to_s,
    'content': text_escape(params[:content]).to_s
  }
  memos_data = memos
  memos_data << memo
  File.open(FILE_PATH, 'w') { |file| JSON.dump(memos_data, file) }
  redirect '/memos'
end

get '/memos/:memo_id' do
  memo = memo_matched_with_memo_id
  @memo_id = memo['memo_id']
  @title = memo['title']
  @content = memo['content']
  erb :show
end

get '/memos/:memo_id/edit' do
  memo = memo_matched_with_memo_id
  @memo_id = memo['memo_id']
  @title = memo['title']
  @content = memo['content']
  erb :edit
end

patch '/memos/:memo_id' do |memo_id|
  title = text_escape(params[:title]).to_s
  content = text_escape(params[:content]).to_s

  memos_data = memos
  memos_data.each do |memo|
    next unless memo_id == memo['memo_id']

    memo['title'] = title
    memo['content'] = content
    File.open(FILE_PATH, 'w') { |file| JSON.dump(memos_data, file) }
  end
  redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do |memo_id|
  memos_data = memos
  memos_data.each do |memo|
    if memo_id == memo['memo_id']
      memos_data.delete(memo)
      File.open(FILE_PATH, 'w') { |file| JSON.dump(memos_data, file) }
    end
  end
  erb :index
  redirect '/memos'
end
