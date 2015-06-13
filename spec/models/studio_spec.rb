require 'rails_helper'

RSpec.describe Studio, :type => :model do

	let(:studio) do 
		Fabricate(:studio)
	end

	let!(:student) do 
		Fabricate(:user, studio: studio)
	end

  
  describe "students" do 
  	it "has students" do 
  		expect(studio.students).to eq([student])
  	end
  end

  describe "posts" do 

  	it "has posts" do 
	  	posts = []
	  	2.times do 
	  		posts << Fabricate(:post, authors: [student])
	  	end
	  	expect(studio.posts).to eq(posts)
	  end
  end
end
