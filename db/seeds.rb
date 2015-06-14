# Generated with RailsBricks
# Initial seed file to use with Devise User Model
User.delete_all
Post.delete_all
Studio.delete_all
# Temporary admin account
u = User.new(
    email: "admin@epfl.ch",
    password: "topsecret",
    password_confirmation: "topsecret",
    admin: true
)
u.save!

pellacani = Fabricate(:studio, name: "pellacani")
2.times do 
	pellacani.students << Fabricate(:user)
end

Fabricate(:post, authors: [pellacani.students.first])