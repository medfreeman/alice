var FormErrors = React.createClass({
	getDefaultProps: function(){
		return {errors: {}}
	},
  render: function() {
  	var that = this;
  	var errors = _.keys(this.props.errors).map(function(key){
  		var messages = that.props.errors[key].map(function(msg){
  						return (<div className="header">{key} {msg}</div>);
  					});
  		return (
  			<div className="ui negative message">
          <i className="close icon"></i>
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
