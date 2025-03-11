require 'rails_helper'

RSpec.describe "RoomsController", type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room, creator: user) }

  # Userのサインイン
  before do
    sign_in user
  end

  describe "GET /rooms" do
    it "ルームの一覧を表示する" do
      room
      get rooms_path
      expect(response).to be_successful
      expect(response.body).to include(room.name)
    end
  end

  describe "GET /rooms/:id" do
    it "ルームの詳細を表示する" do
      get room_path(room)
      expect(response).to be_successful
      expect(response.body).to include(room.name)
    end
  end

  describe "POST /rooms" do
    context "有効なパラメータで" do
      it "ルームを作成できる" do
        expect {
          post rooms_path, params: { room: { name: "新しいルーム" } }
        }.to change(Room, :count).by(1)
        expect(response).to redirect_to(room_path(Room.last))
        follow_redirect!
        expect(response.body).to include("ルームが作成されました")
      end
    end

    context "無効なパラメータで" do
      it "ルームを作成できない" do
        expect {
          post rooms_path, params: { room: { name: "" } }
        }.not_to change(Room, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH /rooms/:id/join" do
    context "ルームが待機中で参加できる場合" do
      it "ルームに参加できる" do
        room.update(status: "waiting", participant: nil)
        patch join_room_path(room)
        expect(response).to redirect_to(room_path(room))
        follow_redirect!
        expect(response.body).to include("ルームに参加しました")
        expect(room.reload.participant).to eq(user)
      end
    end

    context "ルームが参加済みまたは他の状態の場合" do
      it "ルームに参加できない" do
        room.update(status: "playing", participant: user)
        patch join_room_path(room)
        expect(response).to redirect_to(room_path(room))
        follow_redirect!
        expect(response.body).to include("参加できません")
      end
    end
  end

  describe "PATCH /rooms/:id/finish" do
    context "ホストが試合を終了する場合" do
      it "試合を終了できる" do
        room.update(status: "playing", participant: create(:user))
        patch finish_room_path(room), params: { room: { result: "win" } }
        expect(response).to redirect_to(room_path(room))
        follow_redirect!
        expect(response.body).to include("試合が終了しました")
        expect(room.reload.status).to eq("closed")
      end
    end

    context "ホスト以外が試合を終了しようとする場合" do
      it "試合を終了できない" do
        other_user = create(:user)
        room.update(status: "playing", participant: other_user)
        sign_in other_user
        patch finish_room_path(room), params: { room: { result: "win" } }
        expect(response).to redirect_to(room_path(room))
        follow_redirect!
        expect(response.body).to include("試合の終了処理ができません")
      end
    end

    context "試合が終了できない状態の場合" do
      it "試合を終了できない" do
        room.update(status: "waiting", participant: nil)
        patch finish_room_path(room), params: { room: { result: "win" } }
        expect(response).to redirect_to(room_path(room))
        follow_redirect!
        expect(response.body).to include("試合の終了処理ができません")
      end
    end
  end
end
