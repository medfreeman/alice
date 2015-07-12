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
			console.log("res:", res);
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
			dataType: 'json',
			success: success,
			error: function(res){
				console.error("Error creating studio:", res);
				that.setState({
					loading: false,
					errors: res.JSONResponse.errors
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
    	<div className="ui form fields">
    		<FormErrors errors={this.state.errors}/>
	    	<input clasName="field" name="name" placeholder="studio name" onChange={this.handleChange} value={this.state.name} />
	    	<button className="ui button" onClick={this.newStudio} disabled={this.loading}>
	    		<i className="add icon"></i>Add Studio
	    	</button>
	    </div>
    );
  }
});
