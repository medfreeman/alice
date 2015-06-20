# Generated with RailsBricks
# Initial seed file to use with Devise User Model
User.delete_all
Post.delete_all
Studio.delete_all
Participation.delete_all
# Temporary admin account
u = User.new(
    email: "admin@epfl.ch",
    password: "topsecret",
    password_confirmation: "topsecret",
    admin: true
)
u.save!

d = Fabricate(:user, role: :director, name: 'director', email: "director@epfl.ch")
pellacani = Fabricate(:studio, name: "pellacani", director: d)
pellacani.students << Fabricate(:user, email: "student@epfl.ch", name: 'student')

5.times do |i|
	Fabricate(:user, email: "real_email_#{i}@epfl.ch")
end
Fabricate(:post, body: "student's first post", authors: [pellacani.students.first], studio: pellacani)