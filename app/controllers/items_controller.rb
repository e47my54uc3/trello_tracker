class  ItemsController < ApplicationController
  include TrelloHelper

  attr_reader :board

  def initialize
    @board = Trello::Board.all.find { |board| board.id == ENV['balance_tracker_board'] }
  end
  
  def index
    items = Item.where(params[:user_id])
    render :json => items
  end

  # def show
  #   # @user = User.first
  #   u = User.find(params[:user_id])

  #   # list = u.check_status
  #   # render :json => list
  #   render :json => u
  # end


  def create
    # item = Item.where(id: params[:id]).first
    user = User.where(id: params[:user_id]).first

    user.check_status
    user.delinquent ? list_id = ENV['Open_list'] : list_id = ENV['Resolved_list']

     # Trello::Card.create(
        
     #    'name' => user.name,
     #    'idList' => '55845c213d89bb5cba82fdbb'
     #    # desc: object.url.to_s
     #  )


    @client = Trello::Client.new(
      developer_public_key: ENV['developer_public_key'],
      member_token: ENV['authorize_write_token'],
    )

    card = @client.create(:card, {
      'name' => user.name,
      'idList' => '55845c213d89bb5cba82fdbb',
      

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