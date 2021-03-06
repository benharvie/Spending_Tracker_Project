require 'sinatra'
require 'sinatra/contrib/all'
require 'pry-byebug'
require_relative '../models/transaction'
require_relative '../models/merchant'
require_relative '../models/tag'
also_reload '../models/*'

#SUMMARY
get '/' do
  @transaction_list = Transaction.all
  @tag_list = Tag.all
  @merchant_list = Merchant.all
  erb :index
end

#INDEX
get '/transactions' do
  @transaction_list = Transaction.all
  erb :"transactions/index"
end

#FILTER TRANSACTION
get '/transactions/filter' do
  @start_date = params[:start_date]
  @end_date = params[:end_date]
  @transaction_list = Transaction.date_between(@start_date, @end_date)
  erb :"transactions/filter"
end

#NEW TRANSACTION
get '/transactions/new' do
  erb :"transactions/new"
end

#POST NEW TRANSCATION
post '/transactions' do
  new_transaction = Transaction.new({ 'description' => params[:description],
                                      'amount' => params[:amount],
                                      'transaction_date' => params[:transaction_date],
                                      'merchant_id' => params[:merchant],
                                      'tag_id' => params[:tag] })
  new_transaction.save
  redirect to '/transactions'
end

#EDIT TRANSACTION
get '/transactions/:id/edit' do
  @transaction = Transaction.find_by_id(params[:id]).first
  erb :"transactions/edit"
end

#UPDATE TRANSACTION
post '/transactions/:id' do
  transaction = Transaction.new(params)
  transaction.update
  redirect to '/transactions'
end

#DELETE TRANSACTION
get '/transactions/:id/delete' do
  Transaction.find_by_id(params[:id]).first.delete
  redirect to '/transactions'
end
