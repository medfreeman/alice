# Generated with RailsBricks
# Initial seed file to use with Devise User Model
User.delete_all
Post.delete_all
Studio.delete_all
Participation.delete_all
Year.delete_all

y1 = Year.create!(slug: 'y1', name: 'y1')
# Temporary admin account
u = User.new(
    email: "admin@epfl.ch",
    password: "topsecret",
    password_confirmation: "topsecret",
    admin: true,
    year: y1
)
u.skip_confirmation!
u.save!
image = File.open("#{Rails.root}/public/red_sun.jpg")

y2 = Year.create!(slug: 'master', name: 'y1')

d = Fabricate(:user, role: :director, name: 'director', email: "director@epfl.ch", year: y1)
pellacani = Fabricate(:studio, name: "pellacani", director: d, year: y1)
pellacani.students << Fabricate(:user, email: "student@epfl.ch", name: 'pellacani', super_student: true, year: y1)
rudi = Fabricate(:studio, name: "rudi", year: y2)
rudi.students << Fabricate(:user, name: 'rudi', year: y2)

2.times do |i|
	Fabricate(:user, email: "real_email_#{i}_y1@epfl.ch", year: y1)
end
2.times do |i|
	Fabricate(:user, email: "real_email_#{i}_y2@epfl.ch", year: y2)
end
Fabricate(:post, body: "student's first post", authors: [pellacani.students.first], studio: pellacani, featured: true, thumbnail: image, year: y1)
Fabricate(:post, body: "student's first post", authors: [rudi.students.first], studio: rudi, thumbnail: image, year: y2)
Fabricate(:post, body: "student's featured post", authors: [rudi.students.first], studio: rudi, featured: true, thumbnail: image, year: y2)

23.times do |i|
	Fabricate(:post, body: "student's #{i}th post", authors: [pellacani.students.first], studio: pellacani, featured: true, thumbnail: image, year: y1)
end