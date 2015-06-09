# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
    email: "admin@epfl.ch",
    password: "topsecret",
    password_confirmation: "topsecret",
    admin: true
)
u.skip_confirmation!
u.save!

Fabricate(:post, author: u)