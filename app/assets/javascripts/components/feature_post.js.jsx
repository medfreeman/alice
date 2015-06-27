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
			that.setState({processing: true});
			$.ajax({
				url: '/posts/'+ that.state.post.id +'/feature',
				method: 'post',
				data: {
					featured: !that.state.post.featured
				},
				success: function(res){
					that.setState({
						processing: false,
						post: res
					});
				},
			});
		}	
	},
  render: function() {
  	var classes = ["fa", (this.state.post.featured ? 'fa-star featured' : 'fa-star-o unfeatured')];
  	classes.push(this.state.processing ? 'loading' : null);
    return <i className={classes.join(' ')} onClick={this.featurePost}></i>;
  }
});
