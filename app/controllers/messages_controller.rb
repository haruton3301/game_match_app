
class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @room }
      end
    else
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
