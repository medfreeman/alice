var FormErrors = React.createClass({
	getDefaultProps: function(){
		return {errors: {}}
	},
  render: function() {
  	var that = this;
  	var errors = _.keys(this.props.errors).map(function(key){
  		var messages = that.props.errors[key].map(function(msg){
  						return (<div>{key} {msg}</div>);
  					});
  		return (
  			<div>
  				{messages}
  			</div>
  		)
  	});
    return (
    	<div className="errors">
    		{errors}
    	</div>
    );
  }
});
