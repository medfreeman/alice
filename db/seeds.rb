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

Fabricate(:post, authors: [u])