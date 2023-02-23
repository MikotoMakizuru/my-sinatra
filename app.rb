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

  def memos_get
    JSON.parse(File.read(FILE_PATH))
  end

  def memo_matched_with_memo_id
    memos_get.each do |memo|
      return memo if memo['memo_id'] == params[:memo_id]
    end
  end
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  if File.exist?(FILE_PATH)
    @memos = memos_get
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
  memos = JSON.parse(File.read(FILE_PATH))
  memos << memo
  File.open(FILE_PATH, 'w') { |file| JSON.dump(memos, file) }
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo_id = memo_matched_with_memo_id['memo_id']
  @title = memo_matched_with_memo_id['title']
  @content = memo_matched_with_memo_id['content']
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo_id = memo_matched_with_memo_id['memo_id']
  @title = memo_matched_with_memo_id['title']
  @content = memo_matched_with_memo_id['content']
  erb :edit
end

patch '/memos/:memo_id' do |memo_id|
  title = text_escape(params[:title]).to_s
  content = text_escape(params[:content]).to_s

  memos = memos_get
  memos.each do |memo|
    next unless memo_id == memo['memo_id']

    memo['title'] = title
    memo['content'] = content
    File.open(FILE_PATH, 'w') { |file| JSON.dump(memos, file) }
  end
  redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do |memo_id|
  memos = memos_get
  memos.each do |memo|
    if memo_id == memo['memo_id']
      memos.delete(memo)
      File.open(FILE_PATH, 'w') { |file| JSON.dump(memos, file) }
    end
  end
  erb :index
  redirect '/memos'
end
