require 'spec_helper'

class SampleQuestion < AbstractQuestion
	option_accessor :opt1, :opt2

	def build(question_text, answer)
		super()
		self.content = question_text
		self.options["answer"] = answer.to_s # please only use string hash keys
	end
end

describe "SampleQuestion inherited from AbstractQuestion" do

	let!(:sample_text) {"What's the meaning of life?"}
	let!(:sample_answer) {"42"}
  	let!(:question) do 
  		q = SampleQuestion.new
  		q.build sample_text, sample_answer 
  		q
  	end

  	let(:sample_comment) {"Some random comment that shouldn't be there"}

	it "should have a credit given for its completion"

	it "should have a question text" do
		expect(question.content).to eq(sample_text)
	end

	it "should have option_accessor working" do
		question.opt1 = "some value"
		expect(question.opt1).to eq("some value")
		question.opt2 = "some other value"
		expect(question.opt2).to eq("some other value")
	end

	it "should have opt_ accessors working" do
		expect(question.opt_answer).to eq(sample_answer)
		question.opt_comment = sample_comment
		expect(question.opt_comment).to eq(sample_comment)
	end

	it "should be able to store the metadata in the database and retrieve it back" do
		q = SampleQuestion.new
  		q.build sample_text, sample_answer
  		q.opt_blah = sample_comment
  		q.opt2 = "some value"
  		q.save

  		expect(q.id).not_to be_nil
  		q2 = SampleQuestion.find(q.id)
  		expect(q2.opt_blah).to eq(sample_comment)
  		expect(q2.opt2).to eq("some value")
	end

	it "should have the autograde() function" do
		begin
			grade = question.grade(nil)
		rescue
			fail
		end
	end

	it "should have a function returning the path to its partial" do
		begin
			path = question.partial
		rescue
			fail
		end
	end
end