class EditAllThatAppliesQuestionForm < EditQuestionForm 
	model :all_that_applies_question

	def validate_and_save(question_params)
		if super
			@me = AbstractQuestion.find id
			form_2_choices(question_params)
			return false unless @me.valid?
			@me.save
			return true
		else
			return false
		end
	end

	def form_2_choices(question_params)
		choices = Hash.new
		ch = question_params["options"]["form_choices"]
		ch.each do |k, v|
			if k =~ /choice_(.*)/
				new_key = ch[k]
				new_value = ch["correct_#{$1}"] != "0"
				next if new_key.blank?
				choices[new_key] = new_value
			end
		end
		@me.choices = choices
		@me.options.delete "options"
	end


	def populate_form_fields
		form_choices = Hash.new
		@model.choices.each_with_index do |h, i|
			k = h[0]
			v = h[1]
			form_choices["choice_#{i}"] = k
			form_choices["correct_#{i}"] = v
		end
		@model.options["options"] = Hash.new
		@model.options["options"]["form_choices"] = form_choices
	end
end