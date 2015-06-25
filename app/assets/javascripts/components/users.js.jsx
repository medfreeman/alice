var Table = Reactable.Table;

Users = React.createClass({
	getInitialState: function(){
			return {
				users: this.props.users,
				roles: this.props.roles,
				studios: this.props.studios,
			};
	},
	getDefaultProps: function(){
		return {
			users: []
		};
	},
	handleChange: function(e, property, value){
		var that = this;
		var userId = $(e.target).parents('.user').data('user-id');
		var user = _.find(this.state.users, function(user){
			return user.id == userId;
		});
		var data = {
			user: {}
		};
		data.user[property] = value;
		var success = function(res){
      var index = that.state.users.indexOf(user);

      var users_ = React.addons.update(that.state.users, { $splice: [[index, 1, res.user]] });
      that.setState({users: users_});
		};
		$.ajax({
			url: '/users/'+user.id,
			method: 'PATCH',
			data: data, 
			success: success
		});
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
			<Reactable.Tr className={"user " + user.role} key={user.id} data={user} data-user-id={user.id} column={['name', 'email']}>
				<Reactable.Td column="role_">
					<Selectar name='role' value={user.role} options={that.state.roles} handleChange={that.handleChange}/>
				</Reactable.Td>
				<Reactable.Td column="studio_">
					<Selectar name='studio' value={user.role} options={that.state.studios.map(function(s){return [s.id, s.name];})} handleChange={that.handleChange}/>
				</Reactable.Td>
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
			<div className="users-table">
				<h2 className="title">Users</h2>
				<UserForm handleNewUser={this.addUser}/>
				<Table className="table table-bordered"  columns={[
					{
						key: 'sciper',
						label: 'SCIPER'
					},
					{
						key: 'name',
						label: 'Name'
					},
					{
						key: 'email',
						label: 'Email'
					},
					{
						key: 'role_',
						label: 'Role'
					},
					{
						key: 'studio_',
						label: 'Studio'
					},
					{
						key: 'actions', 
						label: 'Actions'
					}
					]} sortable={['name', 'email', 'studio', 'role']} filterable={['email', 'name', 'role', 'sciper', 'studio']} filterPlaceholder="Filter">
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
