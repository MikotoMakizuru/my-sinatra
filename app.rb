# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pg'

helpers do
  def text_escape(text)
    escape_html(text)
  end

  def memo_matched_with_memo_id
    memos.find { |memo| memo['memo_id'] == params[:memo_id] }
  end
end

def conn
  PG.connect(dbname: 'memo_app')
end

def memos
  conn.exec('SELECT * FROM memos')
end

def post_memo(title, content, create_date)
  conn.exec_params('INSERT INTO memos(title, content, created_date) VALUES ($1, $2, $3);', [title, content, create_date])
end

def patch_memo(title, content, memo_id)
  conn.exec_params('UPDATE memos SET title = $1, content = $2 WHERE memo_id = $3;', [title, content, memo_id])
end

def delete_memo(memo_id)
  conn.exec_params('DELETE FROM memos WHERE memo_id = $1;', [memo_id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/' do
  title = text_escape(params[:title]).to_s
  content = text_escape(params[:content]).to_s
  created_date = Time.now
  post_memo(title, content, created_date)
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
  patch_memo(title, content, memo_id)
  redirect "/memos/#{memo_id}"
end

delete '/memos/:memo_id' do |memo_id|
  delete_memo(memo_id)
  redirect '/memos'
end
