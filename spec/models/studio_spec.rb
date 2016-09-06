require 'rails_helper'

RSpec.describe Studio, :type => :model do

	let :year do
		Fabricate :year
	end

	let(:studio) do
		Fabricate(:studio, year: year)
	end

	let!(:student) do
		Fabricate(:user, studio: studio, year: year)
	end


	describe 'associations' do
	  describe "students" do
	  	it "has students" do
	  		expect(studio.students).to eq([student])
	  	end
	  end

	  describe "posts" do
	  	it "has posts" do
		  	posts = []
		  	2.times do
		  		posts << Fabricate(:post, authors: [student], studio: studio, year: year)
		  	end
		  	expect(studio.posts).to match_array(posts)
		  end
	  end
	end
end
