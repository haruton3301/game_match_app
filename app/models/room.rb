class Room < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  belongs_to :participant, class_name: "User", foreign_key: "participant_id", optional: true
  belongs_to :winner, class_name: "User", foreign_key: "winner_id", optional: true
  belongs_to :loser, class_name: "User", foreign_key: "loser_id", optional: true

  enum status: { waiting: 0, playing: 1, closed: 2 }

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }

  def finish_match(winner, loser)
    update(winner: winner, loser: loser, finished_at: Time.current, status: "closed")

    winner.increment!(:win_count)
    loser.increment!(:lose_count)
  end

  def join_participant(user)
    return false if participant.present? || status != "waiting"
    update(participant: user)
    update(status: "playing") if participant.present?
  end
end
