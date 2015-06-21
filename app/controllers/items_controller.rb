class  ItemsController < ApplicationController
  include TrelloHelper

  attr_reader :board

  def initialize
    @trello_client = Trello::Client.new(
      developer_public_key: ENV['developer_public_key'],
      member_token: ENV['authorize_write_token'],
    )

    @board = Trello::Board.all.detect { |board| board.id == '55845bdb3318e9b6a881b5af' }
  end

   # def show
  #   # @user = User.first
  #   u = User.find(params[:user_id])

  #   # list = u.check_status
  #   # render :json => list
  #   render :json => u
  # end

  
  def index
    items = Item.where(params[:user_id])
    render :json => items
  end

 
  def create

    item_type = params[:item_type]
    amount = params[:amount]
    user = User.where(id: params[:user_id]).first

    Item.create(
      item_type: item_type,
      amount: amount,
      user_id: user.id
    )

    user.check_status

    p binding.byebug

    if user.delinquent
      list_id = '55845c213d89bb5cba82fdbb'
    else
      list_id = '55845c23078838b9b03515d5'
    end

    

    card = @trello_client.create(:card, {
      'name' => user.name,
      'idList' => list_id,
    })

  end


  def show
    item_type = params[:item_type]
    amount = params[:amount]

    item = Item.where(id: params[:id]).first
    user = User.where(id: item.user_id).first

    user.check_status
    user.delinquent ? list_id = ENV['Open_list'] : list_id = ENV['Resolved_list']



    render :json => { item: item, user: user, list_id: list_id}

    # user = User.where(id: item.user_id)


    # user.check_status

    #



    # render :json => list_id
  end






  

end