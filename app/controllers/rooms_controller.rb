class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show, :join, :finish ]

  def index
    @status = params[:status] || "waiting" # 初期表示は "waiting"
    @rooms = Room.where(status: @status)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.creator = current_user

    if @room.save
      redirect_to @room, notice: "ルームが作成されました"
    else
      Rails.logger.debug "💥 ルーム作成失敗: #{@room.errors.full_messages}"
      render :new
    end
  end

  def show
    @user_in_room = [ @room.creator, @room.participant ].include?(current_user)
    @can_join = !@user_in_room && @room.status == "waiting" && @room.participant.nil?
    @can_finish = @room.creator == current_user && @room.status == "playing"

    @messages = @room.messages.includes(:user)
  end

  def join
    if @room.join_participant(current_user)
      redirect_to @room, notice: "ルームに参加しました"
    else
      redirect_to @room, alert: "参加できません"
    end
  end

  def finish
    if @room.creator == current_user && @room.status == "playing"
      winner = params[:room][:result] == "win" ? current_user : @room.participant
      loser = winner == current_user ? @room.participant : current_user

      @room.finish_match(winner, loser)
      redirect_to @room, notice: "試合が終了しました"
    else
      redirect_to @room, alert: "試合の終了処理ができません"
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
