Fabricator(:post) do
	title "Some Great Post"
	body "The post's body"
	thumbnail_file_name                        { 'chapter.png' }
	thumbnail_content_type     { 'image/jpg' }
	thumbnail_file_size                        { 1024 }
end
