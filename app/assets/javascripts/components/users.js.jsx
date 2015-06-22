Users = React.createClass({
	getInitialState: function(){
			return {
				users: this.props.data
			};
	},
	getDefaultProps: function(){
		return {
			users: []
		};
	},
	addUser: function(user){
		var users = this.state.users.slice();
		users.push(user);
		this.setState({
			users: users
		});
	},
	render: function(){
		return (
			<div className="users">
				<h2 className="title">Users</h2>
				<UserForm handleNewUser={this.addUser}/>
				<table className="table table-bordered">
					<thead>
						<th>SCIPER</th>
						<th>Name</th>
						<th>Email</th>
						<th>Role</th>
						<th>Studio</th>
					</thead>
					<tbody>
						{this.state.users.map(function(user){
							return <User key={user.id} user={user}/>
						})}
					</tbody>
				</table>
			</div>
		);
	},
});