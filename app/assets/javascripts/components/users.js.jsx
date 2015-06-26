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
	
	addUser: function(user){
		var users_ = React.addons.update(this.state.users, { $unshift: [user] })
		this.setState({
			users: users_
		});
	},
	deleteUser: function(user){
		var that = this;
		console.log("userId:", user);
		$.ajax({
			url: "/admin/users/"+user.id,
			method: 'delete',
			success: function(res){
		    var index = that.state.users.indexOf(user);
				var users_ = React.addons.update(that.state.users, { $splice: [[index, 1]] })
				that.setState({users: users_});
			},
		});
	},
	createStudio: function(studioName){
		var that = this;
		$.ajax({
			href: 'studios',
			data: {
				name: studioName
			},
			success: function(res){
				var studios = that.state.studios.splice();
				studios.push(res);
				that.setState(studios);
			},
		});
		var studios = this.state.studios.splice();
	},
	userTr: function(user){
		var that = this;
		var deleteUser = function(){
			that.deleteUser(user);
		};
		var updateUser = function(property){
			var userId = user.id;
			return function(value){
				var user = _.find(that.state.users, function(user_){
					return user_.id == userId;
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
					url: '/admin/users/'+userId,
					method: 'PATCH',
					data: data, 
					success: success
				});
			}
		};
		return (
			<Reactable.Tr className={"user " + user.role} key={user.id} data={user} data-user-id={user.id} column={['name', 'email']}>
				<Reactable.Td column="role_">
					<Select name='role' value={user.role} options={that.state.roles.map(function(role){
						return {value: role, label: role};
					})} onChange={updateUser('role')}
					searchable={false} clearable={false}
					/>
				</Reactable.Td>
				<Reactable.Td column="studio_">
					<Select 
						allowCreate={true}
						onCreateValue={this.createStudio}
						name='studio' 
						value={user.studio ? user.studio.name : null} 
						options={that.state.studios.map(function(s){return {value:s.name, label:s.name};})} 
						onChange={updateUser('studio')}
					placeholder="Select studio..."
					/>
				</Reactable.Td>
				<Reactable.Td column="actions">
					<button className="btn btn-xs btn-danger" onClick={deleteUser}>
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
					]} sortable={['name', 'email', 'role', 'studio']} filterable={['email', 'name', 'role', 'sciper', 'studio']} filterPlaceholder="Filter">
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
