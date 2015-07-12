var DeleteStudio = React.createClass({
	getInitialState: function(){
		return {
			studio: this.props.studio
		}
	},
	deleteStudio: function(e){
		if(confirm('Do you really want to delete studio '+this.state.studio.name+'?'))
		{
			var self = this;
			var success = function(res){
				$(self.getDOMNode()).parents('li.studio').fadeOut(function(){
					$(this).remove()
				});
			};
			$.ajax({
				url: '/studios/'+self.state.studio.id,
				method: 'DELETE',
				success: success,
				error: function(e){
					alert('Studio could not be deleted.')
				}
			});
		}
	},
  render: function() {
    return <i className="icon delete" onClick={this.deleteStudio}></i>;
  }
});
