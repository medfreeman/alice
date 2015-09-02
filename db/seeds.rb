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
u.skip_confirmation!
u.save!
image = File.open("#{Rails.root}/public/red_sun.jpg")

d = Fabricate(:user, role: :director, name: 'director', email: "director@epfl.ch")
pellacani = Fabricate(:studio, name: "pellacani", director: d)
pellacani.students << Fabricate(:user, email: "student@epfl.ch", name: 'pellacani')
rudi = Fabricate(:studio, name: "rudi")
rudi.students << Fabricate(:user, name: 'rudi')

5.times do |i|
	Fabricate(:user, email: "real_email_#{i}@epfl.ch")
end
Fabricate(:post, body: "student's first post", authors: [pellacani.students.first], studio: pellacani, featured: true, thumbnail: image)
Fabricate(:post, body: "student's first post", authors: [rudi.students.first], studio: rudi, thumbnail: image)
Fabricate(:post, body: "student's featured post", authors: [rudi.students.first], studio: rudi, featured: true, thumbnail: image)