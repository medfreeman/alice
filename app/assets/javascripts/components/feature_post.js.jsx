var FeaturePost = React.createClass({
	getInitialState: function(){
		return {
			post: this.props.post,
			processing: false
		};
	},
	featurePost: function(e){
		var that = this;
		if(!this.state.processing)
		{
			that.state.processing = true;
			$.ajax({
				url: '/posts/'+ that.state.post.id +'/feature',
				method: 'post',
				data: {
					featured: !that.state.post.featured
				},
				success: function(res){
					that.state.processing = false;
					that.setState({post: res});
				},
			});
		}	
	},
  render: function() {
  	var classes = "fa " + (this.state.post.featured ? 'fa-heart featured' : 'fa-heart-o unfeatured');
    return <i className={classes} onClick={this.featurePost}></i>;
  }
});
