class DailyDigest
  def send_digest
    @questions_ids = Question.where("created_at > ?", 1.day.ago).pluck(:id)
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, @questions_ids).deliver_later
    end
  end
end
