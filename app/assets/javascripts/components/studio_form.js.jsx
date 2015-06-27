var StudioForm = React.createClass({
	getDefaultProps: function(){
		return {
			handleNewStudio: function(){
				alert('nothing to handle the new studio!');
			}
		}
	},
	getInitialState: function(){
		return {
			loading: true,
			name:    '',
			errors: {}
		}
	},
	newStudio: function(e){
		var that = this;
		this.setState({
			loading: true
		});
		var success = function(res){
			that.props.handleNewStudio(res);
			that.setState(that.getInitialState());
		};
		$.ajax({
			url: "/studios",
			method: 'POST',
			data: {
				studio: {
					name: that.state.name
				}
			},
			success: success,
			error: function(res){
				that.setState({
					loading: false,
					errors: res.responseJSON.errors
				});
			}
		});
	},
	handleChange: function(e){
		this.setState({
			name: e.target.value
		})
	},
  render: function() {
  	console.log("this.state.errors:", this.state.errors);
    return (
    	<div>
    		<FormErrors errors={this.state.errors}/>
	    	<input name="name" placeholder="studio name" onChange={this.handleChange} value={this.state.name} />
	    	<button className="btn btn-xs btn-primary" onClick={this.newStudio} disabled={this.loading}>
	    		Add Studio
	    	</button>
	    </div>
    );
  }
});
