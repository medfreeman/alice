var DeleteStudio = React.createClass({
	getInitialState: function(){
		return {
			studio: this.props.studio
		}
	},
	deleteStudio: function(e){
		var that = this;
		if(confirm('Do you really want to delete studio '+this.state.studio.name+'?'))
		{
			$.ajax({
				url: '/studios/'+that.state.studio.id,
				method: 'DELETE',
				success: function(res){
					$(e.target).parents('li.studio').fadeOut(function(){
						$(this).remove()
					});
				},
				error: function(e){
					alert('Studio could not be deleted.')
				}
			});
		}
	},
  render: function() {
    return <i className="fa-close" onClick={this.deleteStudio}></i>;
  }
});
