var Selectar = React.createClass({
	render: function(){
		return (
			<select name="role" value={user.role} id={user} onChange={that.handleChange}>
				{
					that.state.roles.map(function(role_){
				  	return <option key={role_} value={role_}>{role_}</option>;
					})
				}
			</select>
		);
	}
});