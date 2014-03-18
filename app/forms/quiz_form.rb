# Form object for submissions
class QuizForm < Reform::Form
  property :lesson, virtual: true

  collection :new_submissions do
    property :question_content, virtual: true

    property :quiz_id
    property :question_id
    property :student_id
    property :content

    validates :quiz_id, :question_id, :student_id, presence: true
    validates :content, presence: true
  end

  def save(params)
    return false unless validate(params)
    params[:new_submissions_attributes].all? do |_, attrs|
      Submission.create attrs
    end
  end
end
