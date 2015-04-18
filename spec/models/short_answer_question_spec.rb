require 'spec_helper'

describe "ShortAnswerQuestion" do
	def grade(answer)
		question.autograde(answer, quiz.id)[:credit]
	end

	let(:points) { 10 }

	let!(:question) do 
		q = create :short_answer_question, :content => "Who is fluffier, puppies or kittens?"
		q.my_solution = "kittens"
		q.save
		q
	end
  	let!(:quiz) do
   		pq = build :quiz, retake: false, is_draft: false
    	pq.save(:validate => false)
    	pq.relationships.create!  question_id: question.id,
                              number: 1,
                              points: points
    	pq
  	end

	let!(:question_no_answer) { create :short_answer_question, :content => "Who is fluffier, puppies or kittens?" }
  	let!(:quiz_no_answer) do
   		pq = build :quiz, retake: false, is_draft: false
    	pq.save(:validate => false)
    	pq.relationships.create!  question_id: question_no_answer.id,
                              number: 1,
                              points: points
    	pq
  	end

	it "should give full credit if the solution matches the answer, ignoring the case" do
		expect(grade("kittens")).to eq points
		expect(grade("KiTtEnS")).to eq points
	end

	it "should give no credit if the solution doesn't match the answer" do
		expect(grade("puppies")).to eq 0
		expect(grade("this quiz sucks")).to eq 0
	end

	it "should give no credit if the solution is not provided" do
		my_grade = question_no_answer.autograde("kittens", quiz.id)[:credit]
		expect(my_grade).to eq 0
	end
end