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

d = Fabricate(:user, role: :director, email: "director@epfl.ch")
pellacani = Fabricate(:studio, name: "pellacani", director: d)
pellacani.students << Fabricate(:user, email: "walid@epfl.ch")

5.times do |i|
	Fabricate(:user, email: "real_email_#{i}@epfl.ch")
end
Fabricate(:post, authors: [pellacani.students.first])