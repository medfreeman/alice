var Table = Reactable.Table;
var Users = React.createClass({
	getInitialState: function(){
			return {
				currentUser: this.props.current_user,
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
		var ajaxUpdateUser = function(userId, data){
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
				ajaxUpdateUser(userId, data);
			}
		};
		var saveUser = function(e){
			var userRow = $(e.target).parents('tr');
			var data = {
				user: {
					name: $('input[name="user[name]"]', userRow).val(),
					email: $('input[name="user[email]"]', userRow).val(),
				}
			};
			ajaxUpdateUser(user.id, data);
			editUserToggle();
		}
		var editUserToggle = function(){
			user.editable = !user.editable;
			var index = that.state.users.indexOf(user);
      var users_ = React.addons.update(that.state.users, { $splice: [[index, 1, user]] });
      that.setState({users: users_});
		};

		var userEmail, userName, editButton;
		if(user.editable)
		{
			userName = <input type="text" defaultValue={user.name} name="user[name]"/>;
			userEmail = <input type="text" defaultValue={user.email} name="user[email]"/>;
			editButton = (
				<button className="btn btn-xs btn-primary" onClick={saveUser}>
					Save
				</button>
			);
		}
		else
		{
			editButton = (
				<button className="btn btn-xs btn-primary" onClick={editUserToggle}>
					Edit
				</button>
			);
			userName = user.name;
			userEmail = user.email;
		}
		//console.log("userEmail, userName:", userEmail, userName);
		var actions = (
			<div>
				{editButton}
				<button className="btn btn-xs btn-danger" onClick={deleteUser}>
					Delete
				</button>
			</div>
		);
		return (
			<Reactable.Tr className={"user " + user.role} key={user.id} data={user} data-user-id={user.id}>
				<Reactable.Td column="name_">
					{userName}
				</Reactable.Td>
				<Reactable.Td column="email_">
					{userEmail}
				</Reactable.Td>
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
					{actions}
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
						key: 'name_',
						label: 'Name'
					},
					{
						key: 'email_',
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
