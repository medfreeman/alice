var Table = Reactable.Table;

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
	handleDelete: function(e){
		console.log("e:", e);
	},
	addUser: function(user){
		var users = this.state.users.slice();
		users.push(user);
		this.setState({
			users: users
		});
	},
	userTr: function(user){
		var that = this;
		return (
			<Reactable.Tr key={user.id} data={user} column={['name', 'email']}>
				<Reactable.Td column="Actions">
					<button className="btn btn-xs btn-danger" handleClick={this.handleDelete}>
						Delete
					</button>
				</Reactable.Td>
			</Reactable.Tr>
		);
	},
	render: function(){
		var that = this;
		return (
			<div className="users">
				<h2 className="title">Users</h2>
				<UserForm handleNewUser={this.addUser}/>
				<Table className="table table-bordered"  column={['name', 'email']} sortable={['name', 'email', 'studio', 'role']} filterable={['email', 'name', 'role', 'sciper', 'studio']}>
					{ 
						this.state.users.map(function(user, index){
							return that.userTr(user);
						})
					}
				</Table>
			</div>
		);
	},
});
